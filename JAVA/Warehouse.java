
public class Warehouse {

	private String name;
	private int demand;

	Warehouse(String name, int demand) {
		this.name = name;
		this.demand = demand;

	}

	public String getName() {
		return name;
	}

	public int getDemand() {
		return demand;
	}

	public void getSupply(int amount) {
		demand = demand - amount;

	}

}
