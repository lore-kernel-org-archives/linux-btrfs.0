From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 13:21:14 -0400
Message-ID: <1240939275.15136.20.camel@think.oraclecorp.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de>
	 <1240839448.26451.13.camel@think.oraclecorp.com>
	 <20090428052215.GA22921@cip.informatik.uni-erlangen.de>
	 <1240912971.2149.5.camel@think.oraclecorp.com>
	 <2a31deca0904280649w29d9cca8re9c0abc910ff99@mail.gmail.com>
	 <1240927102.15136.0.camel@think.oraclecorp.com>
	 <20090428140401.GA4223@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090428140401.GA4223@cip.informatik.uni-erlangen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-04-28 at 16:04 +0200, Thomas Glanzmann wrote:
> Chris,
> what blocksizes can I choose with btrfs? 

Right now the blocksize can only be the same as the page size.  For this
external dedup program you have in mind, you could use any multiple of
the page size.

> Do you think that it is
> possible for an outsider like me to submit patches to btrfs which enable
> dedup in three fulltime days?

Three days is probably not quite enough ;)  I'd honestly prefer the
dedup happen entirely in the kernel in a setup similar to the
compression code.

But, that would use _lots_ of CPU, so an offline dedup is probably a
good feature even if we have transparent dedup.

You'd have to:

Wire up a userland database that stores checksums and points to
file,offset tuples

Make the ioctl to replace a given file extent if and only if the file
contents match a given checksum over a range of bytes.  The ioctl should
be able to optionally do a byte compare of the src and destination pages
to make 100% sure the data is really the same.

Make another ioctl to report on which parts of a file have changed since
a given transaction.  This will greatly reduce the time spent scanning
for new blocks.

It isn't painfully hard, but you're looking at about 3 weeks total time.

-chris


