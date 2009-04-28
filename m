From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 22:15:53 +0200
Message-ID: <20090428201553.GJ7217@cip.informatik.uni-erlangen.de>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com> <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <1240939437.15136.23.camel@think.oraclecorp.com> <20090428173719.GD7217@cip.informatik.uni-erlangen.de> <1240940588.15136.31.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240940588.15136.31.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris,

> Yes, but for the purposes of dedup, it's not exactly what you want.
> You want an index by checksum, and the current btrfs code indexes by
> logical byte number in the disk.

that would be good for online dedup, but in practice that is not going
to work or I don't see how.

> So you need an extra index either way.  It makes sense to keep the
> crc32c csums for fast verification of the data read from disk and only
> use the expensive csums for dedup. 

I think that this should be part of a userland programm. It can take all
the time it wants during weekends to find dedup blocks.

> > Does that mean that I can dedup 4k blocks even if you use extents?

> Yes.

Perfect. :-)

        Thomas
