From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: [PATCH] copy: adjust fiemap handling of sparse files
Date: Sun, 13 Feb 2011 23:53:24 +0000
Message-ID: <4D586EF4.6000005@draigBrady.com>
References: <4D51D417.8090807@draigBrady.com>	<87zkq5o1cl.fsf@rho.meyering.net>	<4D5324D4.3000700@draigBrady.com>	<4D53B789.2080505@draigBrady.com> <4D55E03E.4070705@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Coreutils <coreutils@gnu.org>
To: Jim Meyering <jim@meyering.net>,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D55E03E.4070705@draigBrady.com>
List-ID: <linux-btrfs.vger.kernel.org>

Unfortunately, after checking BTRFS I see that fiemap
behaves differently to EXT4. IMHO the EXT4 operation
seems correct, and gives full info about the structure
of a file, which cp for example can use to efficiently
and accurately reproduce the structure at the destination.

On EXT4 (on kernel-2.6.35.11-83.fc14.i686) there are no extents
returned for holes in a file.

However on btrfs it does return an extent for holes?
So with btrfs there is no way to know an extent
is allocated but unwritten (zero), so one must
read and write all the data, rather than just
fallocating the space in the destination.

One can also see this with the following on btrfs:

$ fallocate -l 100000000 unwritten
$ truncate -s 100000000 sparse
$ dd count=3D1000 bs=3D100000 if=3D/dev/zero of=3Dzero

$ filefrag -vs *
=46ilesystem type is: 9123683e
=46ile size of sparse is 100000000 (24415 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0        0           24415 unwritten,eof
sparse: 1 extent found
=46ile size of unwritten is 100000000 (24415 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0    68160           12207
   1   12207    92560    80366  12208 eof
unwritten: 2 extents found
=46ile size of zeros is 100000000 (24415 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0    19360           20678
   1   20678    43760    40037   3737 eof
zeros: 2 extents found

So is this expected?
Has this already been changed to match ext4?

=46or my own reference, I can probably skip performance
tests on (older) btrfs by checking `filefrag` output.
Also in `cp`, if we see an "unwritten extent" we should
probably create a hole rather than an empty allocation
by default.  It's better to decrease file allocation
than increase it.

cheers,
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
