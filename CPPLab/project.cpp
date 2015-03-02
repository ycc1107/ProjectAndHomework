/*

    polymorphic classes/structs, vectors to hold them
	before inheritance

*/

#include <iostream>
#include <string>
#include <vector>
#include <random>
#include <time.h>
using namespace std;

const int THREE = 3;
const string TYPE = "type";
const string MAIL = "mail";

struct FullNameStruct{

	string firstName;
	string lastName;
	string otherName;
};

struct Date {
    Date( unsigned mm, unsigned dd, unsigned yy)
      : mm(mm), dd(dd), yy(yy)
    {}
    unsigned mm,dd,yy;
};
ostream& operator<<( ostream& os, const Date& d )
{ return os << d.mm << "/" << d.dd << "/" << d.yy; }

class Employee {
	friend
	ostream& operator<<( ostream&, const FullNameStruct& );

public:
	Employee(FullNameStruct fullName,string gender,unsigned mm, unsigned dd, unsigned yy): fullName(fullName),gender(gender),startDate(mm,dd,yy){ getGenderTitle(); }

	virtual double getPayOwn() = 0 {}

	virtual void showTheStats();
	virtual FullNameStruct getName(){ return fullName; }
	virtual string getTitle()  { return title;}
	virtual Date getStartDate()  {return startDate; }
	virtual void getGenderTitle();
	
	
private:
	FullNameStruct fullName;
	Date startDate;
	string title;
	string gender;
	string genderTitle;

};

void Employee :: showTheStats()
{
	double payAmount = getPayOwn();
	cout << genderTitle << " "
		<< getName() << " "
		<< "$"
		<< payAmount
		<< endl;
}

void Employee :: getGenderTitle() 
{
		string result;

		if(gender.compare("male") == 0)
		{
			result = "Mr.";
		}
		else if(gender.compare("female") == 0)
		{
			result ="Ms.";
		}
		
		genderTitle = result;
}

ostream & operator << (ostream & os, const FullNameStruct & fullName)
{
	os << fullName.firstName << " "
		<< fullName.lastName << " "
		<< fullName.otherName ;
	return os;
}


class SalaryEmployee : public Employee {
public:
	SalaryEmployee(FullNameStruct fullName,string gender,double salary,unsigned mm, unsigned dd, unsigned yy):Employee(fullName,gender,mm,dd,yy), salary(salary){};

	//virtual void setSecretary (Secretary&) = 0 {}; 

	void changeSalary (const double& );

	double getPayOwn() { return salary; };
	

private:
	double salary;
	
};


void SalaryEmployee::changeSalary(const double& newSalary)
{
	if(newSalary < 0 )
	{
		cerr << " salary can't not be set below zero!"; 
	}
	else
	{
		salary = newSalary;
	}
};

class Manager : public SalaryEmployee{
public:
	Manager(FullNameStruct fullName,string gender,double salary,unsigned mm, unsigned dd, unsigned yy):SalaryEmployee(fullName,gender,salary,mm,dd,yy){};

private:


};

class VIPManager : Manager{
public:

	string getRestRoomKey(){ return key;}

private:
	string key;
};

class HourlyEmployee : public Employee{
public:
	HourlyEmployee(FullNameStruct fullName,string gender,double hours,double hourlyPay,unsigned mm, unsigned dd, unsigned yy)
		:Employee(fullName,gender,mm,dd,yy), hours(hours),hourlyPay(hourlyPay),bonus(0) {};

	//virtual void setManager () const = 0{} ; 

	virtual void changeHourlyPay (const double& );
	virtual void changeWorkHours(const double& );
	virtual void setBonuseHours(const double&);
	virtual double getHours() { return hours; }
	virtual double getHoursPay() {return hourlyPay;}
	virtual double getBonuse() {return bonus;}
	

	double getPayOwn();

private:
	double hours;
	double hourlyPay;
	double bonus;
};
double HourlyEmployee ::  getPayOwn()
{
	double result = (hours + bonus)*hourlyPay;
	hours = 0;
	return result;
}

void HourlyEmployee :: setBonuseHours(const double& newBonus)
{
	bonus = newBonus;
}

void HourlyEmployee :: changeHourlyPay(const double& newPay)
{
	if(newPay < 0 )
	{
		cerr << " pay can't not be set below zero!"; 
	}
	else
	{
		hourlyPay = newPay;
	}
}

void HourlyEmployee :: changeWorkHours(const double& newHours)
{
	if(newHours > 10000)
	{
		cerr << "hours seem  not right!";
	}
	else
	{
		hours = newHours;
	}
}

class SpecialHourlyWork  : public HourlyEmployee{
public:
	SpecialHourlyWork(FullNameStruct fullName,string gender,double hours,double hourlyPay,unsigned mm, unsigned dd, unsigned yy)
		: HourlyEmployee(fullName,gender,hours,hourlyPay,mm,dd,yy) {};

	void typeSomething(){ cout << "I am typing word."; }
	void mailSomething(){ cout << "I am mailing letter."; }
	double getPayOwn();

private:


};

double SpecialHourlyWork :: getPayOwn()
{
	if( getHours() >= 250)
	{
		setBonuseHours(10);
	}

	double  hours = getHours();
	double  bonus =  getBonuse();
	double pay = getHoursPay();
	return ( hours + bonus ) * pay;
	
}



void payEveryone( vector<Employee*> &);

int main()
{
	srand (time(NULL));
	int a;
	vector<FullNameStruct> fullNameV;
	vector<Employee*> employees;
	vector<string> genderRnd;
	FullNameStruct fullName;
	vector<string> name;
	
	genderRnd.push_back("male");
	genderRnd.push_back("female");

	name.push_back("Sally");
	name.push_back("Jones");
	name.push_back("Mea Culpa");
	name.push_back("Cheng");
	name.push_back("Yan");
	name.push_back("Rynn");
	name.push_back("Tim");
	name.push_back("Tracy");

	for(int i = 0; i < 10 ; i++)
	{
		fullName.firstName = name[rand()%8];
		fullName.lastName = name[rand()%8];
		fullName.otherName = name[rand()%8];
		fullNameV.push_back(fullName);
	}
	

	for(int i = 0; i < 10 ; i++)
	{
		double hourlyPay =rand()%100 + 1;
		double hour = rand()%40 + 1;
		string gender = genderRnd[rand()%2];
		unsigned int month = rand()%12 + 1;
		unsigned int year = rand()%2014 + 1980;
		unsigned int day = rand()%31 +1;
		HourlyEmployee* temp = new HourlyEmployee(fullNameV[i],gender, hour ,hourlyPay ,month,day,year);

		employees.push_back(temp);
	}
	for (int i = 0 ; i < 10 ; i++)
	{
		double salary = rand()%200000 + 50000;
		string gender = genderRnd[rand()%2];
		unsigned int month = rand()%12 + 1;
		unsigned int year = rand()%2014 + 1980;
		unsigned int day = rand()%31 +1;

		Manager* temp = new Manager(fullNameV[i],gender,salary,month,day,year);

		employees.push_back(temp);
	}
	SpecialHourlyWork* temp = new SpecialHourlyWork(fullNameV[5],genderRnd[1],300,30,12,1,2013);
	
	employees.push_back(temp);

	payEveryone(employees);


	cin >> a;
} // main

void payEveryone( vector<Employee*> & employees)
{
	for (unsigned int i = 0 ; i < employees.size() ; i++)
	{
		employees[i] ->showTheStats();
	}
}


