Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57927 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932081AbeBPJiB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Feb 2018 04:38:01 -0500
Date: Fri, 16 Feb 2018 09:38:00 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Sampson Fung <sampsonfung@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send/receive in reverse possible?
Message-ID: <20180216093800.GQ3807@carfax.org.uk>
References: <CACEy+ERPPDqAzZEUtuSTS=QROnfHV-_C5Z4y-EZ303PObX94Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wrbiW19WTymQQzps"
In-Reply-To: <CACEy+ERPPDqAzZEUtuSTS=QROnfHV-_C5Z4y-EZ303PObX94Qg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wrbiW19WTymQQzps
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 16, 2018 at 10:43:54AM +0800, Sampson Fung wrote:
> I have snapshot A on Drive_A.
> I send snapshot A to an empty Drive_B.  Then keep Drive_A as backup.
> I use Drive_B as active.
> I create new snapshot B on Drive_B.
> 
> Can I use btrfs send/receive to send incremental differences back to Drive_A?
> What is the correct way of doing this?

   You can't do it with the existing tools -- it needs a change to the
send stream format. Here's a write-up of what's going on behind the
scenes, and what needs to change:

https://www.spinics.net/lists/linux-btrfs/msg44089.html

   Hugo.

-- 
Hugo Mills             | I can't foretell the future, I just work there.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                            The Doctor

--wrbiW19WTymQQzps
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJahqZ3AAoJEFheFHXiqx3kufAP/jMAkPQ5lE6QSEbTYg6rwIlT
7YT59ErDE2gNgr/0ONKOeTZIUCRGQvjqTiLSca0wGVawuC5FEfhtfQVUvrGT0NqN
EkSTA2BihcbeVeUo6RkBvO1/HEmzsxRflbGVJbM5NJpYfIArGnhcN09DNc4HaNhA
axQXvpZDxqWMLne+LbXqw6o7j0IIPVBm6aU44aDcrOViHFV7l3EOw65WgJGADc33
OT42J1yn4jQNIQ1BJZ/KDOM5YzMOgzDi1gHYnlm6WwIm86euvg0pN9c3ofWV3ZsI
w3ZgTW3zD/QAjpD2w7hKc2gPY5N7yDTpNn1Cy7SmBm5AKIo/vXvtzlxxhHMw68dG
qzisPX7DwNVppFGRPmdDpd8UH1KP/rxvYpZX7S83v1E0j9mO5EWup2UA8wZMtvRS
HS9RS/Y7Bjt+5m2oXaT/Lsy/ctKRJC7R0fiw0LDBWMW9fmZEo77pB101lM8l+snA
g/y/qgb+bZgtl8RfPyP6X5VYw0yOJsJZPIr52+EKXTKbecCYffzuNH7ex9UkT0zt
8eharohHxEBwPAfg5ah8UZnijFCbJL8C7Jtic9OJ0y3dikxCa140ATV4rIfK31fe
ATxwnlAm2UgQ0cGBqsjo+4pm2t/vtEnYEgz2pHThV/I0Ncmfuq3tys3tGydV2DPr
ldSgy3IiX5lx0XsjaQ9n
=YT3R
-----END PGP SIGNATURE-----

--wrbiW19WTymQQzps--
