Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53919 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3DFRP2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2013 13:15:28 -0400
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.72)
	(envelope-from <hrm@carfax.org.uk>)
	id 1UOWi6-00049E-Td
	for linux-btrfs@vger.kernel.org; Sat, 06 Apr 2013 17:15:28 +0000
Received: from hrm by ruthven.carfax.org.uk with local (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1UOWi6-0007VE-EJ
	for linux-btrfs@vger.kernel.org; Sat, 06 Apr 2013 18:15:26 +0100
Date: Sat, 6 Apr 2013 18:15:26 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: --mixed and --nodesize together
Message-ID: <20130406171526.GH5290@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17/8oYur5Y32USnW"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--17/8oYur5Y32USnW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

--mixed seems to prevent selection of alternative leaf/node/sector sizes:

$ sudo mkfs.btrfs --mixed -n 16384 -s 16384 -d single -m single /dev/mapper/ca-store
Created a data/metadata chunk of size 8388608
fs created label (null) on /dev/mapper/ca-store
	nodesize 16384 leafsize 16384 sectorsize 16384 size 98.00MB

$ sudo mount /dev/mapper/ca-store /mnt
mount: /dev/mapper/ca-store already mounted or /mnt busy
     
Apr 6 17:59:36 s_all@ruthven kernel: [1842232.007361] device fsid 8ca4524f-4cd4-45a6-855b-dc14b56652e3 devid 1 transid 4 /dev/mapper/ca-store
Apr 6 17:59:36 s_all@ruthven kernel: [1842232.117266] btrfs: disk space caching is enabled
Apr 6 17:59:36 s_all@ruthven kernel: [1842232.117271] btrfs flagging fs with big metadata feature
Apr 6 17:59:36 s_all@ruthven kernel: [1842232.117657] btrfs: Incompatible sector size(16384) found on dm-10
Apr 6 17:59:36 s_all@ruthven kernel: [1842232.118023] btrfs: open_ctree failed


$ sudo mkfs.btrfs --mixed -n 16384 -l 16384 -d single -m single /dev/mapper/ca-store
Created a data/metadata chunk of size 8388608
fs created label (null) on /dev/mapper/ca-store
	nodesize 16384 leafsize 16384 sectorsize 4096 size 98.00MB

$ sudo mount /dev/mapper/ca-store /mnt
mount: /dev/mapper/ca-store already mounted or /mnt busy
     
Apr  6 18:06:37 s_all@ruthven kernel: [1842652.655610] device fsid 70c12f3f-39af-41e2-afa5-8b807ae2e410 devid 1 transid 4 /dev/mapper/ca-store
Apr  6 18:06:37 s_all@ruthven kernel: [1842652.777797] btrfs: disk space caching is enabled
Apr  6 18:06:37 s_all@ruthven kernel: [1842652.777806] btrfs flagging fs with big metadata feature
Apr  6 18:06:37 s_all@ruthven kernel: [1842652.777812] btrfs: unequal leaf/node/sector sizes are not allowed for mixed block groups on dm-10

   (It's not particularly important to me in this configuration -- I
can just use 4096, but I thought it should be published).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Computer Science is not about computers,  any more than ---     
                     astronomy is about telescopes.                      

--17/8oYur5Y32USnW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUWBYLlheFHXiqx3kAQJvyRAAru91kvgQ5PdINJSx6nm7vy0S7myIrALS
Tp34bR+61htx+NAVy3T6u86a6rdnnc/E1Ud17io7Ixn1zBQ3rSG6IEq0nY8bDudF
viVBQnC9esHpIKwdLZfoimbHojwkxmbWxili1ttLp52E+uulf08Gr4fShY0x6AAv
2Tdf/g47+kFtYaG+KRLgj0/cc7DJBSuVEQSoGZb4+iVrY9jcXOD0v7HIsMItmfkd
N0nCLOQLt2Y1oq66/3j5WfJN+IDslDabWhkKNk8wvQBtp3GSnAVhvjpf24vlctU6
2VMFGT9eGsVRK6oTmNzL/1XrNpcscGNMws1ws9w1goESWA5Y703/BH54H0JVdhsm
KYzrc71Haf+C8V8okcV9oyL8pETmldVUt5xv3PncvvKG0A2t4reJ9mx8IxT8S1KK
Pp6FNI5enJExenVJxBZ0QovdMFvTEabodRBat17IfG8FYV6wTsEmW0Yvq5ZF9TV+
zs4i7UnUJQGf/60IKq3obZ8rH7V9mB2BwN887/uBMx6h2dFUxoBbeQ8GD4YFOklP
z/+jA/3MklQayJPUj1g+L3oSx0EryFeMha1hg38q8yMMZ1XbG3k7xWWebcl9fW5V
TmGxqOtJzJO9RaK8mBRDRPPqexePZz/Z2VyfCnHqAQl+Ln2vAIJpbLUCHqR0rhO5
m8mpCRi4Nz8=
=zscz
-----END PGP SIGNATURE-----

--17/8oYur5Y32USnW--
