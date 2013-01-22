Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail35.syd.optusnet.com.au ([211.29.133.51]:47882 "EHLO
	mail35.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123Ab3AVVmY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 16:42:24 -0500
Date: Wed, 23 Jan 2013 08:41:25 +1100
From: Skender <skender@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: Skender <skender@gmail.com>, linux-btrfs@vger.kernel.org,
        jbacik@fusionio.com
Subject: Re: BTRFS dmesg error
Message-ID: <20130122214125.GA15469@blackspider>
References: <20130121060136.GA11275@blackspider>
 <20130121110026.GE19967@twin.jikos.cz>
 <20130121202016.GA24179@blackspider>
 <20130122141702.GC28263@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130122141702.GC28263@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

The only lines the have anythinf with btrfs are as follows:

[    2.172063] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.172671] fuse init (API version 7.20)
[    2.173039] Btrfs loaded
[    2.173047] msgmni has been set to 7518
[    2.173570] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)



[   32.798088] Adding 3907664k swap on /dev/mapper/cryptswap1.  Priority:-1 extents:1 across:3907664k 
[   33.115076] btrfs: enabling auto defrag
[   33.115081] btrfs: use lzo compression
[  189.880342] device fsid d395ae3b-9894-4fe8-bd85-4ae9ed8bc3b8 devid 1 transid 992207 /dev/sda2
[  190.078452] device fsid 595d0335-bfc5-4c58-9741-f7297cec791b devid 3 transid 22139 /dev/sdb
[  190.078754] device fsid 595d0335-bfc5-4c58-9741-f7297cec791b devid 1 transid 22139 /dev/sdc
[  190.079034] device fsid 595d0335-bfc5-4c58-9741-f7297cec791b devid 2 transid 22139 /dev/sdd
[  190.079162] device fsid 595d0335-bfc5-4c58-9741-f7297cec791b devid 3 transid 22139 /dev/sdb
[  190.080181] btrfs: use lzo compression
[  194.567241] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)






On 22/01/13 15:17 +0100, David Sterba wrote:
> On Tue, Jan 22, 2013 at 07:20:17AM +1100, Skender wrote:
> > Here are a couple of lines before and after.
> 
> Still not with enough information though :)
> 
> > [432770.724678] virtuoso-t[17472]: segfault at 8 ip 00000000007f4147 sp 00007fff69250848 error 4 in virtuoso-t[400000+9ad000]
> > [615597.825359] mythtranscode[10886]: segfault at 4 ip 00000000004243c9 sp 00007fff27970368 error 4 in mythtranscode[400000+68000]
> 
> Unrelated, please look for lines that contain 'btrfs' (there may be none).
> 
> Eg. the first line after a filesystem is mounted is
> 
>   btrfs: disk space caching is enabled
> 
> so no need to go before that line
> 
> > [655330.131113] ------------[ cut here ]------------
> > [655330.131123] WARNING: at fs/btrfs/super.c:246 __btrfs_abort_transaction+0x46/0xa0()
> > [655330.131125] Hardware name: Precision WorkStation T3400  
> > [655330.131126] btrfs: Transaction aborted
> > [655330.131128] Modules linked in: xt_limit xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ip6table_filter ip6_tables iptable_filter ip_tables x_tables rfcomm bnep bluetooth dm_crypt dvb_usb_cxusb snd_hda_codec_analog dib7000p dibx000_common dvb_usb snd_hda_intel snd_hda_codec snd_hwdep dvb_core snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event rc_core dib0070 snd_seq coretemp snd_timer snd_seq_device snd kvm_intel soundcore kvm psmouse snd_page_alloc microcode x38_edac lpc_ich dcdbas serio_raw edac_core ppdev parport_pc lp parport floppy firewire_ohci firewire_core crc_itu_t nouveau tg3 ttm drm_kms_helper drm i2c_algo_bit mxm_wmi video wmi
> > [655330.131182] Pid: 5838, comm: btrfs-delalloc- Not tainted 3.6.11-custom #1
> > [655330.131183] Call Trace:
> > [655330.131190]  [<ffffffff810507dc>] warn_slowpath_common+0x83/0x9c
> > [655330.131193]  [<ffffffff81050898>] warn_slowpath_fmt+0x46/0x48
> > [655330.131197]  [<ffffffff81231e0b>] ? btrfs_reserve_extent+0xbd/0x1c6
> > [655330.131200]  [<ffffffff812208a7>] __btrfs_abort_transaction+0x46/0xa0
> > [655330.131203]  [<ffffffff812468f4>] submit_compressed_extents+0x1bd/0x415
> > [655330.131207]  [<ffffffff81246bd2>] async_cow_submit+0x86/0x8b
> > [655330.131210]  [<ffffffff8125ec27>] run_ordered_completions+0x76/0xd5
> > [655330.131213]  [<ffffffff8125f49e>] worker_loop+0x183/0x4b9
> > [655330.131216]  [<ffffffff8125f31b>] ? btrfs_queue_worker+0x288/0x288
> > [655330.131220]  [<ffffffff8106d9d0>] kthread+0x6f/0x77
> > [655330.131225]  [<ffffffff815b59c4>] kernel_thread_helper+0x4/0x10
> > [655330.131228]  [<ffffffff8106d961>] ? kthread_freezable_should_stop+0x48/0x48
> > [655330.131231]  [<ffffffff815b59c0>] ? gs_change+0x13/0x13
> > [655330.131233] ---[ end trace bc2b68accbd79b9c ]---
> > [655330.131235] BTRFS warning (device sda2): Aborting unused transaction.
> > [655729.210531] BTRFS warning (device sda2): Aborting unused transaction.
> 
> Are there lines like
> 
>   BTRFS error (device sdc1) in __btrfs_free_extent:5222: error 28
> 
> ?
> 
> thanks,
> david
