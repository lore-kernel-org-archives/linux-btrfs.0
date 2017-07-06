Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0045.outbound.protection.outlook.com ([104.47.116.45]:14720
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752418AbdGFMQj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Jul 2017 08:16:39 -0400
From: Paul Jones <paul@pauljones.id.au>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Btrfs Compression
Date: Thu, 6 Jul 2017 12:16:35 +0000
Message-ID: <SYXPR01MB21733CFE00540BC724581EC19ED50@SYXPR01MB2173.ausprd01.prod.outlook.com>
References: <MEXPR01MB2168F46962D1BFF8BC303A279ED50@MEXPR01MB2168.ausprd01.prod.outlook.com>
 <3ae39509-7d12-807d-c827-f43401766fc1@gmail.com>
In-Reply-To: <3ae39509-7d12-807d-c827-f43401766fc1@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: Austin S. Hemmelgarn [mailto:ahferroin7@gmail.com]
> Sent: Thursday, 6 July 2017 9:52 PM
> To: Paul Jones <paul@pauljones.id.au>; linux-btrfs@vger.kernel.org
> Subject: Re: Btrfs Compression
> 
> On 2017-07-05 23:19, Paul Jones wrote:
> > While reading the thread about adding zstd compression, it occurred to
> > me that there is potentially another thing affecting performance -
> > Compressed extent size. (correct my terminology if it's incorrect). I
> > have two near identical RAID1 filesystems (used for backups) on near
> > identical discs (HGST 3T), one compressed and one not. The filesystems
> > have about 40 snapshots and are about 50% full. The uncompressed
> > filesystem runs at about 60 MB/s, the compressed filesystem about 5-10
> > MB/s. There is noticeably more "noise" from the compressed filesystem
> > from all the head thrashing that happens while rsync is happening.
> >
> > Which brings me to my point - In terms of performance for compression,
> > is there some low hanging fruit in adjusting the extent size to be
> > more like uncompressed extents so there is not so much seeking
> > happening? With spinning discs with large data sets it seems pointless
> > making the numerical calculations faster if the discs can't keep up.
> > Obviously this is assuming optimisation for speed over compression
> > ratio.
> >
> > Thoughts?That really depends on too much to be certain.  In all
> > likelihood, your
> CPU or memory are your bottleneck, not your storage devices.  The data
> itself gets compressed in memory, and then sent to the storage device, it's
> not streamed directly there from the compression thread, so if the CPU was
> compressing data faster than the storage devices could transfer it, you would
> (or at least, should) be seeing better performance on the compressed
> filesystem than the uncompressed one (because you transfer less data on
> the compressed filesystem), assuming the datasets are functionally identical.
> 
> That in turn brings up a few other questions:
> * What are the other hardware components involved (namely, CPU, RAM<
> and storage controller)?  If you're using some dinky little Atom or
> Cortex-A7 CPU (or almost anything else 32-bit running at less than 2GHz
> peak), then that's probably your bottleneck.  Similarly, if you've got a cheap
> storage controller than needs a lot of attention from the CPU, then that's
> probably your bottleneck (you can check this by seeing how much processing
> power is being used when just writing to the uncompressed array (check
> how much processing power rsync uses copying between two tmpfs mounts,
> then subtract that from the total for copying the same data to the
> uncompressed filesystem)).

Hardware is AMD Phenom II X6 1055T with 8GB DDR3 on the compressed filesystem, Intel i7-3770K with 8GB DDR3 on the uncompressed. Slight difference, but both are up to the task.

> * Which compression algorithm are you using, lzo or zlib?  If the answer is
> zlib, then what you're seeing is generally expected behavior except on
> systems with reasonably high-end CPU's and fast memory, because zlib is
> _slow_.

Zlib.

> * Are you storing the same data on both arrays?  If not, then that
> immediately makes the comparison suspect (if one array is storing lots of
> small files and the other is mostly storing small numbers of large files, then I
> would expect the one with lots of small files to get worse performance, and
> compression on that one will just make things worse).
> This is even more important when using rsync, because the size of the files
> involved has a pretty big impact on it's hashing performance and even data
> transfer rate (lots of small files == more time spent in syscalls other than
> read() and write()).

The dataset is rsync-ed to the primary backup and then to the secondary backup, so contains the same content.

> 
> Additionally, when you're referring to extent size, I assume you mean the
> huge number of 128k extents that the FIEMAP ioctl (and at least older
> versions of `filefrag`) shows for compressed files?  If that's the case, then it's
> important to understand that that's due to an issue with FIEMAP, it doesn't
> understand compressed extents in BTRFS correctly, so it shows one extent
> per compressed _block_ instead, even if they are internally an extent in
> BTRFS.  You can verify the actual number of extents by checking how many
> runs of continuous 128k 'extents' there are.

It was my understanding that compressed extents are significantly smaller in size than uncompressed ones? (like 64k vs 128M? perhaps I'm thinking of something else.) I couldn't find any info about this, but I remember it being mentioned here before. Either way disk io is maxed out so something is different with compression in a way that spinning rust doesn't seem to like.


Paul.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
