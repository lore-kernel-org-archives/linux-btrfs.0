Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34012 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaG3JiY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 05:38:24 -0400
Date: Wed, 30 Jul 2014 10:38:21 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Nick Krause <xerofoify@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
Subject: Re: Work Queue for btrfs compression writes
Message-ID: <20140730093821.GJ31950@carfax.org.uk>
References: <CAPDOMVjJHbCwDVyKQ+Vuse7G76FLSLq69Ja4kmopDbjtEb_Zkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fjX3cMESU3XgGmZ"
In-Reply-To: <CAPDOMVjJHbCwDVyKQ+Vuse7G76FLSLq69Ja4kmopDbjtEb_Zkw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--2fjX3cMESU3XgGmZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 29, 2014 at 11:54:20PM -0400, Nick Krause wrote:
> Hey Guys ,
> I am new to   reading  and writing  kernel code.I got interested in
> writing code for btrfs as it seems to
> need more work then other file systems and this seems other then
> drivers, a good use of time on my part.
> I interested in helping improving the compression of btrfs by using  a
> set of threads using work queues like XFS
> or reads and keeping the page cache after reading compressed blocks as
> these seem to be a great way to improve
> on  compression performance mostly with large partitions of compressed
> data. I am not asking you to write the code
> for me but as I am new a little guidance and help would be greatly
> appreciated as this seems like too much work for just a newbie.

 * Documentation/workqueue.txt (in general, grep in Documentation
   usually throws up something useful)

 * grep -r alloc_workqueue fs/ shows a lot of uses (including in
   btrfs), so it should be fairly easy to see how to create and manage
   a workqueue.

   I suspect that this may be a medium-sized project, rather than a
small one. My gut feeling (based on limited experience) is that the
fallocate extensions project would be considerably simpler.

   I also noticed from the public reply to the private mail (don't do
this without getting permission from the other person) that you posted
to LKML in this thread (don't switch mailing lists mid-thread) that
you anticipated having problems testing with limited disks -- what you
will find is that testing new kernel code is something that you don't
do on your main development OS installation. Instead, you will need
either a scratch machine that you can easily update, or one or more
virtual machines. qemu/kvm is good for this, because it has a mode
that bypasses the BIOS and bootloader emulation, and just directly
runs a kernel from a file on the host machine. This is fast. You can
pass large sparse files to the VM to act as scratch disks, plus keep
another smaller file for the guest OS (and a copy of it so that you
can throw one away and make another one quickly and easily).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- You've read the project plan.  Forget that. We're going to Do ---  
                      Stuff and Have Fun doing it.                       

--2fjX3cMESU3XgGmZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU9i9DVheFHXiqx3kAQIACA//fhbSusPVM5BjtIlvm/BJhcNHi5oEH2h5
gD0xv5fWA3UxM3eAcjqTDGtRrdKDspg/wfCwU0HTxpnWwKAn/QGqmw9oMHHB6m2v
XR9S/r8MBKG3h6+9vISR9GqZ7YPyohZNxClFsbW+xqltPyu3smgJ8VR+t/08Kepr
Y4/+aMkjcQuWEZRYXWSohiL8MllERSogyZG+GAO/iidqKHuYTNM0AScIe9nLsmmt
KiKR6uH806JZiA8mV+6pyrc/e/dGDDcYmJ88Gto8dZxfCod2jMI4vQCT/naoD5AA
l+/YVgcR+WE2SZLkUHUZNLnBrMRsbMHNSlYfvZG5vPZyp5k/sl+DpPKM/yzMO/77
M84zpgQ5M5/DkyU28mR+HqJ8JU9tjmTCaB1w+Bh/DY/Kvlm2iYZ+ox93ZqLNU8IJ
zw89uADUaU0J8FtokhuQwh30gTUsrGwzi5WsmfJTbxRU4QHLc6ya1jhfHIvSVli8
goq7W7d7jybLdeqIY+aNjGCndkNqwN9xxzkF0UkPDuWR3CIHEMZxLFYKFhu168Uc
wmzZxgMVW4JfT4JZj4gqPu9p8h/VZTe9QUgdVOr8sJPP8HIuppQE9O7piYAUzWlX
/NftCmL5rgSeX7nbHjBkbpLsHa/8UOHALKPMz2tusUKTs/EkY90KSUcR2cTvRVID
HQ6UuixxmL8=
=2A8V
-----END PGP SIGNATURE-----

--2fjX3cMESU3XgGmZ--
