From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs and 1 billion small files
Date: Tue, 8 May 2012 08:31:53 -0400
Message-ID: <20120508123153.GS11876@shiny>
References: <1913174825.1910.1336382310577.JavaMail.root@zimbra.interconnessioni.it>
 <711331964.2091.1336382892940.JavaMail.root@zimbra.interconnessioni.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alessio Focardi <alessiof@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <711331964.2091.1336382892940.JavaMail.root@zimbra.interconnessioni.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 07, 2012 at 11:28:13AM +0200, Alessio Focardi wrote:
> Hi,
> 
> I need some help in designing a storage structure for 1 billion of small files (<512 Bytes), and I was wondering how btrfs will fit in this scenario. Keep in mind that I never worked with btrfs - I just read some documentation and browsed this mailing list - so forgive me if my questions are silly! :X

A few people have already mentioned how btrfs will pack these small
files into metadata blocks.  If you're running btrfs on a single disk,
the mkfs default will duplicate metadata blocks, which will decrease the
files per disk you're able to store.

If you use mkfs.btrfs -m single, you'll store each file only once.  I
recommend some kind of raid for data you care about though, either
hardware raid or putting the files across two drives (mkfs.btrfs -m
raid1 -d raid1)

I suggest you experiment with compression.  Both lzo and zlib will make
the files smaller, but exactly how much depends quite a lot on your
workload.  We compress on a per-extent level, which varies from a single
block to up to much larger sizes.

Newer kernels (3.4 and higher) can support larger metadata block sizes.
This increases storage efficiency because we need fewer extent records
to describe all your metadata blocks.  It also allows us to pack many
more files into a single block, reducing internal btree block
fragmentation.

But the cost is increased CPU usage.  Btrfs hits memmove and memcpy
pretty hard when you're using larger blocks.

I suggest using a 16K or 32K block size.  You can go up to 64K, it may
work well if you have beefy CPUs.  Example for 16K:

mkfs.btrfs -l 16K -n 16K /dev/xxx

Others have already recommended deeper directory trees.  You can
experiment with a few variations here, but a few subdirs will improve
performance.  Too many subdirs will waste kernel ram and resources on
the dentries.

Another thing to keep in mind is that btrfs uses a btree for each
subvolume.  Using multiple subvolumes does allow you to break up the
btree locks and improve concurrency.  You can safely use a subvolume in
most places you would use a top level directory, but remember that
snapshots don't recurse into subvolumes.

-chris
