Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34489 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbcDZBlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 21:41:19 -0400
Received: by mail-io0-f181.google.com with SMTP id 2so3474406ioy.1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Apr 2016 18:41:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5mcO8QWTsXjb0jT6nwe3SN3G5T1xZd3bBfG5faX=1xxg@mail.gmail.com>
References: <5704868C.9000702@gmail.com> <CAL3q7H5mcO8QWTsXjb0jT6nwe3SN3G5T1xZd3bBfG5faX=1xxg@mail.gmail.com>
From: Paulo Dias <paulo.miguel.dias@gmail.com>
Date: Mon, 25 Apr 2016 22:40:59 -0300
Message-ID: <CADJPUQ8=WVZH6WQuL_WLQqgbJWCwRKNJYtT1vZf308mZTAy+Xw@mail.gmail.com>
Subject: Re: Possible Double Freeing of dentry in check_parent_dirs_for_sync
To: fdmanana@gmail.com
Cc: Bastien Philbert <bastienphilbert@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi/2 all..

we are in 4.6 rc5 and im still seeing a LOT of this with my SSD:

Abr 25 22:38:01 hydra kernel: ------------[ cut here ]------------
Abr 25 22:38:01 hydra kernel: WARNING: CPU: 1 PID: 6236 at
/home/kernel/COD/linux/fs/btrfs/inode.c:9261
btrfs_destroy_inode+0x247/0x2c0 [btrfs]
Abr 25 22:38:01 hydra kernel: Modules linked in: drbg ansi_cprng ctr
ccm rfcomm hid_generic usbhid hid rtsx_usb_ms memstick pci_stub bnep
vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) binfmt_misc
nls_iso8859_1 dell_wmi sparse_keymap ath3k intel_rapl btusb
x86_pkg_temp_thermal intel_powerclamp btrtl dell_laptop btbcm btintel
coretemp bluetooth dell_smm_hwmon kvm_intel kvm irqbypass
crct10dif_pclmul crc32_pclmul uvcvideo dell_led dell_smbios
ghash_clmulni_intel videobuf2_vmalloc dcdbas videobuf2_memops
videobuf2_v4l2 aesni_intel videobuf2_core snd_hda_codec_realtek
aes_x86_64 snd_hda_codec_generic videodev lrw gf128mul arc4 media
glue_helper ablk_helper cryptd snd_hda_intel snd_hda_codec ath9k
snd_hda_core input_leds ath9k_common joydev snd_hwdep serio_raw
snd_pcm ath9k_hw ath snd_seq_midi mac80211 snd_seq_midi_event
Abr 25 22:38:01 hydra kernel:  snd_rawmidi lpc_ich snd_seq cfg80211
snd_seq_device snd_timer snd mei_me soundcore mei shpchp
soc_button_array mac_hid dell_rbtn parport_pc ppdev lp parport autofs4
btrfs xor raid6_pq rtsx_usb_sdmmc rtsx_usb amdkfd amd_iommu_v2 radeon
i915 ttm i2c_algo_bit drm_kms_helper syscopyarea psmouse sysfillrect
sysimgblt fb_sys_fops ahci libahci r8169 drm mii wmi video fjes
Abr 25 22:38:01 hydra kernel: CPU: 1 PID: 6236 Comm: apt Tainted: G
    W  OE   4.6.0-040600rc5-generic #201604242031
Abr 25 22:38:01 hydra kernel: Hardware name: Dell Inc. Latitude
3540/02R0J9, BIOS A10 01/28/2015
Abr 25 22:38:01 hydra kernel:  0000000000000286 00000000c84e716a
ffff8801288bfd18 ffffffff813eee83
Abr 25 22:38:01 hydra kernel:  0000000000000000 0000000000000000
ffff8801288bfd58 ffffffff810827cb
Abr 25 22:38:01 hydra kernel:  0000242d3bead680 ffff8800acddbe40
ffff8800acddbe40 ffff8800354f9000
Abr 25 22:38:01 hydra kernel: Call Trace:
Abr 25 22:38:01 hydra kernel:  [<ffffffff813eee83>] dump_stack+0x63/0x90
Abr 25 22:38:01 hydra kernel:  [<ffffffff810827cb>] __warn+0xcb/0xf0
Abr 25 22:38:01 hydra kernel:  [<ffffffff810828fd>] warn_slowpath_null+0x1d/0x20
Abr 25 22:38:01 hydra kernel:  [<ffffffffc050cde7>]
btrfs_destroy_inode+0x247/0x2c0 [btrfs]
Abr 25 22:38:01 hydra kernel:  [<ffffffff8123b73b>] destroy_inode+0x3b/0x60
Abr 25 22:38:01 hydra kernel:  [<ffffffff8123b896>] evict+0x136/0x1a0
Abr 25 22:38:01 hydra kernel:  [<ffffffff8123bb0a>] iput+0x1ba/0x240
Abr 25 22:38:01 hydra kernel:  [<ffffffff8123722d>] __dentry_kill+0x18d/0x1e0
Abr 25 22:38:01 hydra kernel:  [<ffffffff812373ab>] dput+0x12b/0x220
Abr 25 22:38:01 hydra kernel:  [<ffffffff8122175b>] __fput+0x18b/0x230
Abr 25 22:38:01 hydra kernel:  [<ffffffff8122183e>] ____fput+0xe/0x10
Abr 25 22:38:01 hydra kernel:  [<ffffffff810a1663>] task_work_run+0x73/0x90
Abr 25 22:38:01 hydra kernel:  [<ffffffff81003242>]
exit_to_usermode_loop+0xc2/0xd0
Abr 25 22:38:01 hydra kernel:  [<ffffffff81003c6e>]
syscall_return_slowpath+0x4e/0x60
Abr 25 22:38:01 hydra kernel:  [<ffffffff8184037e>]
entry_SYSCALL_64_fastpath+0xa6/0xa8
Abr 25 22:38:01 hydra kernel: ---[ end trace 7071159cbaf5ff25 ]---

two questions:

1 - is this harmless? i mean, its just a warning or i can get some data loss?
2 - is anyone looking at this yet?

best
| Paulo Dias
| paulo.miguel.dias@gmail.com

Tempora mutantur, nos et mutamur in illis.


On Wed, Apr 6, 2016 at 9:26 AM, Filipe Manana <fdmanana@gmail.com> wrote:
> On Wed, Apr 6, 2016 at 4:46 AM, Bastien Philbert
> <bastienphilbert@gmail.com> wrote:
>> Greetings All,
>> After some tracing I am not certain if this is correct due to being newer to the btrfs
>> codebase. However if someone more experience can show me if I am missing something in
>> my traces please let me known:)
>> Firstly here is the bug trace or the part that matters:
>> [ 7195.792492] ------------[ cut here ]------------
>> [ 7195.792532] WARNING: CPU: 0 PID: 5352 at /home/kernel/COD/linux/fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x247/0x2c0 [btrfs]
>> [ 7195.792535] Modules linked in: bnep binfmt_misc intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel samsung_laptop kvm irqbypass crct10dif_pclmul crc32_pclmul btusb ghash_clmulni_intel btrtl btbcm btintel cryptd snd_hda_codec_hdmi uvcvideo bluetooth snd_hda_codec_realtek videobuf2_vmalloc snd_hda_codec_generic videobuf2_memops arc4 videobuf2_v4l2 snd_hda_intel input_leds videobuf2_core snd_hda_codec joydev snd_hda_core iwldvm serio_raw snd_hwdep videodev snd_pcm mac80211 media snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device iwlwifi snd_timer cfg80211 snd lpc_ich mei_me soundcore shpchp mei dell_smo8800 mac_hid parport_pc ppdev lp parport autofs4 btrfs xor raid6_pq hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect psmouse sysimgblt fb_sys_fops
>> [ 7195.792593]  drm r8169 ahci libahci mii wmi video fjes
>> [ 7195.792602] CPU: 0 PID: 5352 Comm: aptitude Not tainted 4.6.0-040600rc1-generic #201603261930
>> [ 7195.792604] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 530U3C/530U4C/SAMSUNG_NP1234567890, BIOS P14AAJ 04/15/2013
>> [ 7195.792607]  0000000000000286 00000000002cb880 ffff8800c91f3d40 ffffffff813ee833
>> [ 7195.792611]  0000000000000000 0000000000000000 ffff8800c91f3d80 ffffffff8108275b
>> [ 7195.792614]  0000242da71863c0 ffff8800209bca58 ffff8800209bca58 ffff880034eda000
>> [ 7195.792618] Call Trace:
>> [ 7195.792626]  [<ffffffff813ee833>] dump_stack+0x63/0x90
>> [ 7195.792631]  [<ffffffff8108275b>] __warn+0xcb/0xf0
>> [ 7195.792635]  [<ffffffff8108288d>] warn_slowpath_null+0x1d/0x20
>> [ 7195.792658]  [<ffffffffc03316b7>] btrfs_destroy_inode+0x247/0x2c0 [btrfs]
>> [ 7195.792663]  [<ffffffff8123b44b>] destroy_inode+0x3b/0x60
>> [ 7195.792666]  [<ffffffff8123b5a6>] evict+0x136/0x1a0
>> [ 7195.792670]  [<ffffffff8123b81a>] iput+0x1ba/0x240
>> [ 7195.792673]  [<ffffffff81236f3d>] __dentry_kill+0x18d/0x1e0
>> [ 7195.792676]  [<ffffffff812370bb>] dput+0x12b/0x220
>> [ 7195.792680]  [<ffffffff81231f64>] SyS_rename+0x2f4/0x3c0
>> [ 7195.792686]  [<ffffffff81839ef6>] entry_SYSCALL_64_fastpath+0x1e/0xa8
>> [ 7195.792689] ---[ end trace e42100b57fd49606 ]---
>> [ 7464.416637] perf: interrupt took too long (3157 > 3146), lowering kernel.perf_event_max_sample_rate to 63250
>> [ 9697.609514] perf: interrupt took too long (3950 > 3946), lowering kernel.perf_event_max_sample_rate to 50500
>> Firstly we start in the btrfs function for renaming btrfs_rename which in turn calls btrfs_log_new_name,which
>> in turn calls check_parent_dirs_for_sync which in turn calls check_parent_dirs_for_sync. This is where I got
>> confused though and wanted a more experienced viewpoint on this:
>> parent = dget_parent(parent);
>>                  dput(old_parent);
>>                  old_parent = parent;
>>                  inode = d_inode(parent);
>>
>>          }
>> Are we not double freeing and causing a NULL pointer deference here?
>>          dput(old_parent);
>
> No we aren't. dput() ignores a NULL pointer and there's no double free anywhere.
> The warning is due to something else and it's been reported a couple
> of times against 4.6-rc1 but I don't think anyone looked at it yet.
>
>
>> Sorry for the stupid question :(,
>> Bastien
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
