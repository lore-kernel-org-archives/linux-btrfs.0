Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60399 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab3FAVXm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Jun 2013 17:23:42 -0400
Date: Sat, 1 Jun 2013 22:23:37 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RADI6 questions
Message-ID: <20130601212337.GF20133@carfax.org.uk>
References: <CAN05THTWG_jYHti7aUcz_WH97OvoVfCoz7Wuc8Hh2katqm2JmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xkXJwpr35CY/Lc3I"
In-Reply-To: <CAN05THTWG_jYHti7aUcz_WH97OvoVfCoz7Wuc8Hh2katqm2JmQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xkXJwpr35CY/Lc3I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 01, 2013 at 02:07:53PM -0700, ronnie sahlberg wrote:
> Hi List,
> 
> I have a filesystem that is spanning about 10 devices.
> It is currently using RAID1 for both data and metadata.
> 
> In order to get higher availability and be able to handle multi device failures
> I would like to change from RAID1 to RAID6.
> 
> 
> Is it possible/stable/supported/recommended to change data from RAID1 to RAID6 ?
> (I assume "btrfs fi balance ..."  is used for this?)

   Yes.

> Metadata is currently RAID1, is it supported to put metadata as RAID6 too?
> It would be "odd" to have lesser protection for metadata than data.
> Optimally I would like a mode where metadata is mirrored onto all the
> spindles in the filesystem, not just 2 in RAID1 or n in RAID6.

   Yes, that should be supported.

> Im running a 3.8.0 kernel.

   The btrfs RAID-5 and RAID-6 implementations aren't really ready for
production use, so right now I wouldn't recommend using them for
anything other than for testing purposes with data that's replacable.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- w.w.w.  : England's batting scorecard ---              

--xkXJwpr35CY/Lc3I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUapmWVheFHXiqx3kAQJTGw/+KnFRou2GbraGKpnuba/HaNPtBHHrKfqD
hS5au88Ptr+SubXkskp63vZYo168e80cZ6tx9+J4J2rYgjp6T+gXxYzk+YU8Pgcy
RsuQA0LG3RK4nhANmMxWJ8T1vNLq1YEKC6+McjxlKfT/cIyiLtI7Wp4WUZsjYo+H
zK8fw/C8d78kmpadKGXXzdy/xgHvRiyeRPdFvTI6QxX+E6usEDz+yFgno/OBmVnT
ZWUdAFJEELdobNwIQTiaVQ+iKKYD8z2fq+dyWXgqFy/cJkM/MFnFCPKd726ld56L
gOB0tvX39K8j3NDQWxJk6M6Kkrc9KqNBqGWGjTs7nKkcmXPxwfvQAWy+WLnAPx8K
SPaxnfLwQXFMj5vKWGkrdnGccrCFINGWHlqLOnS2+HoEHeq1fzVj/nAAh6s8BCk3
rgLLAFYEcIaQ+rD6r5PXbZRBuicFhqW0oknZ7WfQIonc1aVM0ZOufVtGSOfIVEnT
IPo32zf3Ib3RIeyzTQQNKQcqQB6rW5zSbx8PqvzbsrPYDb4LpJY6SaA8Tuo+H4L2
2FLtayegyPUR9i10jCzsuqy/2ZjTQEwiHeKg91VagQv+0MynKGkEQLyYRtpRduWr
dFSTieBK9YSyAFkYORjtQ3WYA/fTawdSzs+dk5ZCErahrhmht9t1gVLtppd9eTs+
OSVWUF3SrpA=
=JjDX
-----END PGP SIGNATURE-----

--xkXJwpr35CY/Lc3I--
