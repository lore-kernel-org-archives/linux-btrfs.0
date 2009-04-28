From: Dmitri Nikulin <dnikulin@gmail.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Wed, 29 Apr 2009 07:19:01 +1000
Message-ID: <3a7f57190904281419u2d8e2666v34105fb99953d264@mail.gmail.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de>
	 <1240839448.26451.13.camel@think.oraclecorp.com>
	 <20090428155900.GA1722@cip.informatik.uni-erlangen.de>
	 <1240939437.15136.23.camel@think.oraclecorp.com>
	 <20090428173719.GD7217@cip.informatik.uni-erlangen.de>
	 <1240940588.15136.31.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240940588.15136.31.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 29, 2009 at 3:43 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> So you need an extra index either way. =C2=A0It makes sense to keep t=
he
> crc32c csums for fast verification of the data read from disk and onl=
y
> use the expensive csums for dedup.

What about self-healing? With only a CRC32 to distinguish a good block
from a bad one, statistically you're likely to get an incorrectly
healed block in only every few billion blocks. And that may not be
your machine, but it'll be somebody's, since the probability is way
too high for it not to happen to somebody. Even just a 64 bit checksum
would drop the probability plenty, but I'd really only start with 128
bits. NetApp does 64 for 4k of data, ZFS does 256 bits per block, and
this traces back to the root like a highly dynamic Merkle tree.

In the CRC case the only safe redundancy is one that has 3+ copies of
the block, to compare the raw data itself, at which point you may as
well have just been using healing RAID1 without checksums.

--=20
Dmitri Nikulin

Centre for Synchrotron Science
Monash University
Victoria 3800, Australia
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
