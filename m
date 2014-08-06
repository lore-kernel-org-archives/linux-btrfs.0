Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54171 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbaHFP5B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Aug 2014 11:57:01 -0400
Received: from asusntb.lan ([46.149.121.138]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0LzbXq-1WJOno3ooc-014nal for
 <linux-btrfs@vger.kernel.org>; Wed, 06 Aug 2014 17:56:59 +0200
Date: Wed, 6 Aug 2014 17:56:52 +0200
From: Jakub =?utf-8?Q?Klinkovsk=C3=BD?= <j.l.k@gmx.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs send/receive does not preserve +C (nocow) attribute
Message-ID: <20140806155652.GA569@asusntb.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I've been testing btrfs send/receive, and to my surprise, the +C (nocow)
attribute I have set on directory for virtual machines images is not preserved.
Is this expected? Having found no information about this issue, I'm asking here.

Info:
$ uname -a
Linux asusntb 3.15.8-1-ARCH #1 SMP PREEMPT Fri Aug 1 08:51:42 CEST 2014 x86_64 GNU/Linux
$ btrfs --version
Btrfs v3.14.2-dirty

Both source and target btrfs filesystems are mounted with the same mount
options:
  rw,nosuid,nodev,noatime,compress=lzo,space_cache,autodefrag,commit=60

$ lsattr ~/virtual_machines/
---------------C virtual_machines/archlinux-btrfs.raw
---------------C virtual_machines/archlinux.raw
---------------C virtual_machines/winxp.raw

$ lsattr /media/backup/virtual_machines/2014-08-06/
---------------- /media/backup/virtual_machines/2014-08-06/archlinux-btrfs.raw
---------------- /media/backup/virtual_machines/2014-08-06/archlinux.raw
---------------- /media/backup/virtual_machines/2014-08-06/winxp.raw

Regards,

--
jlk

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT4lBEAAoJEMiJvVK88FbFQIsP/3XXQoUAtHXrdwxKu0gP11SG
reKw3aVsML7gaTOK6x7amE39c6RJ9hfKT4M8bt0L1BtjK+B9KtHW/SUxG4n7GY/K
hYhU+Xau7/6IelDUyuZ/bXmfRxAVQBBehmnho6dMmeIIjAba18AlNxxiEbT3So8t
AowMmLgygodL2VKDbYdqIKPNU5n5AHVChWaPdJTQsBLmxkDHu4YYLXJH3lvn8o2k
zEEgGZDIMg+X2nBTItBM3a0qdEaaWlTAYURKGIhvfvS5g8OyVyc2oGP3ScZSfaCA
gYwXjxgQ+v9vZAfz0T6Q0EHxw6PM+y0andhTRwXHqH5snxZvPyI5heEQJiTFjFpK
8Klef3KBzhzdpQM3z1Sk4jA0yfyPNoSa7cwMI4/0yvfZm4rEXKWEqqPz90Oo711+
8UssyXiUa9N3hleabWqmBuiJKU8ZFxfy2/1MDGCzLgBenrvqu2xH/KG2UEcmhsxF
rf6hpPiH7n360//Zb18lxKgtQ30aoboDMC6ySVVKO3jI3Vbw67+XB3gimDBPzizL
Qpfy7kMHvrHijlvY0eUmqmwAep4qOw5JNlniGWCsVTK6rjXTar+lHMmlBB2HQxuL
r+WCNrR+0h/gLBgB+vOZU/b89QMZgdkAWIktUFP90pQA63mNwoVgY4bc6GSfZ1Tq
+JuyJxxOAsblKtZgcSg3
=BV4E
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
