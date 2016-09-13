Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35323 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758962AbcIMTUG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 15:20:06 -0400
Received: by mail-qk0-f170.google.com with SMTP id t7so83484695qkh.2
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Sep 2016 12:20:05 -0700 (PDT)
Received: from [172.16.43.119] ([150.163.68.19])
        by smtp.gmail.com with ESMTPSA id t21sm166983qkg.4.2016.09.13.12.20.03
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Sep 2016 12:20:04 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Cesar Strauss <cestrauss@gmail.com>
Subject: Filesystem forced to readonly after use
Message-ID: <a74b20fd-9640-b543-c31c-d475a51dcc57@gmail.com>
Date: Tue, 13 Sep 2016 16:20:02 -0300
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------0276B4ADD9C98B6F7CC03E4E"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------0276B4ADD9C98B6F7CC03E4E
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I have a BTRFS filesystem that is reverting to read-only after a few 
moments of use. There is a stack trace visible in the kernel log, which 
is attached.

Here is my system information:

# uname -a

Linux rescue 4.7.2-1-ARCH #1 SMP PREEMPT Sat Aug 20 23:02:56 CEST 2016 
x86_64 GNU/Linux

# btrfs --version

btrfs-progs v4.7

# btrfs fi show

Label: 'linux'  uuid: 79862c20-d0b0-4ffa-a9af-e3a40868a243
         Total devices 1 FS bytes used 284.60GiB
         devid    1 size 300.03GiB used 300.03GiB path /dev/sdb5

# btrfs fi df /mnt

Data, single: total=278.00GiB, used=274.68GiB
System, DUP: total=8.00MiB, used=64.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=11.00GiB, used=9.92GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B

As soon as the problem started, I saw that the Metadata, DUP was 
completely used. It become a little better (like above) after a scrub.
I can easily recover disk space by removing old snapshots, if needed.

The dmesg output is attached.

Before making further recovery attempts, or even restoring from backup, 
I would like to ask for the best option to proceed.

Thanks,

Cesar


--------------0276B4ADD9C98B6F7CC03E4E
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[20048.035688] BTRFS info (device sdb5): disk space caching is enabled
[20190.871802] BTRFS error (device sdb5): parent transid verify failed on 160420773888 wanted 181826 found 181573
[20190.882573] BTRFS error (device sdb5): parent transid verify failed on 160420773888 wanted 181826 found 181573
[20190.882607] ------------[ cut here ]------------
[20190.882642] WARNING: CPU: 3 PID: 5026 at fs/btrfs/extent-tree.c:2963 btrfs_run_delayed_refs+0x28c/0x2c0 [btrfs]
[20190.882645] BTRFS: Transaction aborted (error -5)
[20190.882648] Modules linked in: hid_generic usbhid hid btrfs xor raid6_pq sr_mod cdrom intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass joydev mousedev crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul dell_wmi dell_laptop amdkfd amd_iommu_v2 glue_helper sparse_keymap dell_smbios uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core videodev radeon media ums_realtek ablk_helper ttm cryptd snd_hda_codec_hdmi arc4 snd_hda_codec_realtek snd_hda_codec_generic dcdbas dell_smm_hwmon iwldvm iTCO_wdt mac80211 iTCO_vendor_support xhci_pci xhci_hcd r8169 snd_hda_intel snd_hda_codec mii iwlwifi evdev i915 input_leds led_class btusb btrtl btbcm btintel bluetooth intel_cstate intel_rapl_perf cfg80211 psmouse pcspkr
[20190.882725]  snd_hda_core mac_hid rfkill snd_hwdep thermal wmi snd_pcm drm_kms_helper snd_timer drm snd soundcore intel_gtt shpchp syscopyarea ahci sysfillrect sysimgblt fb_sys_fops i2c_algo_bit libahci fjes libata button ac battery mei_me video mei i2c_i801 lpc_ich dell_smo8800 tpm_tis tpm sch_fq_codel ip_tables x_tables ext4 crc16 jbd2 mbcache sd_mod uas usb_storage scsi_mod serio_raw atkbd libps2 ehci_pci ehci_hcd usbcore usb_common i8042 serio
[20190.882782] CPU: 3 PID: 5026 Comm: kworker/u16:2 Tainted: G        W       4.7.2-1-ARCH #1
[20190.882785] Hardware name: Dell Inc.          Dell System Vostro 3450/0GG0VM, BIOS A05 05/24/2011
[20190.882814] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[20190.882818]  0000000000000286 00000000860a9f71 ffff88015420fc90 ffffffff812eb132
[20190.882824]  ffff88015420fce0 0000000000000000 ffff88015420fcd0 ffffffff8107a3ab
[20190.882828]  00000b938efd7800 ffffffffa0c0be15 ffff880085917688 000000000000034c
[20190.882834] Call Trace:
[20190.882842]  [<ffffffff812eb132>] dump_stack+0x63/0x81
[20190.882847]  [<ffffffff8107a3ab>] __warn+0xcb/0xf0
[20190.882852]  [<ffffffff8107a42f>] warn_slowpath_fmt+0x5f/0x80
[20190.882875]  [<ffffffffa0b6dc5c>] btrfs_run_delayed_refs+0x28c/0x2c0 [btrfs]
[20190.882895]  [<ffffffffa0b6dd24>] delayed_ref_async_start+0x94/0xb0 [btrfs]
[20190.882920]  [<ffffffffa0bb8437>] btrfs_scrubparity_helper+0x77/0x350 [btrfs]
[20190.882943]  [<ffffffffa0bb874e>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[20190.882948]  [<ffffffff81093615>] process_one_work+0x1e5/0x480
[20190.882953]  [<ffffffff810938f8>] worker_thread+0x48/0x4e0
[20190.882958]  [<ffffffff810938b0>] ? process_one_work+0x480/0x480
[20190.882962]  [<ffffffff810938b0>] ? process_one_work+0x480/0x480
[20190.882968]  [<ffffffff81099598>] kthread+0xd8/0xf0
[20190.882975]  [<ffffffff815de9bf>] ret_from_fork+0x1f/0x40
[20190.882981]  [<ffffffff810994c0>] ? kthread_worker_fn+0x170/0x170
[20190.882985] ---[ end trace 99d6d7ec847d19d4 ]---
[20190.882990] BTRFS: error (device sdb5) in btrfs_run_delayed_refs:2963: errno=-5 IO failure
[20190.882994] BTRFS info (device sdb5): forced readonly
[20295.373706] BTRFS error (device sdb5): cleaner transaction attach returned -30

--------------0276B4ADD9C98B6F7CC03E4E--
