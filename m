Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35590 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2IUELP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Sep 2012 00:11:15 -0400
Date: Thu, 20 Sep 2012 21:11:13 -0700
From: Marc MERLIN <marc@merlins.org>
To: cwillu <cwillu@cwillu.com>, Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:1884!
Message-ID: <20120921041113.GA9170@merlins.org>
References: <20120920171747.GG26105@merlins.org> <20120921034652.GA871@merlins.org> <505BE4AF.60809@oracle.com> <20120920171747.GG26105@merlins.org> <20120921034652.GA871@merlins.org> <CAE5mzvh9kjSm6LK=Oja66eaVWTa0AhfrDrK1809j6oEE8XdSiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505BE4AF.60809@oracle.com> <CAE5mzvh9kjSm6LK=Oja66eaVWTa0AhfrDrK1809j6oEE8XdSiA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 20, 2012 at 09:51:59PM -0600, cwillu wrote:
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
> >
> >     int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
> >                             u64 length, u64 logical, struct page *page,
> >                             int mirror_num)
> >     {
> >             struct bio *bio;
> >             struct btrfs_device *dev;
> >             DECLARE_COMPLETION_ONSTACK(compl);
> >             u64 map_length = 0;
> >             u64 sector;
> >             struct btrfs_bio *bbio = NULL;
> >             int ret;
> >
> >             BUG_ON(!mirror_num); <<<<<
> >
> > This is more of a problem since I can't backup my filesystem (source is
> > ext4 and destination is btrfs).
> >
> > Any suggestion on what went wrong here?
> 
> There should have been a stack trace as well as a couple other things,
> can you post those as well please?

Actually, I found a few more lines in syslog just before the crash:
 kernel: [32008.938796] lost page write due to I/O error on /dev/mapper/crypt_e0e810c2-0d8f-409f-9674-e05763083a45
 kernel: [32008.938800] btrfs: bdev /dev/mapper/crypt_e0e810c2-0d8f-409f-9674-e05763083a45 errs: wr 1933, rd 0, flush 32, corrupt 0, gen 0
 kernel: [32008.954383] lost page write due to I/O error on /dev/dm-6
 kernel: [32008.954386] btrfs: bdev /dev/dm-6 errs: wr 1490, rd 0, flush 18, corrupt 0, gen 0
 kernel: [32008.969038] lost page write due to I/O error on /dev/dm-6
 kernel: [32008.969043] btrfs: bdev /dev/dm-6 errs: wr 1491, rd 0, flush 18, corrupt 0, gen 0
 kernel: [32008.979997] lost page write due to I/O error on /dev/dm-6
 kernel: [32008.980002] btrfs: bdev /dev/dm-6 errs: wr 1492, rd 0, flush 18, corrupt 0, gen 0

That helps answer my question: disk error caused the crash.

As for a stack trace, I was suprised that I didn't get one, but the lines I posted
are the last ones I got on my serial console (they didn't even make it to syslog).

to be more clear, all I got is:
[32042.079411] ------------[ cut here ]------------                             
[32042.085799] kernel BUG at fs/btrfs/extent_io.c:1884!                         
[32042.092528] invalid opcode: 0000 [#1] PREEMPT SMP                            
[32042.099227] CPU 1                                                            
[32042.101095] Modules linked in:[32042.105950]  raid456 async_raid6_recov async
_pq raid6_pq async_xor xor async_memcpy async_tx ppdev lp tun autofs4 kl5kusb105
 ftdi_sio keyspan nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc rc_ati_x10 s
nd_timer i915 usbserial snd drm_kms_helper eeepc_wmi drm ati_remote asus_wmi rc_
core sparse_keymap                                                              
LILO 23.2 boot:                                                                 
Loading linux...........................................................        
BIOS data check successful   

I'm booting with:
auto BOOT_IMAGE=linux ro root=900 panic=20 console=tty0 console=ttyS0,115200n8 elevator=cfq pcie_aspm=force edd=off irqpoll

Is panic=20 causing the stack trace not to be printed somehow?

If not, is one of my config options set wrong?
http://marc.merlins.org/tmp/config-3.5.3-amd64-preempt-noide-20120903

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
