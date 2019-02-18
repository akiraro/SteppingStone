import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;

import javafx.util.Pair;

public class Record {

	private HashMap<Pair<String, String>, Integer> costRecord = new HashMap<Pair<String, String>, Integer>();
	private HashMap<Pair<String, String>, Integer> costArchive = new HashMap<Pair<String, String>, Integer>();

	Record() {

	}

	public void addRecord(String[][] data, int xLength, int yLength) {
		for (int i = 0; i < xLength - 2; i++) {
			String wareName = data[0][i + 1];
			for (int j = 0; j < yLength - 2; j++) {
				String facName = data[j + 1][0];
				costRecord.put(new Pair(facName, wareName), Integer.parseInt(data[j + 1][i + 1]));
				costArchive.put(new Pair(facName, wareName), Integer.parseInt(data[j + 1][i + 1]));
			}
		}

	}

	public int getLowest() {
		int min = Collections.min(costRecord.values());
		return min;
	}

	public Pair getPair(int value) {
		Pair result = null;
		Collection<Integer> values = costRecord.values();
		Integer[] targetArray = values.toArray(new Integer[values.size()]);

		for (int i = 0; i < targetArray.length; i++) {
			if (value == targetArray[i]) {
				result = (Pair) costRecord.keySet().toArray()[i];
				break;
			}
		}

		return result;
	}

	public int getCost(String factoryName, String warehouseName) {
		Pair<String, String> pair = new Pair(factoryName, warehouseName);
		int result = costArchive.get(pair);
		return result;
	}

	public void removeData(Pair pair) {
		costRecord.remove(pair);
	}

}
