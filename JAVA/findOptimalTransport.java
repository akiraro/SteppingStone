import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.TreeMap;

public class findOptimalTransport {
	public static int xLength = 0;
	public static int yLength = 0;

	public static void main(String[] args) throws FileNotFoundException {
		TreeMap<String, Integer> cost_map = new TreeMap<String, Integer>();

		Scanner scanner = new Scanner(System.in);
		System.out.print(
				"AUTHOR : HAZIQ HAFIZI BIN MD YUSOF (8346453)\n\n ---REMINDER---\nMaksure textfile is in the same directory\n -------------\n\n");
		System.out.print("Enter filename: ");
		String myString = scanner.next();

		/* Read file */

		File fileDummy = new File(myString);
		Scanner inputDummy = new Scanner(fileDummy);
		while (inputDummy.hasNextLine()) {
			yLength += 1;
			if (xLength == 0) {
				xLength = inputDummy.nextLine().split(" ").length;
			} else {
				inputDummy.nextLine();
			}
		}
		inputDummy.close();

		String[][] data = new String[yLength][];
		Factory[] factoryArray = new Factory[yLength - 2];
		Warehouse[] warehouseArray = new Warehouse[xLength - 2];
		Record records = new Record();
		int index = 0;

		File file = new File(myString);
		Scanner input = new Scanner(file);
		while (input.hasNextLine() && index < data.length) {
			data[index] = input.nextLine().split(" ");
			index++;
		}
		input.close();
		/* --------------- */

		/* Create array for factory & warehouse */
		for (int i = 1; i < yLength - 1; i++) {

			factoryArray[i - 1] = new Factory(data[i][0], Integer.parseInt(data[i][xLength - 1].split("\t")[0]));

		}
		for (int i = 1; i < xLength - 1; i++) {
			warehouseArray[i - 1] = new Warehouse(data[0][i], Integer.parseInt(data[yLength - 1][i]));
		}

		records.addRecord(data, xLength, yLength);
		Manager manager = new Manager(factoryArray, warehouseArray, records, xLength, yLength);
		try {
			manager.manage();
		} catch (Exception e) {
			System.out.println(e);
			System.exit(1);
		}
		manager.steppingStones();
		manager.reDoDelivery();

	}
}
