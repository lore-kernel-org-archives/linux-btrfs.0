From: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Subject: Data De-duplication
Date: Tue, 9 Dec 2008 22:48:19 +0000
Message-ID: <1228862899.8130.1.camel@mattos-laptop>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Say I download a large file from the net to /mnt/a.iso.  I then download
the same file again to /mnt/b.iso.  These files now have the same
content, but are stored twice since the copies weren't made with the bcp
utility.

The same occurs if a directory tree with duplicate files (created with
bcp) is put through a non-aware program - for example tarred and then
untarred again.

This could be improved in two ways:

1)  Make a utility which checks the checksums for all the data extents,
and if the checksums of data match for two files then check the file
data, and if the file data matches then keep only one copy.  It could be
run as a cron job to free up disk space on systems where duplicate data
is common (eg. virtual machine images)

2)  Keep a tree of checksums for data blocks, so that a bit of data can
be located by it's checksum.  Whenever a data block is about to be
written check if the block matches any known block, and if it does then
don't bother duplicating the data on disk.  I suspect this option may
not be realistic for performance reasons.

If either is possible then thought needs to be put into if it's worth
doing on a file level, or a partial-file level (ie. if I have two
similar files, can the space used by the identical parts of the files be
saved)

Has any thought been put into either 1) or 2) - are either possible or
desired?

Thanks
Oliver

