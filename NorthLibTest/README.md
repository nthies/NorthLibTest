# NorthLibTest

This is a collection of view controllers to test various aspects of
[NorthLib](https://github.com/die-tageszeitung/NorthLib) on iOS.

All view controllers are presented in a table view. To add a new view controller
'YourController.swift' put it under the directory "TestVC" and add to 
NavController.swift:
````
  vcTable.add(vcd: YourController.self)
````
In addition YourController must adopt 'VCDescription', eg. use:
````
  import NorthLib
  class YourController: UIViewController, VCDescription { ... }
````

## Authors

Norbert Thies, norbert@taz.de<br/>
Ringo Müller, ringo.mueller@taz.de

## License

NorthLibTest is available under the AGPL. See the LICENSE file for more info.


