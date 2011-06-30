From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: btrfs-progs: integration branch updated
Date: Thu, 30 Jun 2011 23:47:36 +0200
Message-ID: <4E0CEEF8.7030901@gmail.com>
References: <20110630211902.GC4352@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Philipp <philipp.andreas@gmail.com>
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

When issuing 'make all' in this branch I get the following error:
make: *** No rule to make target `btrfs-recover-chunk.o', needed by
`btrfs-recover-chunk'.  Stop.
When trying to figure out what is going wrong I did not find a file
called btrfs-recover-chunk.c. Might it be missing?

Thanks,
Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJODO73AAoJEJIcBJ3+XkgirYkP/RBdxbKj5yluUVmlRaCGmvCy
VZMmL3M/+VsmdZykhtUyz17kE3qzFUCAswZK1axpka/YNKhKeNWKVdrUUOXvJjJs
5pkWN/WhtFpmRi/YJzT+vsvhPNSEcevQMEYzN46uTK7kjR/kebrCPhC6AHBPLBQl
8sMT091IvpU+dKBCH9bCEG8pVL5InUNoQ8TiiegL4RkdQlYfKqbUvv6Jb/P/Qx6w
60unoJpxdpX4f4yRuTX9F2vhloJ1t8qTa2eIWF/SCFQpx/9Zy4pY/XmfjfFWWMQa
0zkZ0+G9+e7cJXVAtlQVdpQhQnlSuhgM23YGerMc0k39HaGeWEEpflAkd1sP4f7w
RJWrS0og0oFKMEjK8Vs/ZJCzYGN5tapb74CXXJxO6dTXLm0mV7siJrLKBB39yIjZ
IOw09qXX3CrSETpbohX3BaFP9CxyEPwOEYIxV+0kV5Eo27Jf36cctmPD1WDlzw+/
V1MvDCEeuIiXoUBa/3gnP/PKGErsRXP4GUrf5SXkKdzU7fl1L53yvd+ogbX01H/7
SW3PONw/peUoH2Lz/TX7Sr+ifhhmoJ6RRhdytZ2yaKpq4NOWqTFKQQtGO7SLAeqL
KIK42N2yHJraIk4r5I0ULoRrK8miinaAVBGRAw9nL1pmISN0EjqhEsZB7T/HjrU7
Hsd4HWo9gqabu90eZgn6
=9fXs
-----END PGP SIGNATURE-----

