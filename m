From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Data De-duplication
Date: Wed, 10 Dec 2008 08:30:02 -0500
Message-ID: <1228915802.11900.8.camel@think.oraclecorp.com>
References: <1228862899.8130.1.camel@mattos-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228862899.8130.1.camel@mattos-laptop>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-12-09 at 22:48 +0000, Oliver Mattos wrote:
> Hi,
> 
> Say I download a large file from the net to /mnt/a.iso.  I then download
> the same file again to /mnt/b.iso.  These files now have the same
> content, but are stored twice since the copies weren't made with the bcp
> utility.
> 
> The same occurs if a directory tree with duplicate files (created with
> bcp) is put through a non-aware program - for example tarred and then
> untarred again.
> 
> This could be improved in two ways:
> 
> 1)  Make a utility which checks the checksums for all the data extents,
> and if the checksums of data match for two files then check the file
> data, and if the file data matches then keep only one copy.  It could be
> run as a cron job to free up disk space on systems where duplicate data
> is common (eg. virtual machine images)
> 

Sage did extend the ioctl used by bcp to be able to deal with ranges of
files bytes.  So, it could be used to do the  actual cow step for this
utility.

> 2)  Keep a tree of checksums for data blocks, so that a bit of data can
> be located by it's checksum.  Whenever a data block is about to be
> written check if the block matches any known block, and if it does then
> don't bother duplicating the data on disk.  I suspect this option may
> not be realistic for performance reasons.
> 

When compression was added, the writeback path was changed to make
option #2 viable, at least in the case where the admin is willing to
risk hash collisions on strong hashes.  When the a direct read
comparison is required before sharing blocks, it is probably best done
by a stand alone utility, since we don't want wait for a read of a full
extent every time we want to write on.

> If either is possible then thought needs to be put into if it's worth
> doing on a file level, or a partial-file level (ie. if I have two
> similar files, can the space used by the identical parts of the files be
> saved)

>From the kernel, the easiest granularity is the block level.

> 
> Has any thought been put into either 1) or 2) - are either possible or
> desired?

These are definitely on the long term feature list.  I don't think we'll
get them before 1.0, but its an important feature.

-chris


