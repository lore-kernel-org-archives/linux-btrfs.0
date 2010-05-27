From: Paul Millar <paul.millar@desy.de>
Subject: A couple of questions
Date: Thu, 27 May 2010 15:39:54 +0200
Message-ID: <201005271539.55644.paul.millar@desy.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been looking at Btrfs and have a couple of naive questions that don't 
seem to be answered on the wiki or in the articles I've read on the 
filesystem.


First: discovering a file's checksum value.

Here's the scenario: software is writing some data as a fresh file.  This 
software happens to know (a priori) the checksum of this data; for example, a 
storage server receives the file's data and checksum independently.

I've some confidence that, once the data is stored in btrfs, any corruption 
(from the storage fabric) will be spotted; however, the data may have became 
corrupt before being stored (e.g., from the network).  To catch this, the 
checksum of the stored data needs to be calculated and checked.

One approach is to calculate the checksum (in user-space) after the data is 
stored.  This adds extra IO- and CPU-load and there's also the possibility of 
false-negative results due to the filesystem cache (although btrfs may remove 
this risk).

Another approach would be to ask btrfs for the checksum.  It seems that it's 
possible to combine multiple CRC-32C values to figure out the checksum of the 
combined data [e.g., zlib's crc32_combine() function].  So, obtaining a file's 
checksum might be a light-weight operation.

Yet another possibility would be to push the desired checksum value (via 
fcntl?) and have btrfs compare the desired checksum with the file's actual 
checksum on close(2), failing that call if the checksums don't match.

Would any of this be possible (without an awful lot of work)?



Second: adding support for Adler32?

Looking at the unstable git repo, it looks like there's currently support for 
only the CRC-32C checksum algorithm.  Is this correct?  If so, is anyone 
working on adding support for Adler32?

Cheers,

Paul.
(ps, please keep me CC-ed in on replies)
