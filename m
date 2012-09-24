Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:60423 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab2IXNJG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 09:09:06 -0400
Date: Mon, 24 Sep 2012 15:08:47 +0200
From: David Sterba <dave@jikos.cz>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: crash in read_extent_buffer+0xb7/0xfb
Message-ID: <20120924130847.GD14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120920171747.GG26105@merlins.org>
 <20120921034652.GA871@merlins.org>
 <20120923161634.GA23057@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120923161634.GA23057@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 23, 2012 at 09:16:34AM -0700, Marc MERLIN wrote:
> > Oh my, now I'm trying again with a new drive, and a big cp from an
> > existing array to a new one dies with:
> > [32042.079411] ------------[ cut here ]------------                             
> > [32042.085799] kernel BUG at fs/btrfs/extent_io.c:1884!                         
> > [32042.092528] invalid opcode: 0000 [#1] PREEMPT SMP                            
> > [32042.099227] CPU 1                                                            
> > [32042.101095] Modules linked in:[32042.105950]  raid456 async_raid6_recov async
> > _pq raid6_pq async_xor xor async_memcpy async_tx ppdev lp tun autofs4 kl5kusb105
> >  ftdi_sio keyspan nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc rc_ati_x10 s
> > nd_timer i915 usbserial snd drm_kms_helper eeepc_wmi drm ati_remote asus_wmi rc_
> > core sparse_keymap    
> 
> I had a different crash while copying to a btrfs 5 disk array. Not sure if this is
> also fixed too, but pasting just in case.
>  
> [207025.055956] btrfs: bdev /dev/mapper/crypt_sdo1 errs: wr 46779, rd 0, flush 7 6, corrupt 0, gen 0

So many write and flush errors?

> [207055.067267] btrfs bad mapping eb start 8653217792 len 4096, wanted 184467440 50581869634 4

4680         if (start + min_len > eb->len) {
4681                 printk(KERN_ERR "btrfs bad mapping eb start %llu len %lu, "
4682                        "wanted %lu %lu\n", (unsigned long long)eb->start,
4683                        eb->len, start, min_len);
4684                 WARN_ON(1);
4685                 return -EINVAL;
4686         }

8653217792  = 0x203c5a000	eb->start
4096       			eb->len

184467440   = 0x00afebff0	start
50581869634 = 0xbc6ea1442	min_len

bogus numbers, no pattern, not visible in the stacktrace.


> [207055.244330] Pid: 6456, comm: btrfs-transacti Tainted: G        W    3.5.3-amd64-preempt-noide-20120903 #1 System manufacturer System Product Name/P8H67-M PRO
> [207055.261478] RIP: 0010:[<ffffffff811fc9ae>]  [<ffffffff811fc9ae>] read_extent_buffer+0xb7/0xfb
> [207055.271621] RSP: 0018:ffff880105ff3880  EFLAGS: 00010202
> [207055.278516] RAX: 0000000000000bbe RBX: ffff8800405ba1f8 RCX: ffff8800405ba2c8
> [207055.287257] RDX: ffff880105ff38ec RSI: 0000000000000086 RDI: ffff880105ff38ec
> [207055.295967] RBP: ffff880105ff38c0 R08: 007ffffffd4ebdc8 R09: 0000160000000000
> [207055.304674] R10: 0000000000001000 R11: 6db6db6db6db6db7 R12: 0000000000000004

R11 contains the POISON_FREE pattern, though it's not clear who and where
used it. It may come from some unhandled case in the write error
recovery paths.

The crash site is not any of the BUG_ON but some place that actually
tries to access an unmapped memory, so from that point it slipped
through sanity checks.


david
