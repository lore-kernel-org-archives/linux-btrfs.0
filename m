Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49875 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759021Ab3IBWAM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Sep 2013 18:00:12 -0400
Date: Mon, 2 Sep 2013 23:00:06 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Rain Maker <rainmaker52@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Recovering from csum errors
Message-ID: <20130902220006.GA6389@carfax.org.uk>
References: <CAD+_0YrG2ju47suCSRKta+bONwUPcjTpv1y=11rkVNqVtHHwiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
In-Reply-To: <CAD+_0YrG2ju47suCSRKta+bONwUPcjTpv1y=11rkVNqVtHHwiQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 02, 2013 at 11:41:12PM +0200, Rain Maker wrote:
> Hello list,
> 
> So, I ran a full scrub, and, luckily, it only found 6 csum errors
> (these 6). The damage therefore seems to be contained in "just" 1
> file.
> 
> Now, I removed the offending file. But is there something else I
> should have done to recover the data in this file? Can it be
> recovered?

   No, and no. The data's failing a checksum, so it's basically
broken. If you had a btrfs RAID-1 configuration, the FS would be able
to recover from one broken copy using the other (good) copy.

> I'm running 3.11-rc7. It is a single disk btrfs filesystem. I have
> several subvolumes defined, one of which for VMWare Workstation (on
> which the corruption took place).

   Aaah, the VM workload could explain this. There's some (known,
won't-fix) issues with (I think) direct-IO in VM guests that can cause
bad checksums to be written under some circumstances.

   I'm not 100% certain, but I _think_ that making your VM images
nocow (create an empty file with touch; use chattr +C; extend the file
to the right size) may help prevent these problems.

> I checked the SMART values, they all seem OK. The harddisks in this
> machine are less then a month old. I replaced them after seeing
> similar messages on the "old" disks.
> 
> Is the only logical explanation for this some kind of hardware failure
> (SATA controller, power supply...), or could there be something more
> to this?

   As above, there's some direct-IO problems with data changing
in-flight that can lead to bad checksums. Fixing the issue would cause
some fairly serious slow-downs in performance for that case, which is
rather against what direct-IO is trying to do, so I think it's
unlikely the behaviour will be changed.

   Of course, I could be completely wrong about all this, and you've
got bad RAM or PSU something...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- "What are we going to do tonight?" "The same thing we do ---     
            every night, Pinky.  Try to take over the world!"            

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUiUKZVheFHXiqx3kAQIiQQ/+NRr97lBrtr4k9wIIxfOne7YzJ4Fvr7q9
cPlbqLCvAadQukHIR1kE0BTyGBIgq7PXUSCrJcgWdl6T1gq1RozN2BjQY/0Trqym
T5AqvlBaL5QnDmCcPNbGXyIR/+3bTayZqSuTR2SH854TrGP8dfYpiA1X6B7ilUSB
R198RCEUMV1K6p6N7kY5jAax91voIUejKh8kwlIBxfl1JzXq3kY6FdcZ67xkffH4
QzMEPsJ8OjR6ARgr1zaMqZM6l9W0Y+vObr1cTPvG5iagAZsicd08bQ18Ezv/P69n
v0xhFRO704BAC5Q1Y5nnhT//qZP015nbjqy9j11183TEzuREZBRPkPDRfN+CxPw2
NGH6Fz92GGaEF3fYDw1SaYaAbJKNue6Ax5J7tToBnI1NjMNfBvvWt8OyD/T5lENm
FVnyrslfPXSWmD9UcIsv2YlanQL1xZwFy43JcgI1hKOxYvgkzdTWLG042pASflEc
czS2dbsw+ZHU/pdPvqL9gyJzEdPHdImplTdx+JvqMLEaG6cCdxFmdmxOLLo5dW8j
/9+CohWmNQEyP0GC/rJ60SujiDeNVjjhspbYUQPMVTD+SRa2ekyZhT47FXObZ71l
u3uPybuXuEZPNQCao8lHGv5JR+mn3G86c75wv+4jBT9CIYrTMJzo2G4ELWC651WT
dm+w7JbBNIw=
=7LbL
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
