From: Jim Meyering <jim@meyering.net>
Subject: Re: [PATCH] copy: adjust fiemap handling of sparse files
Date: Mon, 14 Feb 2011 07:05:59 +0100
Message-ID: <87k4h3noag.fsf@rho.meyering.net>
References: <4D51D417.8090807@draigBrady.com>
	<87zkq5o1cl.fsf@rho.meyering.net> <4D5324D4.3000700@draigBrady.com>
	<4D53B789.2080505@draigBrady.com> <4D55E03E.4070705@draigBrady.com>
	<4D586EF4.6000005@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>,
	Coreutils <coreutils@gnu.org>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D586EF4.6000005@draigBrady.com> (=?iso-8859-1?Q?=22P=E1drai?=
 =?iso-8859-1?Q?g?= Brady"'s message of
	"Sun, 13 Feb 2011 23:53:24 +0000")
List-ID: <linux-btrfs.vger.kernel.org>

P=E1draig Brady wrote:
> Unfortunately, after checking BTRFS I see that fiemap
> behaves differently to EXT4. IMHO the EXT4 operation
> seems correct, and gives full info about the structure
> of a file, which cp for example can use to efficiently
> and accurately reproduce the structure at the destination.
>
> On EXT4 (on kernel-2.6.35.11-83.fc14.i686) there are no extents
> returned for holes in a file.
>
> However on btrfs it does return an extent for holes?
> So with btrfs there is no way to know an extent
> is allocated but unwritten (zero), so one must
> read and write all the data, rather than just
> fallocating the space in the destination.
>
> One can also see this with the following on btrfs:
>
> $ fallocate -l 100000000 unwritten
> $ truncate -s 100000000 sparse
> $ dd count=3D1000 bs=3D100000 if=3D/dev/zero of=3Dzero
>
> $ filefrag -vs *
> Filesystem type is: 9123683e
> File size of sparse is 100000000 (24415 blocks, blocksize 4096)
>  ext logical physical expected length flags
>    0       0        0           24415 unwritten,eof
> sparse: 1 extent found
> File size of unwritten is 100000000 (24415 blocks, blocksize 4096)
>  ext logical physical expected length flags
>    0       0    68160           12207
>    1   12207    92560    80366  12208 eof
> unwritten: 2 extents found
> File size of zeros is 100000000 (24415 blocks, blocksize 4096)
>  ext logical physical expected length flags
>    0       0    19360           20678
>    1   20678    43760    40037   3737 eof
> zeros: 2 extents found
>
> So is this expected?

I heard it's a bug in F14's btrfs.
To test btrfs properly, I had to use rawhide/F15.

> Has this already been changed to match ext4?

Yes, with a new-enough kernel.

> For my own reference, I can probably skip performance
> tests on (older) btrfs by checking `filefrag` output.
> Also in `cp`, if we see an "unwritten extent" we should
> probably create a hole rather than an empty allocation
> by default.  It's better to decrease file allocation
> than increase it.

Makes sense.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
