Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44899 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3IIJX1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Sep 2013 05:23:27 -0400
Received: by mail-ob0-f170.google.com with SMTP id eh20so5759527obb.29
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Sep 2013 02:23:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <522D356A.2080708@cn.fujitsu.com>
References: <CADy=jfXO0CkqqARUp588tZ2Dd1xuj4CMao+-We49M0OgHE9G=Q@mail.gmail.com>
	<522D356A.2080708@cn.fujitsu.com>
Date: Mon, 9 Sep 2013 11:23:26 +0200
Message-ID: <CAFDW0jJnD32zj+xELr70Vb3ZSAaicgQB5_8=X51aH_KEoAVv8Q@mail.gmail.com>
Subject: Re: btrfs defrag kernel 3.11
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: "Marco L. Crociani" <marco.crociani@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ive had the same problem and this commit helped, which i had to cherry-pick:

commit c83b3452db6e1b048312c50b23f06c9634535f80
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Mon Jul 22 12:50:37 2013 -0400

    Btrfs: reset ret in record_one_backref

    I was getting warnings when running find ./ -type f -exec btrfs fi
defrag -f {}
    \; from record_one_backref because ret was set.  Turns out it was
because it was
    set to 1 because the search slot didn't come out exact and we
never reset it.
    So reset it to 0 right after the search so we don't leak this and get
    uneccessary warnings.  Thanks,

Ahmet


On Mon, Sep 9, 2013 at 4:41 AM, Wang Shilong <wangsl.fnst@cn.fujitsu.com> wrote:
>
> Hello,
>
> This bug should have been fixed by Liu Bo, the following patch:
>
> Btrfs: fix crash regarding to ulist_add_merge
>
> https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?h=for-chris&id=35f0399db6658f465b00893bdd13b992a0acfef0
>
> You can try btrfs-next:
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
>
> Thanks,
> Wang
>
> On 09/07/2013 05:35 AM, Marco L. Crociani wrote:
>>
>> Hi,
>> I have run:
>> find / -xdev \( -type f -o -type d \) -exec btrfs filesystem defragment -v
>> -- {} +
>>
>> On Ubuntu 13.04 with kernel 3.11 from root recovery shell after remounting
>> rw /
>>
>> This is the dmesg output:
>>
>> [17788.691504] ------------[ cut here ]------------
>> [17788.691510] ------------[ cut here ]------------
>> [17788.691538] WARNING: CPU: 1 PID: 2093 at
>> /home/apw/COD/linux/fs/btrfs/inode.c:2206 record_one_backref+0x3a9/0x420
>> [btrfs]()
>> [17788.691568] WARNING: CPU: 2 PID: 2095 at
>> /home/apw/COD/linux/fs/btrfs/inode.c:2206 record_one_backref+0x3a9/0x420
>> [btrfs]()
>> [17788.691540] Modules linked in: snd_usb_audio
>> [17788.691570] Modules linked in: snd_usb_audio uvcvideo snd_usbmidi_lib
>> videobuf2_vmalloc videobuf2_memops videobuf2_core videodev
>> snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_intel snd_hda_codec
>> snd_hwdep btusb eeepc_wmi asus_wmi sparse_keymap snd_pcm snd_page_alloc
>> k10temp video snd_seq_midi mac_hid snd_seq_midi_event snd_rawmidi i2c_piix4
>> dm_multipath serio_raw snd_seq snd_seq_device snd_timer scsi_dh snd
>> ohci_pci soundcore bluetooth btrfs zlib_deflate libcrc32c raid10 raid456
>> async_memcpy async_raid6_recov async_pq async_xor async_tx xor raid6_pq
>> raid0 multipath linear hid_generic usbhid hid raid1 usb_storage radeon wmi
>> i2c_algo_bit ttm r8169 mii drm_kms_helper ahci drm libahci
>> [17788.691641]  uvcvideo<4>[17788.691642] CPU: 2 PID: 2095 Comm:
>> btrfs-endio-wri Not tainted 3.11.0-031100-generic #201309021735
>> [17788.691644] Hardware name: System manufacturer System Product
>> Name/F1A75-V EVO, BIOS 0702 07/12/2011
>> [17788.691645]  000000000000089e ffff88011b091a58 ffffffff81720fca
>> 0000000000001b8b
>> [17788.691650]  snd_usbmidi_lib videobuf2_vmalloc videobuf2_memops
>> videobuf2_core videodev snd_hda_codec_realtek snd_hda_codec_hdmi
>> snd_hda_intel snd_hda_codec snd_hwdep btusb eeepc_wmi asus_wmi
>> sparse_keymap snd_pcm snd_page_alloc k10temp video snd_seq_midi mac_hid
>> snd_seq_midi_event snd_rawmidi i2c_piix4 dm_multipath serio_raw snd_seq
>> snd_seq_device snd_timer scsi_dh snd ohci_pci soundcore bluetooth btrfs
>> zlib_deflate libcrc32c raid10 raid456 async_memcpy async_raid6_recov
>> async_pq async_xor async_tx xor raid6_pq raid0 multipath linear hid_generic
>> usbhid hid raid1 usb_storage radeon wmi i2c_algo_bit ttm r8169 mii
>> drm_kms_helper ahci drm libahci
>> [17788.691717]
>> [17788.691717]  0000000000000000 ffff88011b091a98 ffffffff8106534c
>> ffff88011b091a78
>> [17788.691720]  ffff8801f3c1aea0 0000000000000001 ffff8801056d2dc0
>> 0000160000000000
>> [17788.691722] Call Trace:
>> [17788.691727]  [<ffffffff81720fca>] dump_stack+0x46/0x58
>> [17788.691730]  [<ffffffff8106534c>] warn_slowpath_common+0x8c/0xc0
>> [17788.691732]  [<ffffffff8106539a>] warn_slowpath_null+0x1a/0x20
>> [17788.691744]  [<ffffffffa030c7c9>] record_one_backref+0x3a9/0x420 [btrfs]
>> [17788.691755]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17788.691768]  [<ffffffffa035f3f2>] iterate_leaf_refs+0x52/0xc0 [btrfs]
>> [17788.691779]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17788.691790]  [<ffffffffa0361e58>] iterate_extent_inodes+0x198/0x270
>> [btrfs]
>> [17788.691801]  [<ffffffffa0361fc2>] iterate_inodes_from_logical+0x92/0xb0
>> [btrfs]
>> [17788.691812]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17788.691823]  [<ffffffffa030888c>] record_extent_backrefs+0x7c/0xf0
>> [btrfs]
>> [17788.691834]  [<ffffffffa03131e4>] relink_file_extents+0x44/0x180 [btrfs]
>> [17788.691845]  [<ffffffffa0313455>] btrfs_finish_ordered_io+0x135/0x4d0
>> [btrfs]
>> [17788.691856]  [<ffffffffa0313805>] finish_ordered_fn+0x15/0x20 [btrfs]
>> [17788.691867]  [<ffffffffa03341d0>] worker_loop+0xa0/0x320 [btrfs]
>> [17788.691878]  [<ffffffffa0334130>] ?
>> check_pending_worker_creates.isra.1+0xe0/0xe0 [btrfs]
>> [17788.691881]  [<ffffffff81088fe0>] kthread+0xc0/0xd0
>> [17788.691884]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
>> [17788.691886]  [<ffffffff81735a2c>] ret_from_fork+0x7c/0xb0
>> [17788.691888]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
>> [17788.691890] ---[ end trace b632fc27406d343c ]---
>> [17788.691892] CPU: 1 PID: 2093 Comm: btrfs-endio-wri Not tainted
>> 3.11.0-031100-generic #201309021735
>> [17788.691894] Hardware name: System manufacturer System Product
>> Name/F1A75-V EVO, BIOS 0702 07/12/2011
>> [17788.691895]  000000000000089e ffff8801ba3bfa58 ffffffff81720fca
>> 0000000000001bd4
>> [17788.691899]  0000000000000000 ffff8801ba3bfa98 ffffffff8106534c
>> ffff8801ba3bfa78
>> [17788.691901]  ffff8801f3c1ae10 0000000000000001 ffff8801056d2dc0
>> 0000160000000000
>> [17788.691903] Call Trace:
>> [17788.691909]  [<ffffffff81720fca>] dump_stack+0x46/0x58
>> [17788.691912]  [<ffffffff8106534c>] warn_slowpath_common+0x8c/0xc0
>> [17788.691914]  [<ffffffff8106539a>] warn_slowpath_null+0x1a/0x20
>> [17788.691925]  [<ffffffffa030c7c9>] record_one_backref+0x3a9/0x420 [btrfs]
>> [17788.691937]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17788.691949]  [<ffffffffa035f3f2>] iterate_leaf_refs+0x52/0xc0 [btrfs]
>> [17788.691960]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17788.691971]  [<ffffffffa0361e58>] iterate_extent_inodes+0x198/0x270
>> [btrfs]
>> [17788.691982]  [<ffffffffa0361fc2>] iterate_inodes_from_logical+0x92/0xb0
>> [btrfs]
>> [17788.691993]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17788.692004]  [<ffffffffa030888c>] record_extent_backrefs+0x7c/0xf0
>> [btrfs]
>> [17788.692015]  [<ffffffffa03131e4>] relink_file_extents+0x44/0x180 [btrfs]
>> [17788.692026]  [<ffffffffa0313455>] btrfs_finish_ordered_io+0x135/0x4d0
>> [btrfs]
>> [17788.692037]  [<ffffffffa0313805>] finish_ordered_fn+0x15/0x20 [btrfs]
>> [17788.692048]  [<ffffffffa03341d0>] worker_loop+0xa0/0x320 [btrfs]
>> [17788.692060]  [<ffffffffa0334130>] ?
>> check_pending_worker_creates.isra.1+0xe0/0xe0 [btrfs]
>> [17788.692063]  [<ffffffff81088fe0>] kthread+0xc0/0xd0
>> [17788.692065]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
>> [17788.692067]  [<ffffffff81735a2c>] ret_from_fork+0x7c/0xb0
>> [17788.692070]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
>> [17788.692071] ---[ end trace b632fc27406d343d ]---
>> [17788.819780] ------------[ cut here ]------------
>> [17788.819810] WARNING: CPU: 2 PID: 2095 at
>> /home/apw/COD/linux/fs/btrfs/inode.c:2206 record_one_backref+0x3a9/0x420
>> [btrfs]()
>> [17788.819812] Modules linked in: snd_usb_audio uvcvideo snd_usbmidi_lib
>> videobuf2_vmalloc videobuf2_memops videobuf2_core videodev
>> snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_intel snd_hda_codec
>> snd_hwdep btusb eeepc_wmi asus_wmi sparse_keymap snd_pcm snd_page_alloc
>> k10temp video snd_seq_midi mac_hid snd_seq_midi_event snd_rawmidi i2c_piix4
>> dm_multipath serio_raw snd_seq snd_seq_device snd_timer scsi_dh snd
>> ohci_pci soundcore bluetooth btrfs zlib_deflate libcrc32c raid10 raid456
>> async_memcpy async_raid6_recov async_pq async_xor async_tx xor raid6_pq
>> raid0 multipath linear hid_generic usbhid hid raid1 usb_storage radeon wmi
>> i2c_algo_bit ttm r8169 mii drm_kms_helper ahci drm libahci
>> [17788.819843] CPU: 2 PID: 2095 Comm: btrfs-endio-wri Tainted: G
>> W    3.11.0-031100-generic #201309021735
>> [17788.819845] Hardware name: System manufacturer System Product
>> Name/F1A75-V EVO, BIOS 0702 07/12/2011
>> [17788.819846]  000000000000089e ffff88011b091a58 ffffffff81720fca
>> 0000000000003ac9
>> [17788.819849]  0000000000000000 ffff88011b091a98 ffffffff8106534c
>> ffff88011b091a78
>> [17788.819850]  ffff8801f3c1aea0 0000000000000001 ffff8801056d2dc0
>> 0000160000000000
>> [17788.819852] Call Trace:
>> [17788.819858]  [<ffffffff81720fca>] dump_stack+0x46/0x58
>> [17788.819862]  [<ffffffff8106534c>] warn_slowpath_common+0x8c/0xc0
>> [17788.819864]  [<ffffffff8106539a>] warn_slowpath_null+0x1a/0x20
>> [17788.819875]  [<ffffffffa030c7c9>] record_one_backref+0x3a9/0x420 [btrfs]
>> [17788.819886]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17788.819898]  [<ffffffffa035f3f2>] iterate_leaf_refs+0x52/0xc0 [btrfs]
>> [17788.819909]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17788.819920]  [<ffffffffa0361e58>] iterate_extent_inodes+0x198/0x270
>> [btrfs]
>> [17788.819931]  [<ffffffffa0361fc2>] iterate_inodes_from_logical+0x92/0xb0
>> [btrfs]
>> [17788.819942]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17788.819952]  [<ffffffffa030888c>] record_extent_backrefs+0x7c/0xf0
>> [btrfs]
>> [17788.819964]  [<ffffffffa03131e4>] relink_file_extents+0x44/0x180 [btrfs]
>> [17788.819974]  [<ffffffffa0313455>] btrfs_finish_ordered_io+0x135/0x4d0
>> [btrfs]
>> [17788.819986]  [<ffffffffa0313805>] finish_ordered_fn+0x15/0x20 [btrfs]
>> [17788.819997]  [<ffffffffa03341d0>] worker_loop+0xa0/0x320 [btrfs]
>> [17788.820008]  [<ffffffffa0334130>] ?
>> check_pending_worker_creates.isra.1+0xe0/0xe0 [btrfs]
>> [17788.820011]  [<ffffffff81088fe0>] kthread+0xc0/0xd0
>> [17788.820013]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
>> [17788.820016]  [<ffffffff81735a2c>] ret_from_fork+0x7c/0xb0
>> [17788.820018]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
>> [17788.820019] ---[ end trace b632fc27406d343e ]---
>> [17831.109598] ------------[ cut here ]------------
>> [17831.109627] WARNING: CPU: 1 PID: 2087 at
>> /home/apw/COD/linux/fs/btrfs/inode.c:2206 record_one_backref+0x3a9/0x420
>> [btrfs]()
>> [17831.109629] Modules linked in: snd_usb_audio uvcvideo snd_usbmidi_lib
>> videobuf2_vmalloc videobuf2_memops videobuf2_core videodev
>> snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_intel snd_hda_codec
>> snd_hwdep btusb eeepc_wmi asus_wmi sparse_keymap snd_pcm snd_page_alloc
>> k10temp video snd_seq_midi mac_hid snd_seq_midi_event snd_rawmidi i2c_piix4
>> dm_multipath serio_raw snd_seq snd_seq_device snd_timer scsi_dh snd
>> ohci_pci soundcore bluetooth btrfs zlib_deflate libcrc32c raid10 raid456
>> async_memcpy async_raid6_recov async_pq async_xor async_tx xor raid6_pq
>> raid0 multipath linear hid_generic usbhid hid raid1 usb_storage radeon wmi
>> i2c_algo_bit ttm r8169 mii drm_kms_helper ahci drm libahci
>> [17831.109660] CPU: 1 PID: 2087 Comm: btrfs-endio-wri Tainted: G
>> W    3.11.0-031100-generic #201309021735
>> [17831.109661] Hardware name: System manufacturer System Product
>> Name/F1A75-V EVO, BIOS 0702 07/12/2011
>> [17831.109663]  000000000000089e ffff8801cee7fa58 ffffffff81720fca
>> 00000000000059a5
>> [17831.109665]  0000000000000000 ffff8801cee7fa98 ffffffff8106534c
>> ffff8801cee7fa78
>> [17831.109667]  ffff8801f3c1a5a0 0000000000000001 ffff88015e95cdc0
>> 0000160000000000
>> [17831.109669] Call Trace:
>> [17831.109674]  [<ffffffff81720fca>] dump_stack+0x46/0x58
>> [17831.109677]  [<ffffffff8106534c>] warn_slowpath_common+0x8c/0xc0
>> [17831.109679]  [<ffffffff8106539a>] warn_slowpath_null+0x1a/0x20
>> [17831.109691]  [<ffffffffa030c7c9>] record_one_backref+0x3a9/0x420 [btrfs]
>> [17831.109702]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17831.109714]  [<ffffffffa035f3f2>] iterate_leaf_refs+0x52/0xc0 [btrfs]
>> [17831.109725]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17831.109736]  [<ffffffffa0361e58>] iterate_extent_inodes+0x198/0x270
>> [btrfs]
>> [17831.109747]  [<ffffffffa0361fc2>] iterate_inodes_from_logical+0x92/0xb0
>> [btrfs]
>> [17831.109758]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17831.109769]  [<ffffffffa030888c>] record_extent_backrefs+0x7c/0xf0
>> [btrfs]
>> [17831.109780]  [<ffffffffa03131e4>] relink_file_extents+0x44/0x180 [btrfs]
>> [17831.109791]  [<ffffffffa0313455>] btrfs_finish_ordered_io+0x135/0x4d0
>> [btrfs]
>> [17831.109802]  [<ffffffffa0313805>] finish_ordered_fn+0x15/0x20 [btrfs]
>> [17831.109813]  [<ffffffffa03341d0>] worker_loop+0xa0/0x320 [btrfs]
>> [17831.109824]  [<ffffffffa0334130>] ?
>> check_pending_worker_creates.isra.1+0xe0/0xe0 [btrfs]
>> [17831.109841]  [<ffffffff81088fe0>] kthread+0xc0/0xd0
>> [17831.109843]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
>> [17831.109846]  [<ffffffff81735a2c>] ret_from_fork+0x7c/0xb0
>> [17831.109848]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
>> [17831.109849] ---[ end trace b632fc27406d343f ]---
>> [17831.312062] ------------[ cut here ]------------
>> [17831.312091] WARNING: CPU: 1 PID: 2087 at
>> /home/apw/COD/linux/fs/btrfs/inode.c:2206 record_one_backref+0x3a9/0x420
>> [btrfs]()
>> [17831.312092] Modules linked in: snd_usb_audio uvcvideo snd_usbmidi_lib
>> videobuf2_vmalloc videobuf2_memops videobuf2_core videodev
>> snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_intel snd_hda_codec
>> snd_hwdep btusb eeepc_wmi asus_wmi sparse_keymap snd_pcm snd_page_alloc
>> k10temp video snd_seq_midi mac_hid snd_seq_midi_event snd_rawmidi i2c_piix4
>> dm_multipath serio_raw snd_seq snd_seq_device snd_timer scsi_dh snd
>> ohci_pci soundcore bluetooth btrfs zlib_deflate libcrc32c raid10 raid456
>> async_memcpy async_raid6_recov async_pq async_xor async_tx xor raid6_pq
>> raid0 multipath linear hid_generic usbhid hid raid1 usb_storage radeon wmi
>> i2c_algo_bit ttm r8169 mii drm_kms_helper ahci drm libahci
>> [17831.312123] CPU: 1 PID: 2087 Comm: btrfs-endio-wri Tainted: G
>> W    3.11.0-031100-generic #201309021735
>> [17831.312125] Hardware name: System manufacturer System Product
>> Name/F1A75-V EVO, BIOS 0702 07/12/2011
>> [17831.312126]  000000000000089e ffff8801cee7fa58 ffffffff81720fca
>> 0000000000005bbf
>> [17831.312129]  0000000000000000 ffff8801cee7fa98 ffffffff8106534c
>> ffff8801cee7fa78
>> [17831.312130]  ffff8801f3c1a5a0 0000000000000001 ffff88010a524a00
>> 0000160000000000
>> [17831.312133] Call Trace:
>> [17831.312138]  [<ffffffff81720fca>] dump_stack+0x46/0x58
>> [17831.312141]  [<ffffffff8106534c>] warn_slowpath_common+0x8c/0xc0
>> [17831.312143]  [<ffffffff8106539a>] warn_slowpath_null+0x1a/0x20
>> [17831.312155]  [<ffffffffa030c7c9>] record_one_backref+0x3a9/0x420 [btrfs]
>> [17831.312166]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17831.312178]  [<ffffffffa035f3f2>] iterate_leaf_refs+0x52/0xc0 [btrfs]
>> [17831.312189]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17831.312200]  [<ffffffffa0361e58>] iterate_extent_inodes+0x198/0x270
>> [btrfs]
>> [17831.312211]  [<ffffffffa0361fc2>] iterate_inodes_from_logical+0x92/0xb0
>> [btrfs]
>> [17831.312222]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17831.312233]  [<ffffffffa030888c>] record_extent_backrefs+0x7c/0xf0
>> [btrfs]
>> [17831.312244]  [<ffffffffa03131e4>] relink_file_extents+0x44/0x180 [btrfs]
>> [17831.312255]  [<ffffffffa0313455>] btrfs_finish_ordered_io+0x135/0x4d0
>> [btrfs]
>> [17831.312266]  [<ffffffffa0313805>] finish_ordered_fn+0x15/0x20 [btrfs]
>> [17831.312277]  [<ffffffffa03341d0>] worker_loop+0xa0/0x320 [btrfs]
>> [17831.312288]  [<ffffffffa0334130>] ?
>> check_pending_worker_creates.isra.1+0xe0/0xe0 [btrfs]
>> [17831.312291]  [<ffffffff81088fe0>] kthread+0xc0/0xd0
>> [17831.312294]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
>> [17831.312296]  [<ffffffff81735a2c>] ret_from_fork+0x7c/0xb0
>> [17831.312298]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
>> [17831.312300] ---[ end trace b632fc27406d3440 ]---
>> [17838.564043] ------------[ cut here ]------------
>> [17838.564072] WARNING: CPU: 0 PID: 2093 at
>> /home/apw/COD/linux/fs/btrfs/inode.c:2206 record_one_backref+0x3a9/0x420
>> [btrfs]()
>> [17838.564073] Modules linked in: snd_usb_audio uvcvideo snd_usbmidi_lib
>> videobuf2_vmalloc videobuf2_memops videobuf2_core videodev
>> snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_intel snd_hda_codec
>> snd_hwdep btusb eeepc_wmi asus_wmi sparse_keymap snd_pcm snd_page_alloc
>> k10temp video snd_seq_midi mac_hid snd_seq_midi_event snd_rawmidi i2c_piix4
>> dm_multipath serio_raw snd_seq snd_seq_device snd_timer scsi_dh snd
>> ohci_pci soundcore bluetooth btrfs zlib_deflate libcrc32c raid10 raid456
>> async_memcpy async_raid6_recov async_pq async_xor async_tx xor raid6_pq
>> raid0 multipath linear hid_generic usbhid hid raid1 usb_storage radeon wmi
>> i2c_algo_bit ttm r8169 mii drm_kms_helper ahci drm libahci
>> [17838.564104] CPU: 0 PID: 2093 Comm: btrfs-endio-wri Tainted: G
>> W    3.11.0-031100-generic #201309021735
>> [17838.564106] Hardware name: System manufacturer System Product
>> Name/F1A75-V EVO, BIOS 0702 07/12/2011
>> [17838.564107]  000000000000089e ffff8801ba3bfa58 ffffffff81720fca
>> 0000000000005dd9
>> [17838.564109]  0000000000000000 ffff8801ba3bfa98 ffffffff8106534c
>> ffff8801ba3bfa78
>> [17838.564111]  ffff8801ebe98ea0 0000000000000001 ffff8801a7919900
>> 0000160000000000
>> [17838.564113] Call Trace:
>> [17838.564119]  [<ffffffff81720fca>] dump_stack+0x46/0x58
>> [17838.564122]  [<ffffffff8106534c>] warn_slowpath_common+0x8c/0xc0
>> [17838.564124]  [<ffffffff8106539a>] warn_slowpath_null+0x1a/0x20
>> [17838.564135]  [<ffffffffa030c7c9>] record_one_backref+0x3a9/0x420 [btrfs]
>> [17838.564146]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17838.564158]  [<ffffffffa035f3f2>] iterate_leaf_refs+0x52/0xc0 [btrfs]
>> [17838.564169]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17838.564181]  [<ffffffffa0361e58>] iterate_extent_inodes+0x198/0x270
>> [btrfs]
>> [17838.564192]  [<ffffffffa0361fc2>] iterate_inodes_from_logical+0x92/0xb0
>> [btrfs]
>> [17838.564203]  [<ffffffffa030c420>] ? btrfs_submit_direct+0x190/0x190
>> [btrfs]
>> [17838.564214]  [<ffffffffa030888c>] record_extent_backrefs+0x7c/0xf0
>> [btrfs]
>> [17838.564225]  [<ffffffffa03131e4>] relink_file_extents+0x44/0x180 [btrfs]
>> [17838.564236]  [<ffffffffa0313455>] btrfs_finish_ordered_io+0x135/0x4d0
>> [btrfs]
>> [17838.564247]  [<ffffffffa0313805>] finish_ordered_fn+0x15/0x20 [btrfs]
>> [17838.564258]  [<ffffffffa03341d0>] worker_loop+0xa0/0x320 [btrfs]
>> [17838.564269]  [<ffffffffa0334130>] ?
>> check_pending_worker_creates.isra.1+0xe0/0xe0 [btrfs]
>> [17838.564272]  [<ffffffff81088fe0>] kthread+0xc0/0xd0
>> [17838.564274]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
>> [17838.564277]  [<ffffffff81735a2c>] ret_from_fork+0x7c/0xb0
>> [17838.564279]  [<ffffffff81088f20>] ? flush_kthread_worker+0xb0/0xb0
>> [17838.564281] ---[ end trace b632fc27406d3441 ]---
>>
>>
>> Is there some problem?
>>
>> Regards,
>>
>> Marco L. Crociani
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
