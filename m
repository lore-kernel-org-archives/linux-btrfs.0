Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54563 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbbJBUsD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 16:48:03 -0400
Date: Fri, 2 Oct 2015 20:48:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs: user space tool to force compression
Message-ID: <20151002204802.GO25907@carfax.org.uk>
References: <mumq4s$g1c$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="keoAwTxaagou87Dg"
In-Reply-To: <mumq4s$g1c$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--keoAwTxaagou87Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 02, 2015 at 11:41:00PM +0300, Matwey V. Kornilov wrote:
> Hello,
> 
> Is there a way (and appropriate user space tool) to force compression of
> existing file? I mean there was directory with some content and then I
> set compression attribute (property) to it. How to force data recompression?

   btrfs fi defrag -c <file>

   Hugo.

-- 
Hugo Mills             | A cross? Oy vey, have you picked the wrong vampire!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--keoAwTxaagou87Dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWDu2CAAoJEFheFHXiqx3kRzAP/RG7V97e4tpJpLAQ6oW2o23S
txHXeWnUO/zbnEb6jE1IACKdcnjfWU5h7xIBBHeYvhAjIDn7vZzgZ/OwrNXL7MPZ
wzZurRMSOe7CPHbRi9zNoBPkuCCJ1Z1/obvFft4cHuockkLgGvL67OPT2gU/uCZp
Pxc/+huGFwj8sKxG5Ux3E47z+2/grgV9WYhYX8fKdZMDManFH71jhfZRHY5TaLkQ
kjxgWT1z1goq9pZyo4vssDy79v6qG+aMBeBeGsvsJ1+NW8DwzAaPG70xA4tOTP3x
D5K14fC0PO31dbDyGddEX6srlt3sJCX2GxPaoqKNppp33E4249r2HGUdgn6+/OWb
9+gEADAfIgIlAQJ8nOggjXCav7ZNwV47ChcIopZs525IFS0sHTEr7anXExyGYlkf
a5a2rbpxE8bQFvIWJBJNO1GnmcwqTKjCp5k8ijLu+cnvHNtCZ+jAMpjtWuL1shYR
NFDnUGP2GgDxHsaOMK+LlJzcEjYexIj72rKkifMxOjJ0p784/Nd8xXrQMrfEzYDY
ORe28bJqI4z1skLv5Tu0M8BimHloNCKN8yTmhA6Xa4pwKuq6YJtoInfMkU59ZVUt
IzCpTjEsu8wb0w78K9OGZpyBgAyJvX70NI01C8z7e9XzjBPbXYrSLFtB1+DXAu1p
VB6c1CZG9UjkFbUQQPE1
=HWqL
-----END PGP SIGNATURE-----

--keoAwTxaagou87Dg--
