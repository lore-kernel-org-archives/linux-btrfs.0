Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62936 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbaJQIRO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 04:17:14 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Tomasz Torcz <tomek@pipebreaker.pl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unexplainable corruptions 3.17.0
Date: Fri, 17 Oct 2014 10:17:09 +0200
Message-ID: <8226778.mdOOyP5cRZ@fb07-iapwap2>
In-Reply-To: <20141016091726.GA582640@mother.pipebreaker.pl>
References: <20141016091726.GA582640@mother.pipebreaker.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6644868.vzjUcFmZ0M"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart6644868.vzjUcFmZ0M
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Donnerstag, 16. Oktober 2014, 11:17:26 schrieb Tomasz Torcz:
> Hi,
> 
>   Recently I've observed some corruptions to systemd's journal
> files which are somewhat puzzling. This is especially worrying
> as this is btrfs raid1 setup and I expected auto-healing.
> 
>   System details: 3.17.0-301.fc21.x86_64
> btrfs: raid1 over 2x dm-crypted 6TB HDDs.
> mount opts: rw,relatime,seclabel,compress=lzo,space_cache
> 
>   Broken files are in /var/log/journal directory. This directory
> is set NOCOW with chattr, all the files within too.
> 
> Example of broken file:
> system@0005057fe87730cf-6d3d85ed59bd70ae.journal~
> 
> When read with dd_rescue, there are many I/O errors
> 
> reported, the summary looks like that (x = error):
> >-..-..xxxxxxxxx---x.-..-..-...-..-..-...-< 100%

sounds like
   https://patchwork.kernel.org/patch/4929981/
to me. We urgently need some stable patches or people will quickly corrupt 
their filesystems.

Marc

--nextPart6644868.vzjUcFmZ0M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABAgAGBQJUQNCFAAoJEKyeR39HFBtoyNEH/36MKin5OrbZ+63dxM4kbCPu
SQOZARUdWPciNwkqaOCqLDk/ReaDkx4dvRTblDn4/zi/NespFe5NNTCkm12c2hEM
xEPgWo2ndyk1RTwg86eLRKz/QdX5xd3Ok9i+a6TxYKkrXG2GFUxEgfKYW8OF0480
uIWncKekDj1G0ApDtGCz6q4dmiU1BEzqhkiAbIMIJAdTt81MQJE63WQah/Mw0BXT
79ujZAMiArS0/jbXyQr4S5hc5cU3KH5vfyKpFxrZJdudHQSY19lD+TAk0V21qxO4
wapj9rWEU8I7LKZuYzfhblcHmu3R0+I8Uo7GJGBv6YixY2sDRUIUxuhTzrAHBFU=
=q9im
-----END PGP SIGNATURE-----

--nextPart6644868.vzjUcFmZ0M--

