Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbcG2Vwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 17:52:36 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: btrfs on sparc64 results in kernel stack trace in 1 minute test
From: Jeff Mahoney <jeffm@suse.com>
In-Reply-To: <CADxRZqw27A4TaYbzWLODXko3+yn=bMBEcKdsv89Jm9eqYAHEOA@mail.gmail.com>
Date: Fri, 29 Jul 2016 17:52:31 -0400
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        debian-sparc <debian-sparc@lists.debian.org>
Message-Id: <F9437FCA-585E-43EC-B004-72A300AC3FD6@suse.com>
References: <CADxRZqx-NJNpkA2hWeEuw_uMBB=oajUmTgMizdd2g5Ti9Cn1GQ@mail.gmail.com> <CAL3q7H5s_h4x6_=cUY+5VL6vG_riF9j9MuPxH032QmBFa6WU-g@mail.gmail.com> <CADxRZqw27A4TaYbzWLODXko3+yn=bMBEcKdsv89Jm9eqYAHEOA@mail.gmail.com>
To: Anatoly Pugachev <matorola@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On Jul 29, 2016, at 5:11 PM, Anatoly Pugachev <matorola@gmail.com> wrote:
> 
>> On Thu, Jul 14, 2016 at 1:29 PM, Filipe Manana <fdmanana@gmail.com> wrote:
>>> On Thu, Jul 14, 2016 at 11:08 AM, Anatoly Pugachev <matorola@gmail.com> wrote:
>>> Hi!
>>> 
>>> I'm using git (describe, v4.7-rc7-16-gcf875cc) kernel,
>>> with patch "fix extent buffer bitmap tests on big-endian systems", see
>>> [1] (to be able to load/use btrfs module)
>>> 
>>> and getting brtfs filesystem going to read only mode as well getting
>>> kernel stack trace in 1 minute after started to copying files to fs.
>> 
>> We've seen this happening on arm64 as well, and it's currently being
>> investigated.
> 
> update,
> 
> I can't reproduce same trace on 4.7.0+ kernel (v4.7-0-g523d939) with
> "big endian" patch [1] and btrfs-progs 4.7.
> After about 50 minutes of cycle copy, got:
> 
> mator@nvg5120:~$ cnt=0; while true; do let cnt++; echo -n "$cnt ";
> date; sleep 2; rm -rf /mnt/1/testdir; for i in  linux-2.6 gcc-6.1.0
> v7.4.1a; do echo -n "$i "; rsync -a $i /mnt/1/testdir; done; done
> 1 Fri Jul 29 23:16:55 MSK 2016
> linux-2.6 gcc-6.1.0 v7.4.1a 2 Fri Jul 29 23:34:18 MSK 2016
> linux-2.6 gcc-6.1.0 v7.4.1a 3 Fri Jul 29 23:57:13 MSK 2016
> rm: cannot remove '/mnt/1/testdir/linux-2.6/drivers/nvme': Directory not empty

What's that directory look like? I saw a different manifestation of the same issue that just corrupted the directory. 

> and in logs:
> 
> Jul 30 00:05:48 nvg5120 kernel: BTRFS info (device loop0): inode
> 227514 still on the orphan list
> Jul 30 00:06:01 nvg5120 kernel: ------------[ cut here ]------------
> Jul 30 00:06:01 nvg5120 kernel: WARNING: CPU: 36 PID: 3110 at
> fs/btrfs/inode.c:3215 btrfs_orphan_commit_root+0x188/0x1a0 [btrfs]
> Jul 30 00:06:02 nvg5120 kernel: Modules linked in: loop btrfs
> zlib_deflate sg e1000e ptp pps_core n2_crypto(+) flash sha256_generic
> des_generic n2_rng rng_core sunrpc autofs4 ext4 crc16 jbd2 mbcache
> raid10 raid456 libcrc32c crc32c_generic async_raid6_recov async_memcpy
> async_pq raid6_pq async_xor xor async_tx raid0 multipath linear dm_mod
> raid1 md_mod sd_mod mptsas scsi_transport_sas mptscsih scsi_mod
> mptbase
> Jul 30 00:06:02 nvg5120 kernel: CPU: 36 PID: 3110 Comm:
> btrfs-transacti Tainted: G      D         4.7.0+ #51
> Jul 30 00:06:02 nvg5120 kernel: Call Trace:
> Jul 30 00:06:02 nvg5120 kernel:  [0000000000463e44] __warn+0xa4/0xc0
> Jul 30 00:06:02 nvg5120 kernel:  [0000000010a2ae48]
> btrfs_orphan_commit_root+0x188/0x1a0 [btrfs]
> Jul 30 00:06:02 nvg5120 kernel:  [0000000010a214c0]
> commit_fs_roots+0xa0/0x180 [btrfs]
> Jul 30 00:06:02 nvg5120 kernel:  [0000000010a242d0]
> btrfs_commit_transaction+0x4b0/0xd00 [btrfs]
> Jul 30 00:06:02 nvg5120 kernel:  [0000000010a1cc30]
> transaction_kthread+0xf0/0x1c0 [btrfs]
> Jul 30 00:06:02 nvg5120 kernel:  [0000000000480ff0] kthread+0xb0/0xe0
> Jul 30 00:06:02 nvg5120 kernel:  [0000000000406044] ret_from_fork+0x1c/0x2c
> Jul 30 00:06:02 nvg5120 kernel:  [0000000000000000]           (null)
> Jul 30 00:06:02 nvg5120 kernel: ---[ end trace ee8374e54a090229 ]---
> 
> 
> [1]. http://www.spinics.net/lists/linux-btrfs/msg57193.html

This is tainted D, which means there's an Oops above this in the log.  Can you provide that?

-Jeff

--
Jeff Mahoney
SUSE Labs
