import java.util.Stack;

import javafx.util.Pair;

public class Manager {

	private Factory[] factoryArray;
	private Warehouse[] warehouseArray;
	private Record records;
	private String[][] table;
	private int xLength, yLength;
	private Stack<Pair> stackCoord = new Stack<>();
	private Stack<Pair> stackBackup = new Stack<>();
	private int lowestCost = 0;

	Manager(Factory[] factoryArray, Warehouse[] warehouseArray, Record record, int xLength, int yLength) {
		this.factoryArray = factoryArray;
		this.warehouseArray = warehouseArray;
		this.records = record;
		this.xLength = xLength;
		this.yLength = yLength;
		table = new String[factoryArray.length + 2][warehouseArray.length + 2];

		for (int i = 0; i < factoryArray.length; i++) {
			table[i + 1][0] = factoryArray[i].getName();
		}
		for (int j = 0; j < warehouseArray.length; j++) {
			table[0][j + 1] = warehouseArray[j].getName();
		}

		for (int i = 0; i < factoryArray.length; i++) {
			for (int j = 0; j < warehouseArray.length; j++) {
				table[i + 1][j + 1] = Integer.toString(0);
			}
		}
	}

	public void manage() throws Exception {
		boolean flag = true;

		while (flag) {
			Factory targetFactory = null;
			Warehouse targetWarehouse = null;
			int xIndex = 0;
			int yIndex = 0;

			flag = !checkAllEmpty();
			if (flag == false) {
				break;
			}

			int lowestCost = records.getLowest();
			Pair pair = records.getPair(lowestCost);
			String factory = pair.getKey().toString();
			String warehouse = pair.getValue().toString();

			for (int i = 0; i < factoryArray.length; i++) {
				if (factoryArray[i].getName() == factory) {
					targetFactory = factoryArray[i];
					yIndex = i;
					break;
				}
			}

			for (int i = 0; i < warehouseArray.length; i++) {
				if (warehouseArray[i].getName() == warehouse) {
					targetWarehouse = warehouseArray[i];
					xIndex = i;
					break;
				}
			}

			if (!targetFactory.isEmpty()) {
				doDelivery(targetFactory, targetWarehouse, xIndex, yIndex);
				records.removeData(pair);
			} else {
				records.removeData(pair);
			}
		}
		int length = 0;
		// check length of empty cells
		for (int i = 0; i < xLength - 2; i++) {
			for (int j = 0; j < yLength - 2; j++) {

				if (Integer.parseInt(table[j + 1][i + 1]) != 0) {
					// System.out.println(Integer.parseInt(table[j + 1][i +
					// 1]));
					length += 1;
				}
			}
		}

		if (length < ((xLength - 2) + (yLength - 2) - 1)) {
			throw new Exception("DEGENERECY CASE");
		}

		//

		System.out.println("---- GREEDY ALGORITHM RESULT -----\n");
		printTable(table);

	}

	public void doDelivery(Factory factory, Warehouse warehouse, int xIndex, int yIndex) {

		int factorySupply = 0;
		int warehouseDemand = 0;

		factorySupply = factory.getSupply();
		warehouseDemand = warehouse.getDemand();

		if (factorySupply == 0 || warehouseDemand == 0) {

		} else if (factorySupply >= warehouseDemand) {
			factory.sendSupply(warehouseDemand);
			warehouse.getSupply(warehouseDemand);
			table[yIndex + 1][xIndex + 1] = Integer
					.toString(Integer.parseInt(table[yIndex + 1][xIndex + 1]) + warehouseDemand);

		} else {

			factory.sendSupply(factorySupply);
			warehouse.getSupply(factorySupply);
			table[yIndex + 1][xIndex + 1] = Integer
					.toString(Integer.parseInt(table[yIndex + 1][xIndex + 1]) + factorySupply);

		}

	}

	public boolean checkAllEmpty() {
		boolean flag = true;
		for (int i = 0; i < factoryArray.length; i++) {
			// System.out.println(factoryArray[i].isEmpty());
			flag &= factoryArray[i].isEmpty();
		}
		return flag;

	}

	public void printTable(String[][] data) {
		for (int i = 0; i < factoryArray.length + 1; i++) {
			for (int j = 0; j < warehouseArray.length + 1; j++) {
				System.out.print(data[i][j] + "\t");
			}
			System.out.print("\n");
		}
	}

	public void steppingStones() {
		System.out.println("\n\n\n-----STEPPING STONES ALGORITHM-----");
		int length = 0;
		int xIndex = 0;
		int yIndex = 0;
		int loopArrayIndex = 0;
		boolean xflag = true;
		boolean yflag = false;
		boolean whileFlag = true;
		String currentFactory = "";
		String currentWarehouse = "";

		// check length of empty cells
		for (int i = 0; i < xLength - 2; i++) {
			for (int j = 0; j < yLength - 2; j++) {
				if (Integer.parseInt(table[j + 1][i + 1]) == 0) {
					length += 1;
				}
			}
		}
		//

		int i = 0;
		int j = -1;
		while (length != 0) {

			if (j == xLength - 3) {
				j = 0;
				i++;
			} else {
				j++;
			}

			xIndex = 0;
			yIndex = 0;
			xflag = true;
			yflag = false;
			whileFlag = true;
			loopArrayIndex = 0;

			if (Integer.parseInt(table[i + 1][j + 1]) == 0) {
				String loopArray[][] = new String[(xLength - 1) * (yLength - 1)][];
				String[] dummyArray = { table[i + 1][0], table[0][j + 1] };
				loopArray[loopArrayIndex] = dummyArray;
				loopArrayIndex += 1;
				xIndex = j + 1;
				yIndex = i + 1;
				stackCoord.push(new Pair(xIndex, yIndex));
				table[i + 1][j + 1] = null;
				System.out.println("\n\n(Empty cell found at " + table[i + 1][0] + " : " + table[0][j + 1] + ")");

				while (whileFlag) {

					if (xflag) {
						boolean loop = true;

						for (int k = (xIndex + 1) % (xLength - 1);; k++) {
							k = k % (xLength - 1);
							if (k == 0) {
								k = 1;
							}

							try {
								if ((k != xIndex) && Integer.parseInt(table[yIndex][k]) != 0) {
									currentFactory = table[yIndex][0];
									currentWarehouse = table[0][k];
									System.out.println(
											"Adding " + currentFactory + " : " + currentWarehouse + " to stack");
									dummyArray = new String[] { currentFactory, currentWarehouse };
									loopArray[loopArrayIndex] = dummyArray;
									loopArrayIndex += 1;
									xIndex = k;
									stackCoord.push(new Pair(xIndex, yIndex));
									xflag = !xflag;
									yflag = !yflag;
									break;
								} else if (k == (xIndex + 1) % (xLength - 1)) {
									if (loop) {
										loop = false;
									} else {
										loopArrayIndex -= 1;
										loopArray[loopArrayIndex] = new String[] { null, null };
										loopArrayIndex -= 1;
										loopArray[loopArrayIndex] = new String[] { null, null };
										Pair dummyPair = stackCoord.pop();
										dummyPair = stackCoord.pop();
										xIndex = (Integer) dummyPair.getKey();
										yIndex = (Integer) dummyPair.getValue();
										break;
									}
								}
							} catch (Exception e) {
								System.out.println(e);
							}

						}
					} else if (yflag) {
						for (int h = 0; h < yLength - 1; h++) {
							if (table[h][xIndex] == null) {
								whileFlag = false;
								table[h][xIndex] = "0";
								break;
							}
						}
						if (whileFlag == false) {
							break;
						}

						boolean loop = true;

						for (int k = (yIndex + 1) % (yLength - 1);; k++) {
							int dum = (yIndex + 1) % (yLength - 1);
							k = k % (yLength - 1);
							if (k == 0) {
								k = 1;
							}
							if (dum == 0) {
								dum = 1;
							}
							try {
								if ((whileFlag == true) && (k != yIndex) && (Integer.parseInt(table[k][xIndex]) != 0)) {
									currentFactory = table[k][0];
									currentWarehouse = table[0][xIndex];
									System.out.println(
											"Adding " + currentFactory + " : " + currentWarehouse + " to stack");
									dummyArray = new String[] { currentFactory, currentWarehouse };
									loopArray[loopArrayIndex] = dummyArray;
									loopArrayIndex += 1;
									yIndex = k;
									stackCoord.push(new Pair(xIndex, yIndex));
									xflag = !xflag;
									yflag = !yflag;

									break;
								} else if (k == dum) {
									if (loop) {

										loop = false;
									} else {
										loopArrayIndex -= 1;
										loopArray[loopArrayIndex] = new String[] { null, null };
										Pair dummyPair = stackCoord.pop();
										xIndex = (Integer) dummyPair.getKey();
										yIndex = (Integer) dummyPair.getValue();
										xflag = !xflag;
										yflag = !yflag;
										break;
									}

								}
							} catch (Exception e) {
								System.out.println(e);
								break;
							}
						}

					}

				}
				analyze(loopArray);

				length -= 1;
			} else {
			}

		}
	}

	public void analyze(String[][] data) {
		boolean positive = true;
		System.out.println("Analyzing the net worth ......");
		System.out.println("Stack size: " + stackCoord.size());
		Integer[] dummyArray = new Integer[stackCoord.size()];
		int result = 0;
		for (int a = 0; a < data.length; a++) {
			try {
				if (positive) {
					result = result + records.getCost(data[a][0], data[a][1]);
					positive = false;
					dummyArray[a] = records.getCost(data[a][0], data[a][1]);
				} else {
					result = result - records.getCost(data[a][0], data[a][1]);
					positive = true;
					dummyArray[a] = records.getCost(data[a][0], data[a][1]);
				}

			} catch (Exception e) {
				break;
			}

		}

		System.out.println("Stackbackup size : " + stackBackup.size());
		System.out.println("result is " + result);
		if (result < lowestCost) {
			lowestCost = result;
			stackBackup = (Stack<Pair>) stackCoord.clone();
		}

	}

	public void reDoDelivery() {
		String[] demandArray = new String[stackBackup.size()];
		int lowestDemand = 1000;
		Pair emptyCellPair = stackBackup.get(0);
		Factory factory = factoryArray[(Integer) emptyCellPair.getValue() - 1];
		Warehouse warehouse = warehouseArray[(Integer) emptyCellPair.getKey() - 1];

		int requiredDemand = warehouse.getDemand();
		int index = 1;

		for (int i = 0; i < stackBackup.size(); i++) {
			Pair pair = stackBackup.get(i);
			String dummyInt = table[(Integer) pair.getValue()][(Integer) pair.getKey()];

			if (Integer.parseInt(dummyInt) != 0 && Integer.parseInt(dummyInt) < lowestDemand) {
				lowestDemand = Integer.parseInt(dummyInt);
			}
		}

		boolean positive = true;
		for (int i = 0; i < stackBackup.size(); i++) {
			Pair pair = stackBackup.get(i);

			if (positive) {
				table[(Integer) pair.getValue()][(Integer) pair.getKey()] = Integer.toString(
						Integer.parseInt(table[(Integer) pair.getValue()][(Integer) pair.getKey()]) + lowestDemand);
				positive = false;
			} else {
				table[(Integer) pair.getValue()][(Integer) pair.getKey()] = Integer.toString(
						Integer.parseInt(table[(Integer) pair.getValue()][(Integer) pair.getKey()]) - lowestDemand);
				positive = true;
			}

		}
		System.out.println("\n\n---- STEPPING STONE ALGORITHM RESULT -----\n");
		printTable(table);

	}

}
