Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55068 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbcHQLYo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Aug 2016 07:24:44 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1bZyxC-0001be-Gn
	for linux-btrfs@vger.kernel.org; Wed, 17 Aug 2016 11:24:14 +0000
Date: Wed, 17 Aug 2016 11:24:14 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: df is not using the right algorithm to report usable space
Message-ID: <20160817112414.GE20440@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   OK, we all know that df lies with btrfs. But even in the cases
where it _could_ tell the truth, it's still getting it wrong. I've
finally managed to pin down a concrete example:

Label: 'amelia'  uuid: 1da97c6f-5467-4591-ad79-5d283db800d4
        Total devices 6 FS bytes used 7668.78GiB
        devid    4 size 3722.02GiB used 3165.00GiB path /dev/sda2
        devid    7 size 1393.02GiB used 1147.00GiB path /dev/sdd2
        devid    9 size 1858.77GiB used 1614.03GiB path /dev/sdb2
        devid   12 size 3722.02GiB used 3164.00GiB path /dev/sdj2
        devid   13 size 3721.92GiB used 3627.03GiB path /dev/sdc2
        devid   14 size 5589.03GiB used 2655.00GiB path /dev/sdi2

Data, RAID1: total=7674.00GiB, used=7657.94GiB
System, RAID1: total=0.03GiB, used=0.00GiB
Metadata, RAID1: total=12.00GiB, used=10.84GiB
GlobalReserve, single: total=0.50GiB, used=0.00GiB

Filesystem     1G-blocks  Used Available Use% Mounted on
/dev/sda2         10004G 7670G      915G  90% /media/video

   Now, by my calculations, there's unallocated space on the disks as
follows:

devid  4  unalloc  555 GiB
devid  7  unalloc  246 GiB
devid  9  unalloc  244 GiB
devid 12  unalloc  556 GiB
devid 13  unalloc   94 GiB
devid 14  unalloc 2937 GiB

   Now, clearly the first five sum to less than the last one. With
RAID-1 on everything, this means that we'll fill devices 4-13 first,
and we can fit 1695 GiB more allocation on this FS. Added to the 16
GiB of space allocated but unused, the estimate should therefore be
1711 GiB of usable space, not the 915 GiB reported by df.

   I don't know what it's doing in there, but whatever it is, it's
definitely *not* using the right algorithm for it (the one I wrote up
in detail a few months ago).

   I think if the unallocated space on all the devices is similar, it
gets the answer nearly right. It seems to get worse as the imbalance
of unallocated space across the devices gets larger.

   Hugo.

-- 
Hugo Mills             | I know of three kinds: hot, cool, and
hugo@... carfax.org.uk | what-time-does-the-tune-start?
http://carfax.org.uk/  |
PGP: E2AB1DE4          |            Jill Swinburne, The Beiderbecke Connection

--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXtEleAAoJEFheFHXiqx3keN0P/ie2PWVbNwDcWlrTCdCh/Z3i
hWL31GX7celo7yJe8MORlNmXnHuWrS9hygPJuDaQrOjG2HjO/grYGdlkOeUjNoFN
tQktGhXKYUKt1lbn/2AjJPvJ/45vViib51XoLLPb59vX6N0JfUFebR0A7dlSwHT6
4q8u0/xwMyK8hl1kEwWmK//40b8SeMHdQXe5N21ukbY6uIpkXO74IsPDqaxF99ce
Lp58DtoDuYHKnUNnwKMxUIRxc8IySWjvrIF0Fs9xEOFjTu438AaoHrCcXAJR2ylS
snx2Du50/Tfpd5fa9yLMPC/64E863FPtV4JhK24bvlTB9eUZEEVMzVytDS1ztiHT
S0hsXCt6DBWdwEXqtep58xosjOlg7z3qnSpO2QZyO84sI0O1Pol9+ukkL7/f+7gh
5EdEhx+zA/9mI1i4Fz+I9jK/ImGOsahUUBPvTvzbRX3lX5CSQi4J2vRxCKyksF2z
hgznJL93hSUahswYi7cArw9dKPrPCcHz77s6wySgM+YsxdACXooWieL5AvnN6paQ
H8R+dNUVMLjXziWHRPbh+HwDagTQDnYsXdeNa/3tpPcBWKoaJP7t45WbMmARFSlx
hdscoymp5ZVaX73waoHC4k2QZLptZ4MJnjh5L92l1jknDK4q3zNwOWoJ/HyGwgph
fnRw5Ojo0ah4SHX/KfhG
=my4m
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--
