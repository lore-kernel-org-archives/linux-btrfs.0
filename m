Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59302 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbaJYT6R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Oct 2014 15:58:17 -0400
Received: from marcec ([93.181.45.225]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0MSp1l-1XYbTu3yZJ-00RmIS for
 <linux-btrfs@vger.kernel.org>; Sat, 25 Oct 2014 21:58:16 +0200
Date: Sat, 25 Oct 2014 21:58:08 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Poll: time to switch skinny-metadata on by default?
Message-ID: <20141025215808.1ad14aa0@marcec>
In-Reply-To: <20141025142458.5d96970b@marcec>
References: <20141016113337.GC22943@twin.jikos.cz>
	<20141020163403.GW22943@twin.jikos.cz>
	<20141025142458.5d96970b@marcec>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/zg3+d.VcMcF1.1xZEt/vxmJ"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/zg3+d.VcMcF1.1xZEt/vxmJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Sat, 25 Oct 2014 14:24:58 +0200
schrieb Marc Joliet <marcec@gmx.de>:

> I can still access files on MARCEC_BACKUP just fine, and the snapshots are
> still there ("btrfs subvolume list" succeeds).

Just an update: that was true for a while, but at one point listing directo=
ries
and accessing the file system in general stopped working (all processes that
touched the FS hung/zombified). This necessitated a hard reboot, since "reb=
oot"
and "halt" (so... "shutdown", really) didn't do anything other than spit ou=
t the
usual "the system is rebooting" message.

Interestingly enough, the file system was (apparently) fine after that (jus=
t as
Petr Janecek wrote), other than an invalid space cache file:

  [   65.477006] BTRFS info (device sdg2): The free space cache file
  (2466854731776) is invalid. skip it

That is, running my backup routine worked just as before, and I can access
files on the FS just fine.

Oh, and apparently the rebalance continued successfully?!

  [  342.540865] BTRFS info (device sdg2): continuing balance
  [  342.599991] BTRFS info (device sdg2): relocating block group 250235532=
0832
  flags 34 [  342.821608] BTRFS info (device sdg2): found 4 extents
  [  343.056915] BTRFS info (device sdg2): relocating block group 250181844=
9920
  flags 36 [  437.932405] BTRFS info (device sdg2): found 25086 extents
  [  438.727197] BTRFS info (device sdg2): relocating block group 250128157=
9008
  flags 36 [  557.319354] BTRFS info (device sdg2): found 83875 extents

  # btrfs balance status /media/MARCEC_BACKUP
  No balance found on '/media/MARCEC_BACKUP'

No SEGFAULT anywhere. All I can say right now is "huh". Although I'll try
starting a "balance -m" again tomorrow, because the continued balance only
took about 3-4 minutes (maybe it .

HTH
--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/zg3+d.VcMcF1.1xZEt/vxmJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUTADWAAoJEL/Q5oYsiHj0mu0P/30hFtnWtEcS6/RPNXKwutqT
SRipYL7E2Wsf3s+v2h8yoNHvA2hs4oNHXIGPyaRoo8+7iHJg4Cc8xJjOyFlldv4V
ck772/KcL9K7eoYIyVw6gFCO/R4wQKALkTkz9sEnD7Yiv8nPKszOxiNlzVz1Jzw4
UsowPjHrK20DZuf20or0zt6h+2zs6Cce6DEHTE0FZEuFY+oEMI0DDViyGmh2dBLX
3+OR0/gPTm4C7/3pKH4d+zqR0ZogtkuISbFLm2MDhiivHA7tcS4fS69bwnDvz7VZ
mxatA4FBdv+G/FKmX4ZYtSCNt/s2VxVY5kFAmVVuKMBuOoNjxiYZCMnans8+0SvG
+BPzwnKDRQg7JZ+Soc2Y5Eb3AhwAvFIg3csMkJrdYvp9TShdjzBrqqO9XlI0IAvE
uCjTE6pcTqqBkXb50ewkNCgxZyaFjNQlomx79oVCk2+rTGBtg813+pm8vFwfJh1g
/En4U/uI83AT+NUjt9UUtY48FiSlKv8DsbMCWISl1yTlzNv7Bry9+y++iZGTk090
CADgi0cIxH15AvN6LC1nvdIqcRPDPAlEq7Te6A8t3qjxh/INJgHjGkdP0JnuBQCX
6jDKuoDeCsMW0qdGOLx4UsrspjmPFXtQlGfrStiCahH+qZ24ad9FvgLU0R5KomfW
aZjZnkmRGN5EzH+YxSvL
=n0Mq
-----END PGP SIGNATURE-----

--Sig_/zg3+d.VcMcF1.1xZEt/vxmJ--
