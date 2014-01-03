Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36354 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbaACXSY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jan 2014 18:18:24 -0500
Date: Fri, 3 Jan 2014 23:18:21 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jim Salter <jim@jrs-s.net>
Cc: Joshua =?iso-8859-1?Q?Sch=FCler?= <joshua.schueler@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
Message-ID: <20140103231821.GJ8913@carfax.org.uk>
References: <52C73987.7000106@jrs-s.net>
 <52C73D1A.8060805@gmail.com>
 <52C7402A.7050605@jrs-s.net>
 <52C741F5.7030106@gmail.com>
 <52C74415.3020407@jrs-s.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/0U0QBNx7JIUZLHm"
In-Reply-To: <52C74415.3020407@jrs-s.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/0U0QBNx7JIUZLHm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 03, 2014 at 06:13:25PM -0500, Jim Salter wrote:
> Sorry - where do I put this in GRUB? /boot/grub/grub.cfg is still
> kinda black magic to me, and I don't think I'm supposed to be
> editing it directly at all anymore anyway, if I remember
> correctly...

   You don't need to edit grub.cfg -- when you boot, grub has an edit
option, so you can do it at boot time without having to use a rescue
disk.

   Regardless, the thing you need to edit is the line starting
"linux", and will look something like this:

linux /vmlinuz-3.11.0-rc2-dirty root=UUID=1b6ec419-211a-445e-b762-ae7da27b6e8a ro single rootflags=subvol=fs-root

   If there's a rootflags= option already (as above), add ",degraded"
to the end. If there isn't, add "rootflags=degraded".

   Hugo.

> >>HOWEVER - this won't allow a root filesystem to mount. How do you deal
> >>with this if you'd set up a btrfs-raid1 or btrfs-raid10 as your root
> >>filesystem? Few things are scarier than seeing the "cannot find init"
> >>message in GRUB and being faced with a BusyBox prompt... which is
> >>actually how I initially got my scare; I was trying to do a walkthrough
> >>for setting up a raid1 / for an article in a major online magazine and
> >>it wouldn't boot at all after removing a device; I backed off and tested
> >>with a non root filesystem before hitting the list.
> >Add -o degraded to the boot-options in GRUB.
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Eighth Army Push Bottles Up Germans -- WWII newspaper ---      
                     headline (possibly apocryphal)                      

--/0U0QBNx7JIUZLHm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUsdFPVheFHXiqx3kAQLCmQ//bY8AfErZfQsB6DP68jJmj3iQrx5PYjiQ
y24VR0ry2+xcJD6Nlno7L6zYdm3Pm9m14Sd4q901z9hw/vn6u7lr6XxuXCRV2fI4
kMwOq4wVnAa1iEWyeZbN0Rut7jKoS9Nvi6d7QPySw07EmwksJlxo2SLh+Sh52/sl
LtAWIUiSaRceLaOelU8R3+3Do9Q1gafIGJKI1sQYYzinPsb6SDvEpkWdHdzqGARx
F3Le4mvhJi80gkGiWwTNluuwxntJZBT1UOaaWoq8Sjxwv45rDwEQ6gee5ZDpg4PZ
65Laq43LmLepTRPt6bCLl0BIpOCm04fWNbKDb7GmqQoK6d251xHdrftzmAi45iMo
liswf/I1BuY273M6853GqvE+khldyM4CQZAV+dSJYaRyhfdcV8+oVkcT8TJT+Mc9
0JFQQWa1QiAA7lRCFhotNAMrWJ+mvMJDKHpD0iE9i3DcOo8ogz4RJE1Yewgq/r5n
wGKuXtbRaJXF03Pqi79IO4vdVYzOMNyZdBl8uzWs7eJrZ1G6XaxNsOnPXyTZhbHH
cMsoOsXmVGhVzPV8Y0yiwq3ynkKwr1NikcBT7w3TFT5+ZlNJUhN1lbiZmjG50qBR
rti2WpOMqjCCjN5SL4FmPNripzUTue9vv8dNxXA8DkPZTmZnzRr3tunnsxZvIfCm
GwRuVtUW7mQ=
=W7pH
-----END PGP SIGNATURE-----

--/0U0QBNx7JIUZLHm--
