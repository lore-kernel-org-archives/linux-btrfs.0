Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:30791 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3EGLMg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 May 2013 07:12:36 -0400
Message-ID: <5188E1A1.3060904@jan-o-sch.net>
Date: Tue, 07 May 2013 13:12:33 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Elladan <elladan@eskimo.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Kernel BUG: __tree_mod_log_rewind
References: <CAEm3SNDqn6D5mm=1uTnOzpqKZVH6N6JDtj3AuJb9N2oqFB9cqg@mail.gmail.com>
In-Reply-To: <CAEm3SNDqn6D5mm=1uTnOzpqKZVH6N6JDtj3AuJb9N2oqFB9cqg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 07, 2013 at 11:25 (+0200), Elladan wrote:
> I can get btrfs to throw a kernel bug easily by running btrfs fi
> defrag on some files in 3.9.0:

Thanks for reporting. It's a known bug (that ought to be fixed before the 3.9
release in fact). You can either use btrfs-next or apply the commits mentioned
in my previous email today:

On Tue, May 07, 2013 at 08:08 (+0200), Jan Schmidt wrote:
> In git log order:
>
> 6ced2666 Btrfs: separate sequence numbers for delayed ref tracking and tree
> mod log
> ef9120b1 Btrfs: fix tree mod log regression on root split operations
> 2ed098ca Btrfs: fix accessing the root pointer in tree mod log functions
> 50723551 Btrfs: fix unlock after free on rewinded tree blocks
>
> The commit ids are from josef's master branch
> (git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git) which is
> known not to be very stable regarding commit ids.

Either way should fix your problem. An alternative is to wait for a 3.9 stable
release after those fixes are in mainline (which should happen within the next
seven days, I hope). Not using defrag, autodefrag or qgroups might also be an
effective workaround, but no guarantees on that.

-Jan

> May  7 01:57:33 caper kernel: [    0.000000] Linux version
> 3.9.0-030900-generic (apw@gomeisa) (gcc version 4.6.3 (Ubuntu/Linaro
> 4.6.3-1ubuntu5) ) #201304291257 SMP Mon Apr 29 16:58:15 UTC 2013
> ...
> May  7 02:09:21 caper kernel: [  726.745485] ------------[ cut here
> ]------------
> May  7 02:09:21 caper kernel: [  726.745567] Kernel BUG at
> ffffffffa00ea503 [verbose debug info unavailable]
> May  7 02:09:21 caper kernel: [  726.745643] invalid opcode: 0000 [#1] SMP
> May  7 02:09:21 caper kernel: [  726.745807] Modules linked in:
> snd_hrtimer zram(C) bnep rfcomm bluetooth parport_pc ppdev nfsd
> nfs_acl auth_rpcgss nfs fscache binfmt_misc lockd sunrpc
> snd_hda_codec_hdmi joydev hid_gaff ff_memless snd_usb_
> audio snd_usbmidi_lib uvcvideo snd_seq_midi videobuf2_core videodev
> snd_rawmidi videobuf2_vmalloc videobuf2_memops snd_seq_midi_event
> dm_multipath snd_hda_codec_realtek snd_seq scsi_dh kvm_amd
> snd_seq_device snd_hda_intel kvm snd_hda_codec
>  snd_hwdep microcode snd_pcm snd_timer k10temp edac_core edac_mce_amd
> serio_raw snd sp5100_tco i2c_piix4 soundcore snd_page_alloc mac_hid
> wmi it87 hwmon_vid lp parport xfs btrfs raid6_pq zlib_deflate xor
> libcrc32c ses enclosure dm_crypt hi
> d_generic usbhid hid usb_storage firewire_ohci firewire_core crc_itu_t
> ahci pata_acpi pata_atiixp libahci r8169
> May  7 02:09:21 caper kernel: [  726.749841] CPU 3
> May  7 02:09:21 caper kernel: [  726.749900] Pid: 1703, comm:
> btrfs-endio-wri Tainted: G         C   3.9.0-030900-generic
> #201304291257 Gigabyte Technology Co., Ltd.
> GA-MA790GP-UD4H/GA-MA790GP-UD4H
> May  7 02:09:21 caper kernel: [  726.750069] RIP:
> 0010:[<ffffffffa00ea503>]  [<ffffffffa00ea503>]
> __tree_mod_log_rewind+0x253/0x260 [btrfs]
> May  7 02:09:21 caper kernel: [  726.750244] RSP:
> 0018:ffff88011a2e1838  EFLAGS: 00010293
> May  7 02:09:21 caper kernel: [  726.750316] RAX: 0000000000000000
> RBX: ffff88004b2798f0 RCX: ffff88011a2e17d8
> May  7 02:09:21 caper kernel: [  726.750390] RDX: 0000000013f3a75c
> RSI: 00000000000005e8 RDI: ffff8800172ea880
> May  7 02:09:21 caper kernel: [  726.750463] RBP: ffff88011a2e1868
> R08: 0000000000001000 R09: ffff88011a2e17e8
> May  7 02:09:21 caper kernel: [  726.750536] R10: 00000000000103db
> R11: 0000000000000000 R12: ffff880098cf4d80
> May  7 02:09:21 caper kernel: [  726.750609] R13: 000000000000002b
> R14: ffff8800172ea700 R15: 000000000009c7a7
> May  7 02:09:21 caper kernel: [  726.750683] FS:
> 00007fa2bc594700(0000) GS:ffff88014fd80000(0000)
> knlGS:0000000000000000
> May  7 02:09:21 caper kernel: [  726.750770] CS:  0010 DS: 0000 ES:
> 0000 CR0: 000000008005003b
> May  7 02:09:21 caper kernel: [  726.750841] CR2: 00000000fd82c000
> CR3: 000000014654d000 CR4: 00000000000007e0
> May  7 02:09:21 caper kernel: [  726.750914] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> May  7 02:09:21 caper kernel: [  726.750987] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> May  7 02:09:21 caper kernel: [  726.751061] Process btrfs-endio-wri
> (pid: 1703, threadinfo ffff88011a2e0000, task ffff88004a6b2ea0)
> May  7 02:09:21 caper kernel: [  726.751147] Stack:
> May  7 02:09:21 caper kernel: [  726.751212]  ffff88011a2e1858
> ffff880104c8de30 000000000009c7a7 ffff880000000000
> May  7 02:09:21 caper kernel: [  726.751488]  00000000a8598000
> ffff880148278000 ffff88011a2e18b8 ffffffffa00ea5ef
> May  7 02:09:21 caper kernel: [  726.751763]  ffff880098cf4d80
> ffff88004b2798f0 ffff8800338d3000 0000000000000001
> May  7 02:09:21 caper kernel: [  726.752038] Call Trace:
> May  7 02:09:21 caper kernel: [  726.752135]  [<ffffffffa00ea5ef>]
> tree_mod_log_rewind+0xdf/0x240 [btrfs]
> May  7 02:09:21 caper kernel: [  726.752237]  [<ffffffffa00f25cb>]
> btrfs_search_old_slot+0x4cb/0x670 [btrfs]
> May  7 02:09:21 caper kernel: [  726.752351]  [<ffffffffa016d118>]
> __resolve_indirect_ref+0xc8/0x150 [btrfs]
> May  7 02:09:21 caper kernel: [  726.752462]  [<ffffffffa016d23e>]
> __resolve_indirect_refs+0x9e/0x200 [btrfs]
> May  7 02:09:21 caper kernel: [  726.752573]  [<ffffffffa016da3d>]
> find_parent_nodes+0x45d/0x6b0 [btrfs]
> May  7 02:09:21 caper kernel: [  726.752684]  [<ffffffffa016dd29>]
> btrfs_find_all_roots+0x99/0x100 [btrfs]
> May  7 02:09:21 caper kernel: [  726.752792]  [<ffffffffa0119620>] ?
> btrfs_submit_direct+0x190/0x190 [btrfs]
> May  7 02:09:21 caper kernel: [  726.752901]  [<ffffffffa0119620>] ?
> btrfs_submit_direct+0x190/0x190 [btrfs]
> May  7 02:09:21 caper kernel: [  726.753012]  [<ffffffffa016e977>]
> iterate_extent_inodes+0x177/0x2c0 [btrfs]
> May  7 02:09:21 caper kernel: [  726.753123]  [<ffffffffa016eb52>]
> iterate_inodes_from_logical+0x92/0xb0 [btrfs]
> May  7 02:09:21 caper kernel: [  726.753244]  [<ffffffffa0119620>] ?
> btrfs_submit_direct+0x190/0x190 [btrfs]
> May  7 02:09:21 caper kernel: [  726.753353]  [<ffffffffa0115a68>]
> record_extent_backrefs+0x78/0xf0 [btrfs]
> May  7 02:09:21 caper kernel: [  726.753462]  [<ffffffffa0120a54>]
> relink_file_extents+0x44/0x180 [btrfs]
> May  7 02:09:21 caper kernel: [  726.753571]  [<ffffffffa0120cc5>]
> btrfs_finish_ordered_io+0x135/0x4d0 [btrfs]
> May  7 02:09:21 caper kernel: [  726.753681]  [<ffffffffa0121075>]
> finish_ordered_fn+0x15/0x20 [btrfs]
> May  7 02:09:21 caper kernel: [  726.753791]  [<ffffffffa0140bb0>]
> worker_loop+0xa0/0x320 [btrfs]
> May  7 02:09:21 caper kernel: [  726.753901]  [<ffffffffa0140b10>] ?
> check_pending_worker_creates.isra.1+0xf0/0xf0 [btrfs]
> May  7 02:09:21 caper kernel: [  726.753994]  [<ffffffff810802e0>]
> kthread+0xc0/0xd0
> May  7 02:09:21 caper kernel: [  726.754069]  [<ffffffff81080220>] ?
> flush_kthread_worker+0xb0/0xb0
> May  7 02:09:21 caper kernel: [  726.754145]  [<ffffffff8170d42c>]
> ret_from_fork+0x7c/0xb0
> May  7 02:09:21 caper kernel: [  726.754219]  [<ffffffff81080220>] ?
> flush_kthread_worker+0xb0/0xb0
> May  7 02:09:21 caper kernel: [  726.754291] Code: c1 49 63 46 58 48
> 89 c2 48 c1 e2 05 48 8d 54 10 65 49 63 46 2c 48 89 c6 48 c1 e6 05 48
> 8d 74 30 65 e8 92 a6 04 00 e9 a5 fe ff ff <0f> 0b 66 66 2e 0f 1f 84 00
> 00 00 00 00 66 66 66 66 90 55 48 89
> May  7 02:09:21 caper kernel: [  726.757471] RIP  [<ffffffffa00ea503>]
> __tree_mod_log_rewind+0x253/0x260 [btrfs]
> May  7 02:09:21 caper kernel: [  726.757629]  RSP <ffff88011a2e1838>
> May  7 02:09:21 caper kernel: [  726.757753] ---[ end trace
> 42a0fb7efe948f77 ]---
> May  7 02:09:23 caper NetworkManager[2178]: <info> Unmanaged Device
> found; state CONNECTED forced. (see
> http://bugs.launchpad.net/bugs/191889)
> May  7 02:11:16 caper kernel: [  841.892609] SysRq : Emergency Sync
> May  7 02:11:17 caper kernel: [  842.672206] SysRq : Emergency Remount R/O
> 
> This happens repeatably a few minutes after I run a find /home -type f
> | xargs -n1 btrfs fi defragment -v
> 
> -J
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
