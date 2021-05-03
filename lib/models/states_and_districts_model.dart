class StatesAndDistricts {
  List<String> andamanAndNicobarIslandsUT;
  List<String> andhraPradesh;
  List<String> arunachalPradesh;
  List<String> assam;
  List<String> bihar;
  List<String> chandigarhUT;
  List<String> chhattisgarh;
  List<String> dadraAndNagarHaveliAndDamanDiuUT;
  List<String> delhiNCT;
  List<String> goa;
  List<String> gujarat;
  List<String> haryana;
  List<String> himachalPradesh;
  List<String> jammuKashmirUT;
  List<String> jharkhand;
  List<String> karnataka;
  List<String> kerala;
  List<String> ladakhUT;
  List<String> lakshadweepUT;
  List<String> madhyaPradesh;
  List<String> maharashtra;
  List<String> manipur;
  List<String> meghalaya;
  List<String> mizoram;
  List<String> nagaland;
  List<String> odisha;
  List<String> puducherryUT;
  List<String> punjab;
  List<String> rajasthan;
  List<String> sikkim;
  List<String> tamilNadu;
  List<String> telangana;
  List<String> tripura;
  List<String> uttarPradesh;
  List<String> uttarakhand;
  List<String> westBengal;

  StatesAndDistricts(
      {this.andamanAndNicobarIslandsUT,
        this.andhraPradesh,
        this.arunachalPradesh,
        this.assam,
        this.bihar,
        this.chandigarhUT,
        this.chhattisgarh,
        this.dadraAndNagarHaveliAndDamanDiuUT,
        this.delhiNCT,
        this.goa,
        this.gujarat,
        this.haryana,
        this.himachalPradesh,
        this.jammuKashmirUT,
        this.jharkhand,
        this.karnataka,
        this.kerala,
        this.ladakhUT,
        this.lakshadweepUT,
        this.madhyaPradesh,
        this.maharashtra,
        this.manipur,
        this.meghalaya,
        this.mizoram,
        this.nagaland,
        this.odisha,
        this.puducherryUT,
        this.punjab,
        this.rajasthan,
        this.sikkim,
        this.tamilNadu,
        this.telangana,
        this.tripura,
        this.uttarPradesh,
        this.uttarakhand,
        this.westBengal});

  StatesAndDistricts.fromJson(Map<String, dynamic> json) {
    andamanAndNicobarIslandsUT =
        json['Andaman and Nicobar Islands (UT)'].cast<String>();
    andhraPradesh = json['Andhra Pradesh'].cast<String>();
    arunachalPradesh = json['Arunachal Pradesh'].cast<String>();
    assam = json['Assam'].cast<String>();
    bihar = json['Bihar'].cast<String>();
    chandigarhUT = json['Chandigarh (UT)'].cast<String>();
    chhattisgarh = json['Chhattisgarh'].cast<String>();
    dadraAndNagarHaveliAndDamanDiuUT =
        json['Dadra and Nagar Haveli and Daman & Diu (UT)'].cast<String>();
    delhiNCT = json['Delhi (NCT)'].cast<String>();
    goa = json['Goa'].cast<String>();
    gujarat = json['Gujarat'].cast<String>();
    haryana = json['Haryana'].cast<String>();
    himachalPradesh = json['Himachal Pradesh'].cast<String>();
    jammuKashmirUT = json['Jammu & Kashmir (UT)'].cast<String>();
    jharkhand = json['Jharkhand'].cast<String>();
    karnataka = json['Karnataka'].cast<String>();
    kerala = json['Kerala'].cast<String>();
    ladakhUT = json['Ladakh (UT)'].cast<String>();
    lakshadweepUT = json['Lakshadweep (UT)'].cast<String>();
    madhyaPradesh = json['Madhya Pradesh'].cast<String>();
    maharashtra = json['Maharashtra'].cast<String>();
    manipur = json['Manipur'].cast<String>();
    meghalaya = json['Meghalaya'].cast<String>();
    mizoram = json['Mizoram'].cast<String>();
    nagaland = json['Nagaland'].cast<String>();
    odisha = json['Odisha'].cast<String>();
    puducherryUT = json['Puducherry (UT)'].cast<String>();
    punjab = json['Punjab'].cast<String>();
    rajasthan = json['Rajasthan'].cast<String>();
    sikkim = json['Sikkim'].cast<String>();
    tamilNadu = json['Tamil Nadu'].cast<String>();
    telangana = json['Telangana'].cast<String>();
    tripura = json['Tripura'].cast<String>();
    uttarPradesh = json['Uttar Pradesh'].cast<String>();
    uttarakhand = json['Uttarakhand'].cast<String>();
    westBengal = json['West Bengal'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Andaman and Nicobar Islands (UT)'] = this.andamanAndNicobarIslandsUT;
    data['Andhra Pradesh'] = this.andhraPradesh;
    data['Arunachal Pradesh'] = this.arunachalPradesh;
    data['Assam'] = this.assam;
    data['Bihar'] = this.bihar;
    data['Chandigarh (UT)'] = this.chandigarhUT;
    data['Chhattisgarh'] = this.chhattisgarh;
    data['Dadra and Nagar Haveli and Daman & Diu (UT)'] =
        this.dadraAndNagarHaveliAndDamanDiuUT;
    data['Delhi (NCT)'] = this.delhiNCT;
    data['Goa'] = this.goa;
    data['Gujarat'] = this.gujarat;
    data['Haryana'] = this.haryana;
    data['Himachal Pradesh'] = this.himachalPradesh;
    data['Jammu & Kashmir (UT)'] = this.jammuKashmirUT;
    data['Jharkhand'] = this.jharkhand;
    data['Karnataka'] = this.karnataka;
    data['Kerala'] = this.kerala;
    data['Ladakh (UT)'] = this.ladakhUT;
    data['Lakshadweep (UT)'] = this.lakshadweepUT;
    data['Madhya Pradesh'] = this.madhyaPradesh;
    data['Maharashtra'] = this.maharashtra;
    data['Manipur'] = this.manipur;
    data['Meghalaya'] = this.meghalaya;
    data['Mizoram'] = this.mizoram;
    data['Nagaland'] = this.nagaland;
    data['Odisha'] = this.odisha;
    data['Puducherry (UT)'] = this.puducherryUT;
    data['Punjab'] = this.punjab;
    data['Rajasthan'] = this.rajasthan;
    data['Sikkim'] = this.sikkim;
    data['Tamil Nadu'] = this.tamilNadu;
    data['Telangana'] = this.telangana;
    data['Tripura'] = this.tripura;
    data['Uttar Pradesh'] = this.uttarPradesh;
    data['Uttarakhand'] = this.uttarakhand;
    data['West Bengal'] = this.westBengal;
    return data;
  }
}