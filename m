From: Chris Mason <chris.mason@oracle.com>
Subject: Re: billion file testing of btrfs
Date: Wed, 18 Aug 2010 20:37:43 -0400
Message-ID: <20100819003743.GG5854@think>
References: <4C692F24.5000208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C692F24.5000208@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 16, 2010 at 08:29:24AM -0400, Ric Wheeler wrote:
> 
> I decided to try btrfs on F13 (2.6.33.6-147.2.4.fc13.x86_64 kernel)
> with the following fs_mark command and a 1.5 TB Seagate S-ATA disk:
> 
> # fs_mark -s 0 -S 0 -D 1000 -n 1000000 -L 1000 -d /test/ -l btrfs_log.txt
> 
> btrfs starts off at a fantastic rate - roughly 3-4 times the speed of ext4:

The results are interesting, both ext4 and btrfs seem to have a little
more than a million inodes in slab cache on my box.  The ext4 inode is 
a little fatter so it's about 2.2GB instead of 1.7GB.

I'll let btrfs run overnight.  ext4 isn't doing many reads at all but is
instead stuck in the log, but there's very little IO.  I'm not actually
sure what it is doing.

Btrfs is doing a healthy amount of writes and batches of reads.

-chris
