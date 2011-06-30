From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: btrfs-progs: integration branch updated
Date: Thu, 30 Jun 2011 23:25:59 +0200
Message-ID: <4E0CE9E7.8010107@gmail.com>
References: <20110630211902.GC4352@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110630211902.GC4352@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 30.06.2011 23:19, Hugo Mills wrote:
> After a reorganisation of patches, and sending a bunch of them to
> Chris, I've also updated the integration branch to match that.
> It's available from:
>
> http://git.darksatanic.net/repo/btrfs-progs-unstable.git/
> integration-20110630
>
> The shortlog of 17 patches in this branch beyond the ones I've
> sent to Chris is below.
>
> Hugo.
>
>
> Andreas Philipp (1): print parent ID in btrfs subvolume list
This is still the first version of my patch, which changes the default
output from btrfs subvolume list and breaks xfstests/254. Please use v2.

Thanks,
Andreas
>
> Goffredo Baroncelli (1): Scan the devices listed in
> /proc/partitions
>
> Hugo Mills (8): Balance progress monitoring. Add --monitor option
> to btrfs balance progress. User-space tool for cancelling balance
> operations. Run userspace tool in background for balances. Initial
> implementation of userspace interface for filtered balancing.
> Balance filter by device ID Balance filter for virtual address
> range Interface for device range balance filter
>
> Jan Schmidt (5): commands added scrub ioctls added
> check_mounted_where scrub userland implementation scrub added to
> manpage
>
> WuBo (1): Btrfs-progs: Add chunk tree recover tool
>
> Zhong, Xin (1): btrfs-progs: Improvement for making btrfs image
> from source directory.
>
>
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJODOnmAAoJEJIcBJ3+XkgiWSEP/3II1hXQhkp8r/ifViY1gbU0
0hREU65LlzNuGgkXj717wodnc87dCeDK3sxhj6EC8ND051XqfbrVMGlgG8Mzbtam
BGdZLO4Fabya0B3lu8I+vIyc63VvWHU6gMhbrshMPAjF9ZJEB3z4qC9xVK1869mX
ZPdqzz4Zm6nVq+KzcgDC7eIKFMX4cYZWVC22+rCTXvj5KLkb2wLldpYMzuGNUSYJ
evAviUQnkSLsu4393wwORa/9liOXgPeHdsMXIh3RFO33+MsRuLMZC+nl07/xA1w6
QQ7uSDpIaeuX2VddFIUbPLX69Uij/jsOnsFnlWgnkMMiFtdwSK2VkSBdAi91HjVL
BeTWJM8dzNZoNh6fvkc+40fFPxRk0T2FDMMitwLN6MU3aYUDJPsoOGX8sZ0SPhZg
w1nhhxLsbusWLfVoAi2KUa1auEOopVsACBEeSMxmy/c5vc47wwgf9F6TfzsszyYt
mAieWUWXVxktlw+hZB4Pnp0GOg7qXdyfkm3s8WMtPLJNiXj+LCyjVzPU2C6jqL9P
cU/0OvM64J5NGPqAwYo4+0tPhKm1TvjTlC7jYyHewvJ4hzW8HRO12UqwCASfmMZi
qCr0/EyYiCkcbzsRkRR6Ea47ipMofFaynkI0HYLcwvN5A366Zz5MFztEQjOPrbqP
J9iOP8BnjrTiJpAv3IYc
=uO19
-----END PGP SIGNATURE-----

