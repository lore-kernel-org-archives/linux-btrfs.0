Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:33497 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760262AbcDFDqX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2016 23:46:23 -0400
Received: by mail-qg0-f68.google.com with SMTP id 7so435460qgj.0
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 20:46:22 -0700 (PDT)
Received: from [192.168.0.11] (CPEbc4dfb2691f3-CMbc4dfb2691f0.cpe.net.cable.rogers.com. [99.231.110.121])
        by smtp.gmail.com with ESMTPSA id 43sm469490qgh.28.2016.04.05.20.46.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 05 Apr 2016 20:46:21 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Bastien Philbert <bastienphilbert@gmail.com>
Subject: Possible Double Freeing of dentry in check_parent_dirs_for_sync
Message-ID: <5704868C.9000702@gmail.com>
Date: Tue, 5 Apr 2016 23:46:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings All,
After some tracing I am not certain if this is correct due to being newer to the btrfs 
codebase. However if someone more experience can show me if I am missing something in
my traces please let me known:)
Firstly here is the bug trace or the part that matters:
[ 7195.792492] ------------[ cut here ]------------
[ 7195.792532] WARNING: CPU: 0 PID: 5352 at /home/kernel/COD/linux/fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x247/0x2c0 [btrfs]
[ 7195.792535] Modules linked in: bnep binfmt_misc intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel samsung_laptop kvm irqbypass crct10dif_pclmul crc32_pclmul btusb ghash_clmulni_intel btrtl btbcm btintel cryptd snd_hda_codec_hdmi uvcvideo bluetooth snd_hda_codec_realtek videobuf2_vmalloc snd_hda_codec_generic videobuf2_memops arc4 videobuf2_v4l2 snd_hda_intel input_leds videobuf2_core snd_hda_codec joydev snd_hda_core iwldvm serio_raw snd_hwdep videodev snd_pcm mac80211 media snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device iwlwifi snd_timer cfg80211 snd lpc_ich mei_me soundcore shpchp mei dell_smo8800 mac_hid parport_pc ppdev lp parport autofs4 btrfs xor raid6_pq hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect psmouse sysimgblt fb_sys_fops
[ 7195.792593]  drm r8169 ahci libahci mii wmi video fjes
[ 7195.792602] CPU: 0 PID: 5352 Comm: aptitude Not tainted 4.6.0-040600rc1-generic #201603261930
[ 7195.792604] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 530U3C/530U4C/SAMSUNG_NP1234567890, BIOS P14AAJ 04/15/2013
[ 7195.792607]  0000000000000286 00000000002cb880 ffff8800c91f3d40 ffffffff813ee833
[ 7195.792611]  0000000000000000 0000000000000000 ffff8800c91f3d80 ffffffff8108275b
[ 7195.792614]  0000242da71863c0 ffff8800209bca58 ffff8800209bca58 ffff880034eda000
[ 7195.792618] Call Trace:
[ 7195.792626]  [<ffffffff813ee833>] dump_stack+0x63/0x90
[ 7195.792631]  [<ffffffff8108275b>] __warn+0xcb/0xf0
[ 7195.792635]  [<ffffffff8108288d>] warn_slowpath_null+0x1d/0x20
[ 7195.792658]  [<ffffffffc03316b7>] btrfs_destroy_inode+0x247/0x2c0 [btrfs]
[ 7195.792663]  [<ffffffff8123b44b>] destroy_inode+0x3b/0x60
[ 7195.792666]  [<ffffffff8123b5a6>] evict+0x136/0x1a0
[ 7195.792670]  [<ffffffff8123b81a>] iput+0x1ba/0x240
[ 7195.792673]  [<ffffffff81236f3d>] __dentry_kill+0x18d/0x1e0
[ 7195.792676]  [<ffffffff812370bb>] dput+0x12b/0x220
[ 7195.792680]  [<ffffffff81231f64>] SyS_rename+0x2f4/0x3c0
[ 7195.792686]  [<ffffffff81839ef6>] entry_SYSCALL_64_fastpath+0x1e/0xa8
[ 7195.792689] ---[ end trace e42100b57fd49606 ]---
[ 7464.416637] perf: interrupt took too long (3157 > 3146), lowering kernel.perf_event_max_sample_rate to 63250
[ 9697.609514] perf: interrupt took too long (3950 > 3946), lowering kernel.perf_event_max_sample_rate to 50500
Firstly we start in the btrfs function for renaming btrfs_rename which in turn calls btrfs_log_new_name,which
in turn calls check_parent_dirs_for_sync which in turn calls check_parent_dirs_for_sync. This is where I got
confused though and wanted a more experienced viewpoint on this:
parent = dget_parent(parent);
                 dput(old_parent);
                 old_parent = parent;
                 inode = d_inode(parent);
 
         }
Are we not double freeing and causing a NULL pointer deference here?
         dput(old_parent);
Sorry for the stupid question :(,
Bastien
