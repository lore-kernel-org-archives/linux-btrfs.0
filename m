Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61740 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbbKRDC6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Nov 2015 22:02:58 -0500
Subject: Re: Transaction aborted (error -17) after crash
To: Mordechay Kaganer <mkaganer@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CA+xOVSMpsSNfBxOghUe8H2QhzLDTC8EAABwkvrE12hUOFmfDig@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <564BEA55.4040209@gmx.com>
Date: Wed, 18 Nov 2015 11:02:45 +0800
MIME-Version: 1.0
In-Reply-To: <CA+xOVSMpsSNfBxOghUe8H2QhzLDTC8EAABwkvrE12hUOFmfDig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年11月17日 13:12, Mordechay Kaganer 写道:
> B.H.
>
> Hello.
>
> I have btrfs volume used for backups. The configuration is as follows:
>
> # uname -a
> Linux yemot-4u 4.2.5-040205-generic #201510270124 SMP Tue Oct 27
> 01:25:49 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>
> # btrfs --version
> btrfs-progs v4.2.3
>
> The volume is on top of 2 MD RAID10 arrays, 12TB each.
>
> Recently the server crashed with some weird kernel panic during
> rsyncing data to the backup volume.
>
> After reboot btrfs check passed without errors, also scrub finished
> with 0 errors.
>
> Yet, after resuming rsync the following errors appeared:
>
> [  836.026606] BTRFS warning (device md1): block group 12969790406656
> has wrong amount of free space
> [  836.026610] BTRFS warning (device md1): failed to load free space
> cache for block group 12969790406656, rebuild it now
> [ 1033.619798] BTRFS warning (device md1): block group 15322358743040
> has wrong amount of free space
> [ 1033.619801] BTRFS warning (device md1): failed to load free space
> cache for block group 15322358743040, rebuild it now

Block group seems to be corrupted, maybe some other place in extent tree 
is also corrupted.

Personally speaking, this would not be a huge problem and can be fix by 
btrfsck --init-extent-tree --repair to fix it.

But you must ensure other tree is not corrupted, by using btrfsck 
without any option to check the filesystem.

If no error in fs tree/subvolume tree check, then it would be OK to use 
above "--init-extent-tree --repair" to fix it.

Although backup is highly recommended before running --init-extent-tree.

Thanks,
Qu

> [ 2052.843713] ------------[ cut here ]------------
> [ 2052.843756] WARNING: CPU: 2 PID: 1725 at
> /home/kernel/COD/linux/fs/btrfs/extent-tree.c:2781
> btrfs_run_delayed_refs.part.73+0x242/0x270 [btrfs]()
> [ 2052.843758] BTRFS: Transaction aborted (error -17)
> [ 2052.843760] Modules linked in: ipmi_ssif x86_pkg_temp_thermal
> intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul
> aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd
> snd_hda_codec_realtek snd_hda_codec_generic serio_raw ast sb_edac ttm
> snd_hda_intel edac_core joydev drm_kms_helper snd_hda_codec drm
> input_leds snd_hda_core snd_hwdep syscopyarea sysfillrect mei_me
> snd_pcm sysimgblt lpc_ich mei snd_timer snd soundcore ipmi_si wmi
> 8250_fintek ipmi_msghandler shpchp lp mac_hid parport btrfs ses
> enclosure raid10 raid456 async_raid6_recov async_memcpy async_pq
> async_xor async_tx xor raid6_pq raid1 hid_generic igb i2c_algo_bit
> isci dca firewire_ohci usbhid ptp firewire_core raid0 libsas ahci hid
> psmouse multipath pps_core crc_itu_t libahci scsi_transport_sas
> aacraid linear
> [ 2052.843827] CPU: 2 PID: 1725 Comm: btrfs-transacti Not tainted
> 4.2.5-040205-generic #201510270124
> [ 2052.843829] Hardware name: To Be Filled By O.E.M. To Be Filled By
> O.E.M./EPC602D8A, BIOS P1.20 04/16/2014
> [ 2052.843832]  0000000000000000 00000000df907816 ffff8808414dfcb8
> ffffffff817d8d6d
> [ 2052.843836]  0000000000000000 ffff8808414dfd10 ffff8808414dfcf8
> ffffffff8107b3c6
> [ 2052.843839]  0000000000001a0c ffff88049c5fe8a0 ffff88085577d800
> ffff88082932cb80
> [ 2052.843843] Call Trace:
> [ 2052.843852]  [<ffffffff817d8d6d>] dump_stack+0x45/0x57
> [ 2052.843858]  [<ffffffff8107b3c6>] warn_slowpath_common+0x86/0xc0
> [ 2052.843862]  [<ffffffff8107b455>] warn_slowpath_fmt+0x55/0x70
> [ 2052.843878]  [<ffffffffc022ecf2>]
> btrfs_run_delayed_refs.part.73+0x242/0x270 [btrfs]
> [ 2052.843882]  [<ffffffff810e54bc>] ? del_timer_sync+0x4c/0x60
> [ 2052.843897]  [<ffffffffc022ed35>] btrfs_run_delayed_refs+0x15/0x20 [btrfs]
> [ 2052.843915]  [<ffffffffc0243756>] btrfs_commit_transaction+0x56/0xb20 [btrfs]
> [ 2052.843931]  [<ffffffffc023ee19>] transaction_kthread+0x229/0x240 [btrfs]
> [ 2052.843945]  [<ffffffffc023ebf0>] ?
> btrfs_cleanup_transaction+0x550/0x550 [btrfs]
> [ 2052.843949]  [<ffffffff8109a798>] kthread+0xd8/0xf0
> [ 2052.843953]  [<ffffffff8109a6c0>] ? kthread_create_on_node+0x1b0/0x1b0
> [ 2052.843957]  [<ffffffff817dff9f>] ret_from_fork+0x3f/0x70
> [ 2052.843960]  [<ffffffff8109a6c0>] ? kthread_create_on_node+0x1b0/0x1b0
> [ 2052.843962] ---[ end trace 6575cf272a151e61 ]---
> [ 2052.843966] BTRFS: error (device md1) in
> btrfs_run_delayed_refs:2781: errno=-17 Object already exists
> [ 2052.844024] BTRFS info (device md1): forced readonly
> [ 2052.848397] pending csums is 7327744
>
> Then, during unmount:
>
> [25209.834767] BTRFS error (device md1): cleaner transaction attach returned -30
>
>
> Any suggestions?
>
