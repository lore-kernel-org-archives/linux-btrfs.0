From: Chris Mason <chris.mason@oracle.com>
Subject: Re: 2.6.37: Multi-second I/O latency while untarring
Date: Fri, 11 Feb 2011 10:44:38 -0500
Message-ID: <1297438671-sup-21@think>
References: <AANLkTin4628kHMRogoAarDWyGGb8-6-BiixihJmy_AUj@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Andrew Lutomirski <andy@luto.us>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <AANLkTin4628kHMRogoAarDWyGGb8-6-BiixihJmy_AUj@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Andrew Lutomirski's message of 2011-02-11 10:08:52 -0500:
> As I type this, I have an ssh process running that's dumping data into
> a fifo at high speed (maybe 500Mbps) and a tar process that's
> untarring from the same fifo onto btrfs.  The btrfs fs is mounted -o
> space_cache,compress.  This machine has 8GB ram, 8 logical cores, and
> a fast (i7-2600) CPU, so it's not an issue with the machine struggling
> under load.
> 
> Every few tens of seconds, my system stalls for several seconds.
> These stalls cause keyboard input to be lost, firefox to hang, etc.
> 
> Setting tar's ionice priority to best effort / 7 or to idle makes no difference.
> 
> ionice idle and queue_depth = 1 on the disk (a slow 2TB WD) also makes
> no difference.
> 
> max_sectors_kb = 64 in addition to the above doesn't help either.
> 
> latencytop shows regular instances of 2-7 *second* latency, variously
> in sync_page, start_transaction, btrfs_start_ordered_extent, and
> do_get_write_access (from jbd2 on my ext4 root partition).
> 
> echo 3 >drop_caches gave me 7 GB free RAM.  I still had stalls when
> 4-5 GB were still free (so it shouldn't be a problem with important
> pages being evicted).
> 
> In case it matters, all of my partitions are on LVM on dm-crypt, but
> this machine has AES-NI so the overhead from that should be minimal.
> In fact, overall CPU usage is only about 10%.
> 
> What gives?  I thought this stuff was supposed to be better on modern kernels.

We can tell more if you post the full traces from latencytop.  I have a
patch here for latencytop that adds a -c mode, which dumps the traces
out to a text files.

http://oss.oracle.com/~mason/latencytop.patch

Based on what you have here, I think it's probably a latency problem
between btrfs and the dm-crypt stuff.  How easily can setup a test
partition without dm-crypt?

-chris
