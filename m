From: Martin <m_btrfs@ml1.co.uk>
Subject: btrfs support for efficient SSD operation (data blocks alignment)
Date: Wed, 08 Feb 2012 19:24:03 +0000
Message-ID: <jgui4j$th5$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

My understanding is that for x86 architecture systems, btrfs only allows
a sector size of 4kB for a HDD/SSD. That is fine for the present HDDs
assuming the partitions are aligned to a 4kB boundary for that device.

However for SSDs...

I'm using for example a 60GByte SSD that has:

    8kB page size;
    16kB logical to physical mapping chunk size;
    2MB erase block size;
    64MB cache.

And the sector size reported to Linux 3.0 is the default 512 bytes!


My first thought is to try formatting with a sector size of 16kB to
align with the SSD logical mapping chunk size. This is to avoid SSD
write amplification. Also, the data transfer performance for that device
is near maximum for writes with a blocksize of 16kB and above. Yet,
btrfs supports a 4kByte page/sector size only at present...


Is there any control possible over the btrfs filesystem structure to map
metadata and data structures to the underlying device boundaries?

For example to maximise performance, can the data chunks and the data
chunk size be aligned to be sympathetic to the SSD logical mapping chunk
size and the erase block size?

What features other than the trim function does btrfs employ to optimise
for SSD operation?


Regards,
Martin


