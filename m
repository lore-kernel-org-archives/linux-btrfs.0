Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59228 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab3GZHry (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jul 2013 03:47:54 -0400
Date: Fri, 26 Jul 2013 08:47:52 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Pete <pete@petezilla.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Error on rebooting
Message-ID: <20130726074752.GK20517@carfax.org.uk>
References: <51F1C09C.9020602@petezilla.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BFVE2HhgxTpCzM8t"
In-Reply-To: <51F1C09C.9020602@petezilla.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--BFVE2HhgxTpCzM8t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2013 at 01:19:40AM +0100, Pete wrote:
> Dear All,
> 
> Have I anything to be concerned about?
> 
> I have got some error messages on booting.  The scenario was that I
> had installed some ram and I suspect that I had disturbed a cable as
> one disk was not visible.  I could not mount the other disk (did not
> try degraded, but the messages seemed to indicate something serious
> was up).
> 
> After installing ram booted.  But some issue with some files,
> anything accessing those files froze.  Had to reboot.  Failed to
> shutdown correctly (shutdown stalled on unmount)
> 
> Reboot.
> 
> /home etc not mounted (btrfs in question)
> 
> Btrfsck /dev/sdb showed various errors.
> 
> When complete turned off machine.  Fiddled with cables.  Affected
> drive now seen on reboot.
> 
> Rebooted.  Mounted disks (perhaps) error messages may have been
> present on boot.  Much disk IO.  Disk IO stopped.  Machine appeared
> frozen except that Caps lock and Num lock worked.
> Ctrl-alt-backspace did not sort out stalled x(?)dm session.  Hard
> power down.
> 
> Last reboot.  Error messages.  However, works.  Example messages from dmesg:
> 
> [    8.063138] btrfs: enabling inode map caching
> [    8.067617] btrfs: use lzo compression
> [    8.072092] btrfs: disk space caching is enabled
> [    8.147324] btrfs: bdev /dev/sdb errs: wr 4015, rd 464, flush 0,
> corrupt 0, gen 0
> [    8.802275] NET: Registered protocol family 10
> [   15.462313] device fsid 2628a800-e095-4460-9b93-8847e9fb626b
> devid 2 transid 27794 /dev/sdc
> [   15.511463] device fsid 2628a800-e095-4460-9b93-8847e9fb626b
> devid 2 transid 27794 /dev/sdc
> [   15.566689] device fsid 2628a800-e095-4460-9b93-8847e9fb626b
> devid 2 transid 27794 /dev/sdc
> [   15.587851] device fsid 2628a800-e095-4460-9b93-8847e9fb626b
> devid 2 transid 27794 /dev/sdc
> [   15.620678] device fsid 2628a800-e095-4460-9b93-8847e9fb626b
> devid 2 transid 27794 /dev/sdc
> [   16.024295] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> ...
> 
> ...
> 
> ...
> 
> ...
>    19.491507] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [   56.064899] parent transid verify failed on 1142639534080 wanted
> 27788 found 26856
> [   56.154721] btrfs read error corrected: ino 1 off 1142639534080
> (dev /dev/sdb sector 2179305424)
> [   56.166301] parent transid verify failed on 1142597795840 wanted
> 27777 found 27772
> [   56.186790] btrfs read error corrected: ino 1 off 1142597795840
> (dev /dev/sdb sector 2179223904)
> [   56.460857] parent transid verify failed on 1142599532544 wanted
> 27779 found 27772
> [   56.461396] btrfs read error corrected: ino 1 off 1142599532544
> (dev /dev/sdb sector 2179227296)
> [   59.927078] ata1.00: configured for UDMA/133
> [   59.927082] ata1: EH complete
> [   59.933467] ata2.00: configured for UDMA/133
> [   59.933473] ata2: EH complete
> [   60.129445] ata3.00: configured for UDMA/133
> [   60.129458] ata3: EH complete
> [   61.449810] parent transid verify failed on 1142629605376 wanted
> 27784 found 26856
> [   61.473817] btrfs read error corrected: ino 1 off 1142629605376
> (dev /dev/sdb sector 2179286032)
[snip]
> [  104.204035] btrfs read error corrected: ino 1544486 off 0 (dev
> /dev/sdb sector 2182960392)
> [  104.204551] btrfs read error corrected: ino 1544486 off 4096 (dev
> /dev/sdb sector 2182960400)
> [  117.249253] parent transid verify failed on 1142609051648 wanted
> 27774 found 26856
> [  117.255886] btrfs read error corrected: ino 1 off 1142609051648
> (dev /dev/sdb sector 2179245888)
> [  117.419294] parent transid verify failed on 1142599507968 wanted
> 27779 found 27772
> [  117.437317] btrfs read error corrected: ino 1 off 1142599507968
> (dev /dev/sdb sector 2179227248)
> [  137.502176] NFSD: Unable to end grace period: -110
> 
> Given that I have booted now - does this mean that the above was
> btrfs sorting itself out?

   Looks like it. I'd recommend a scrub to check for any other out of
date data on the affected drive. I've done pretty much the same thing
as this myself, and a scrub, though scary in the amount of noise it
made, fixed everything satisfactorily.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- Sometimes, when I'm alone, I Google myself. ---           

--BFVE2HhgxTpCzM8t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUfIpqFheFHXiqx3kAQL4xQ//fNLsw48d62KtJIRuEUmRQVzKMshyJFv6
IG984uI1qRAEHrp9waAZIkdBY12WnqDUwhRj/EIJimxR5NZ6g8jlKZgLdbraRYGn
6O9G15vseJUsEkWbMaTVOmiIVksJRbplLejqrdXCzKYjHwYr2E/Yw1sk5v0lz68T
qCTsNMAn/9MPAAQYdhMA7g8GONpDXq/M8I9nCTN09hzl6gyg0q+caCnn26RXgcVP
1i+jg1IvEvJLbL6XOiyy41phlv3/15qGGsmTm6T1fON/dxXXn38fPABW2g3rrz7O
vFCGgl3os5txzbvXCY1pKuVRcakiMS80x/G4vlYmXHZIsIHhntXU+vTPxVWbe5f0
CaVSpuJmzWz8hjJlBrl5/IQK4FRaQaPuPJMmNMYaxe4/pJ4lfT3GTkdiwJbcTCiB
/ZBWPsVW9cw90Rhc186juhW/gZVBDv4xEI8wXgl169pHCCYsUt11SBCsU45Is6fx
0x/VZB+lwLeAImfVW5zvDUVlD5RMhVXphNMUeqww7HlsK4VsMaL8gLBd8Mv6rqV0
BtGwkp/RuEyPJKDPdEuAMUp3yHRXq03di7hX4EH9gexWHxGOav+HRMYLLUgSLBXq
7L6Q9U14LFK4LKBTyHu1OLzec293wI4M6P4ly81CIGXVPTy2gskfXVpG+oKKATai
XM5GKQD20TA=
=oMr5
-----END PGP SIGNATURE-----

--BFVE2HhgxTpCzM8t--
