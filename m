From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 22:10:26 +0200
Message-ID: <20090428201026.GH7217@cip.informatik.uni-erlangen.de>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com> <20090428052215.GA22921@cip.informatik.uni-erlangen.de> <1240912971.2149.5.camel@think.oraclecorp.com> <2a31deca0904280649w29d9cca8re9c0abc910ff99@mail.gmail.com> <1240927102.15136.0.camel@think.oraclecorp.com> <20090428140401.GA4223@cip.informatik.uni-erlangen.de> <1240939275.15136.20.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240939275.15136.20.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris,

> Right now the blocksize can only be the same as the page size.  For
> this external dedup program you have in mind, you could use any
> multiple of the page size.

perfect. Exactly what I need.

> Three days is probably not quite enough ;)  I'd honestly prefer the
> dedup happen entirely in the kernel in a setup similar to the
> compression code.

I see. I think that it wouldn't scale because than all the checksums
need to be stored in memory or at least in an efficient b*tree. For a
1 Tbyte filesystem with 4 kbyte blocks that would mean more 5 G (!)
(assuming a 16 kbyte checksum and 4 byte block identifier and that
leaves out the b*tree overhead for fast searching) of memory.

> But, that would use _lots_ of CPU, so an offline dedup is probably a
> good feature even if we have transparent dedup.

I think that is the right way to go.

> Wire up a userland database that stores checksums and points to
> file, offset tuples

exactly. And if there is a way to retrieve the already calculated
checksums from kernel land, than it would be possible to implement a
,,systemcall'' that gives the kernel a hint of a possible duplicated
block (like providing a list of lists of blocks to the kernel that might
be duplicated because they have the same checksum). Than the kernel code
could dedup the block after byte-byte comparing it.

> Make the ioctl to replace a given file extent if and only if the file
> contents match a given checksum over a range of bytes.  The ioctl should
> be able to optionally do a byte compare of the src and destination pages
> to make 100% sure the data is really the same.

Exactly.

> Make another ioctl to report on which parts of a file have changed
> since a given transaction. This will greatly reduce the time spent
> scanning for new blocks.

That would be perfect. Even better would be a systemcall that reports
all the blocks that have been touched since a specific transaction. Like
a bitmap that sets a ,,1'' for every block that has been touched.

> It isn't painfully hard, but you're looking at about 3 weeks total
> time.

I see, so no quick hack to get it going.

        Thomas
