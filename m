From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 19:37:19 +0200
Message-ID: <20090428173719.GD7217@cip.informatik.uni-erlangen.de>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com> <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <1240939437.15136.23.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240939437.15136.23.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris,

> > Is there a checksum for every block in btrfs?

> Yes, but they are only crc32c.

I see, is it easily possible to exchange that with sha-1 or md5?

> > Is it possible to retrieve these checksums from userland?

> Not today.  The sage developers sent a patch to make an ioctl for
> this, but since it was hard coded to crc32c I haven't taken it yet.

I see.

> Yes, btrfs uses extents but for the purposes of dedup, 4k blocksizes
> are fine.

Does that mean that I can dedup 4k blocks even if you use extents?

> Virtual machines are the ideal dedup workload.  But, you do get a big
> portion of the dedup benefits by just starting with a common image and
> cloning it instead of doing copies of each vm.

True, the operating system can be almost completely deduped but as soon
as you start patching you loose the benefit.

        Thomas
