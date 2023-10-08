import {Card, Dropdown} from "react-bootstrap";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faArrowUp, faArrowDown, faEllipsisVertical} from "@fortawesome/free-solid-svg-icons";
import {Line} from "react-chartjs-2";
import React from "react";

interface HeroCardProps {
value: string;
delta: string;
deltaDirection: "up" | "down";
title: string;
}

export function UsersCard({value, delta, deltaDirection, title}: HeroCardProps) {
  return <Card bg="primary" text="white" className="mb-4">
    <Card.Body className="pb-0 d-flex justify-content-between align-items-start">
      <div>
        <div className="fs-4 fw-semibold">
          {value}
          <span className="fs-6 ms-2 fw-normal">
                  {delta}
            {deltaDirection === "up" ?
              <FontAwesomeIcon icon={faArrowUp} fixedWidth/>
              :
              <FontAwesomeIcon icon={faArrowDown} fixedWidth/>}

                </span>
        </div>
        <div>{title}</div>
      </div>
      <Dropdown align="end">
        <Dropdown.Toggle
          as="button"
          bsPrefix="btn"
          className="btn-link rounded-0 text-white shadow-none p-0"
          id="dropdown-chart1"
        >
          <FontAwesomeIcon fixedWidth icon={faEllipsisVertical}/>
        </Dropdown.Toggle>

        <Dropdown.Menu>
          <Dropdown.Item href="#/action-1">Action</Dropdown.Item>
          <Dropdown.Item href="#/action-2">Another action</Dropdown.Item>
          <Dropdown.Item href="#/action-3">Something else</Dropdown.Item>
        </Dropdown.Menu>
      </Dropdown>
    </Card.Body>
    <div className="mt-3 mx-3" style={{height: "70px"}}>
      <Line
        options={{
          plugins: {
            legend: {
              display: false,
            },
          },
          maintainAspectRatio: false,
          scales: {
            x: {
              grid: {
                display: false,
                drawBorder: false,
              },
              ticks: {
                display: false,
              },
            },
            y: {
              min: 30,
              max: 89,
              display: false,
              grid: {
                display: false,
              },
              ticks: {
                display: false,
              },
            },
          },
          elements: {
            line: {
              borderWidth: 1,
              tension: 0.4,
            },
            point: {
              radius: 4,
              hitRadius: 10,
              hoverRadius: 4,
            },
          },
        }}
        data={{
          labels: ["January", "February", "March", "April", "May", "June", "July"],
          datasets: [{
            label: "My First dataset",
            backgroundColor: "transparent",
            borderColor: "rgba(255,255,255,.55)",
            data: [65, 59, 84, 84, 51, 55, 40],
          }],
        }}
      />
    </div>
  </Card>;
}
