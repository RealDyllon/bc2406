import React from 'react'
import { Container } from 'react-bootstrap'
import {CONSULTING_COMPANY_NAME} from "@lib/constants";

export default function Footer() {
  return (
    <footer className="footer border-top px-sm-2 py-2">
      <Container fluid className="align-items-center flex-column flex-md-row d-flex justify-content-between">
        <div>
          © 2023
          {CONSULTING_COMPANY_NAME}.
        </div>
        <div className="ms-md-auto">
          {/*Powered by&nbsp;*/}
          {/*<a*/}
          {/*  className="text-decoration-none"*/}
          {/*  href="@layout/AdminLayout/AdminLayout"*/}
          {/*>*/}
          {/*  CoreUI UI*/}
          {/*  Components*/}
          {/*</a>*/}
        </div>
      </Container>
    </footer>
  )
}
