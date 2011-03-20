From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: [PATCH v2 0/2] Balance management, kernel side
Date: Sun, 20 Mar 2011 09:52:26 +0100
Message-ID: <4D85C04A.2010907@gmail.com>
References: <cover.1289522188.git.hugo@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org,
	Goffredo Baroncelli <kreijack@libero.it>,
	Chris Mason <chris.mason@oracle.com>,
	liubo <liubo2009@cn.fujitsu.com>
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1289522188.git.hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Since balancing takes a long time I liked the idea of having some
progress counter and the ability to run this long lasting task in
background with another option to cancel it if necessary. So I wanted
to give it a try. Unfortunately, all the patches did not apply on top
of kernel version 2.6.38. Is there a newer version of this patch or
died this idea in the meantime? Of course, I will test any patches.

Thanks,
Andreas Philipp


On 12.11.2010 01:36, Hugo Mills wrote:
> These two patches give a degree of control over balance
> operations. The first makes it possible to get an idea of how much
> work remains to do, by tracking the number of block groups (chunks)
> that need to be moved/rewritten. The second patch allows a running
> balance operation to be cancelled when the current block group has
> been moved.
>
> Since the last version, I've added some more locking (assigning to
> a u64 isn't atomic on non-64-bit architectures). I've not added
> the sysfs bits, as I haven't had a chance to try out Goffredo's
> sysfs code yet. I've also not implemented liubo's suggestion of
> tracking the current block group ID (I'll take that discussion up
> with him separately -- basically it's not a good fit with the
> "polling" method required by this ioctl).
>
> Hugo Mills (2): Balance progress monitoring. Cancel filesystem
> balance.
>
> fs/btrfs/ctree.h | 10 ++++++++ fs/btrfs/disk-io.c | 2 +
> fs/btrfs/ioctl.c | 62
> ++++++++++++++++++++++++++++++++++++++++++++++++ fs/btrfs/ioctl.h
> | 8 ++++++ fs/btrfs/volumes.c | 66
> ++++++++++++++++++++++++++++++++++++++++++++++++++- 5 files
> changed, 146 insertions(+), 2 deletions(-)
>
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJNhcBJAAoJEJIcBJ3+Xkgi5usP/iUORDKVdCw6gyzZRRWIYHpj
bTn9zgvyatAtRlwdzxA17XUzx6+r3RPMZPYGSn4tMfatjghfvtPDn9RX+YFTzSAL
OM8fYWfFY36dKYLJk4N2FZ3mDC5tHsU7SCzviqyAb5qlFWVmRXuq0YFQ1TjLQ528
r77BfkbiAVXRc+t9I4BrUHueuK1IPF+XijMzvwfH6iUaX9bZ9woOs8xCqP2MCG7U
3uiTf6Hcfw3mN77hy3zlf180Dh27h47YADPMoPym3J0o/9bjbo1KcBeJ+9TYn7mv
aN5pZWSadszlAPwcfidCNGz8O5+fsIAxfBvF0BHHISIBHU8SwlBrZNx/GzyGENd9
EQduDuvi9eLm2+T9ioKcXz7KqebKs6vt4NR5wXGv7j6vLlaB+LgbH2j0oHj1ZA94
lTwd9bfJBogZCxYUlCsEMKyv/JLY/e183H0DO9pbABrqyZbK5koF0SIZxp90i1Ep
YviSBWVyzr0yERP+qenLMNG5NMXMiCup9fGBd8Upil1hTlnxDqCbpvne2MbjsLsv
CGY2w8PAnfhmGpT9L14o6ExMriHu7OhegMvBATnBv3BI9pd0ev7Titwm9pUBW/X4
0toKMUI0630gTg1klds8ibo0x5BF+0MtE29X/WFhpepxMtrR1e+IOsAy409eTb67
qpo81U/CeaaYJi+gV367
=R7Bg
-----END PGP SIGNATURE-----

