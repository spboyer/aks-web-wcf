import { Component, Inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-people',
  templateUrl: './people.component.html',
  styleUrls: ['./people.component.css']
})
export class PeopleComponent {
  public people: Person[];

  constructor(http: HttpClient) {
    const baseUrl = 'http://people/';
    http.get<Person[]>(baseUrl + 'api/SampleData/people').subscribe(result => {
      this.people = result;
    }, error => console.error(error));
  }
}

interface Person {
  firstName: string;
  lastName: string;
  age: number;
  location: string;
  id: number;
}
