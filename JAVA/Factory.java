import java.util.Collections;
import java.util.TreeMap;

public class Factory {

	private String name;
	private int supply;

	private TreeMap<String, Integer> cost_map = new TreeMap<String, Integer>();

	Factory(String name, int supply) {
		this.name = name;
		this.supply = supply;

	}

	public String getName() {
		return name;
	}

	public int getSupply() {
		return supply;
	}

	public void sendSupply(int amount) {
		supply = supply - amount;
	}

	public int getLowestCost() {
		int min = Collections.min(cost_map.values());
		return min;
	}

	public boolean isEmpty() {
		if (supply == 0) {
			return true;
		} else {
			return false;
		}
	}
}
