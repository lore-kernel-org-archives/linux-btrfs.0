Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moh2-ve2.go2.pl ([193.17.41.200]:54825 "EHLO moh2-ve2.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757886AbaITUUX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Sep 2014 16:20:23 -0400
Received: from moh2-ve2.go2.pl (unknown [10.0.0.200])
	by moh2-ve2.go2.pl (Postfix) with ESMTP id A539ACB000A
	for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 22:20:19 +0200 (CEST)
Received: from unknown (unknown [10.0.0.42])
	by moh2-ve2.go2.pl (Postfix) with SMTP
	for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 22:20:18 +0200 (CEST)
Date: Sat, 20 Sep 2014 22:20:03 +0200
From: Piotr Szymaniak <szarpaj@grubelek.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: Using two mirrored drives separately
Message-ID: <20140920202003.GU1945@wloczykij>
References: <CAOwCge2f+s0BdUXYnMuX_iyXLcsq-FtftqT-yf1GSvyhhT9kdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WOTjKnJ88wpJKlWH"
In-Reply-To: <CAOwCge2f+s0BdUXYnMuX_iyXLcsq-FtftqT-yf1GSvyhhT9kdg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--WOTjKnJ88wpJKlWH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Sat, Sep 20, 2014 at 07:11:52PM +0300, Leonid Bloch wrote:
> I am wondering: if I set up btrfs on two identical drives, with data
> and metadata mirroring, will it be possible to use these drives
> separately later on? Will just one of these drives work as a regular
> btrfs-formatted single drive if connected to a different machine?

If by this you mean btrfs raid1, then yes, they will work this way. Just
both of them will have "missing" device and, afaik, wont mount without
-o degraded. But then you can rebalance to notraid1 or add another disk
and replace missing devices on new machines.


Piotr Szymaniak.

--WOTjKnJ88wpJKlWH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUHeFzAAoJEEMpAov1cw9ldfEP/jDxwztMuOd8c6WjN1JqP35c
3eQVPf5VIXXDrRLkKkdcS46n+EsL03/2oa+oCzeZBXb0Kmc6pldxcZwj3cuDYwor
Ie+UNu/aeHHjIw9K9elyDLsZJQMoJ7fvqfjVFrk3nd2C3PJuLdvjOIEZd9i/OIdA
uCY/Q48Kc++Wc1otcdWRfE4ovqOQIwXCaF/oYx0PX44jRhjPdP+8Hp8hmTN44KNj
sVnN/S+EQlNoPPG3uzbwOF368PV9I+6vqslT3eDPYkdHdI7OygyKi9I1sElzxyiA
wKBZxXG4uqRFAHCQaqeqdDZtLUfdkWw1LTnjEaF2FFlHSwmKLt3374iGWzkoYc+D
gx47dFqEsK2hR8ILbNQDFUZ2aLMAzPxoHQfa/mPViYi6eoIC24XYrZohtDFfX+PZ
hcHlWLeKpVcdIwGwrnML+Z3qlsQPZsLMUhzb0mJ1FwyNfP80xWVGv5hti2NseMNc
8XGz2nU5A+j3mC750X2V1HHkCYSJg+SyioQtBh7HSRbWVGv8Kdhme7RJspWt5l9W
l4ggXRlCYY/3utspYCNsh2WPXTkU0brnb4X+4DacbOL29K9A0JNePlHrnM01uJK/
cz1vaET3PClesSu9NQGY8syTTecdCZN9kHZkQ69fypFzNd/Glk9HFZB6bgUX+uz3
pqJnvJiF0ZSl4KSMf3Io
=sVMQ
-----END PGP SIGNATURE-----

--WOTjKnJ88wpJKlWH--
