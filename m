Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52427 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbbCWFCn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 01:02:43 -0400
Date: Sun, 22 Mar 2015 16:46:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: kernel-build-reports@lists.linaro.org, linaro-kernel@lists.linaro.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20150322164622.GK6643@sirena.org.uk>
References: <E1YYtMC-00079d-Lq@debutante>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="opg8F0UgoHELSI+9"
In-Reply-To: <E1YYtMC-00079d-Lq@debutante>
Subject: Re: next-20150320 build: 2 failures 25 warnings (next-20150320)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--opg8F0UgoHELSI+9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 20, 2015 at 09:36:44AM +0000, Build bot for Mark Brown wrote:

> 	arm-allmodconfig
> ../fs/btrfs/inode.c:8050:2: error: implicit declaration of function 'iov_iter_alignment' [-Werror=implicit-function-declaration]
> ../fs/btrfs/inode.c:8061:26: error: dereferencing pointer to incomplete type
> ../fs/btrfs/inode.c:8062:29: error: dereferencing pointer to incomplete type
> ../fs/btrfs/inode.c:8063:12: error: dereferencing pointer to incomplete type
> ../fs/btrfs/inode.c:8063:39: error: dereferencing pointer to incomplete type
> ../fs/btrfs/inode.c:8095:2: error: implicit declaration of function 'iov_iter_count' [-Werror=implicit-function-declaration]

For a few days now btrfs has been breaking the ARM allmodconfig build
due to the above errors.  It is relying on the implicit inclusion of
linux/uio.h which isn't getting pulled in on ARM (and possibly some
other architectures too) for the definition of both struct iov_iter and
iov_iter_alignment.

--opg8F0UgoHELSI+9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVDvHdAAoJECTWi3JdVIfQC/0H+QG3mp5j3iqnVN6tRb+eLqSk
utesBTGp7SfW066xQI6ps56byb6UoAnIPUd1NJejcfuKF5VOn9tJr+RamI2i16mH
LQX0/raiDs+4kRhCWAI3vdT1v85QDUFxVKnRxdTxZceJRv+Xho1np/EjLokAnO4A
5VBXn89GiHrqGorf7v6OKUKEGwsmVmcMNOR7r5iRpOQsrZqzSNyb2Kmp7ItEA2E4
6zj8mHiKW4rWs/GJlCFbpdUcKudBLLkKthuPo8TWCh0mm2K8JiVpgW8TmQegiy2o
beT0OgMbVDEvp1nPIMqOcxK1zaBnec2SHZgvT/YzshN+1JiiZBfXs91blycO3YM=
=DohE
-----END PGP SIGNATURE-----

--opg8F0UgoHELSI+9--
