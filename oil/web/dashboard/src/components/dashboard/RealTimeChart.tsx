import React from 'react';
import { Line } from 'react-chartjs-2';

export type DataPoint = {
  timestamp: string;
  "P-PDG": string;
  "P-TPT": string;
  "T-TPT": string;
  "P-MON-CKP": string;
  "T-JUS-CKP": string;
  "P-JUS-CKGL": string;
  "T-JUS-CKGL": string;
  QGL: string;
  class: string;
};

interface RealTimeChartProps {
  data: DataPoint[];
}

const RealTimeChart = ({ data }: RealTimeChartProps) => {
  // Assuming data is an array of objects with { x, y } properties
  const chartData = {
    labels: data.map((point) => point.timestamp),
    datasets: [
      {
        label: 'P-PDG',
        data: data.map((point) => point["P-PDG"]),
        fill: false,
        borderColor: 'blue',
      },
    ],
  };

  const options = {
    responsive: true,
    maintainAspectRatio: false,
  };

  return <Line data={chartData} options={options} />;
};

export default RealTimeChart;
