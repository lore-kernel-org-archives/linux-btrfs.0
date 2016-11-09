Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7953 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751095AbcKIBuT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 20:50:19 -0500
Subject: Re: btrfs support for filesystems >8TB on 32bit architectures
To: Marc MERLIN <marc@merlins.org>
References: <8e2407ee-c137-44c3-b9c8-4dec931d6c3a@cn.fujitsu.com>
 <0b840fbb-1a3d-d395-47ad-015e84eac05a@cn.fujitsu.com>
 <20161107053647.uj7df3ppve4pbfms@merlins.org>
 <10ed4e8a-c9a6-961a-fb51-16186da079e4@cn.fujitsu.com>
 <20161107145502.7lahpm6smqsv6s2q@merlins.org>
 <cf75cc57-62f9-2d88-a544-72a45aadd674@cn.fujitsu.com>
 <20161108003950.GD13371@merlins.org>
 <63a1964d-f8df-413d-c088-20163f824e3d@cn.fujitsu.com>
 <20161108010600.GE13371@merlins.org>
 <977bbf2a-5d9f-f5aa-084c-4ca1d891eb72@cn.fujitsu.com>
 <20161108152429.GC24297@merlins.org>
CC: David Sterba <dsterba@suse.com>, Hugo Mills <hugo@carfax.org.uk>,
        <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f17792e9-498a-4ff0-2cc5-674ae10a01ad@cn.fujitsu.com>
Date: Wed, 9 Nov 2016 09:50:08 +0800
MIME-Version: 1.0
In-Reply-To: <20161108152429.GC24297@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/08/2016 11:24 PM, Marc MERLIN wrote:
> On Tue, Nov 08, 2016 at 09:17:43AM +0800, Qu Wenruo wrote:
>>
>>
>> At 11/08/2016 09:06 AM, Marc MERLIN wrote:
>>> On Tue, Nov 08, 2016 at 08:43:34AM +0800, Qu Wenruo wrote:
>>>> That's strange, balance is done completely in kernel space.
>>>>
>>>> Unless we're calling vfs_* function we won't go through the extra check.
>>>>
>>>> What's the error reported?
>>>
>>> See below. Note however that is may be because btrfs received messed up the
>>> filesystem first.
>>
>> If receive can easily screw up the fs, then fsstress can also screw up
>> btrfs easily.
>>
>> So I didn't think that's the case. (Several years ago it's possible)
>
> So now I'm even more confused. I put the array back in my 64bit system and
> check --repair comes back clean, but scrub does not. Is that supposed to be possible?

Yeah, quite possible!

The truth is, current btrfs check only checks:
1) Metadata
    while --check-data-csum option will check data, but still
    follow the restriction 3).
2) Crossing reference of metadata (contents of metadata)
3) The first good mirror/backup

So quite a lot of problems can't be detected by btrfs check:
1) Data corruption (csum mismatch)
2) 2nd mirror corruption(DUP/RAID0/10) or parity error(RAID5/6)

For btrfsck to check all mirror and data, you could try out-of-tree 
offline scrub patchset:
https://github.com/adam900710/btrfs-progs/tree/fsck_scrub

Which implements the kernel scrub equivalent in btrfs-progs.

Thanks,
Qu

>
> gargamel:~# btrfs check -p --repair /dev/mapper/crypt_bcache2 2>&1 | tee /mnt/dshelf1/other/btrfs2
> enabling repair mode
> Checking filesystem on /dev/mapper/crypt_bcache2
> UUID: 6692cf4c-93d9-438c-ac30-5db6381dc4f2
> checking extents [.]
> Fixed 0 roots.
> cache and super generation don't match, space cache will be invalidated
> checking fs roots [o]
> checking csums
> checking root refs
> found 14622791987200 bytes used err is 0
> total csum bytes: 14200176492
> total tree bytes: 78239416320
> total fs tree bytes: 59524497408
> total extent tree bytes: 3236872192
> btree space waste bytes: 10068589919
> file data blocks allocated: 18101311373312
>  referenced 18038641020928
>
> Nov  8 06:55:40 gargamel kernel: [35631.988896] BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 513, gen 0
> Nov  8 06:55:40 gargamel kernel: [35631.988897] BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 514, gen 0
> Nov  8 06:55:40 gargamel kernel: [35631.988899] BTRFS warning (device dm-6): checksum error at logical 27885961216 on dev /dev/mapper/crypt_bcache2, sector 56578304, root 9461, inode 45837, offset 15459172352, length 4096, links 1 (path: system/mlocate/mlocate.db)
> Nov  8 06:55:40 gargamel kernel: [35631.988900] BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 515, gen 0
> Nov  8 06:55:40 gargamel kernel: [35631.988903] BTRFS warning (device dm-6): checksum error at logical 27887534080 on dev /dev/mapper/crypt_bcache2, sector 56581376, root 9461, inode 45837, offset 15460745216, length 4096, links 1 (path: system/mlocate/mlocate.db)
> Nov  8 06:55:40 gargamel kernel: [35631.988904] BTRFS error (device dm-6): unable to fixup (regular) error at logical 27887009792 on dev /dev/mapper/crypt_bcache2
> Nov  8 06:55:40 gargamel kernel: [35631.988905] BTRFS error (device dm-6): unable to fixup (regular) error at logical 27886878720 on dev /dev/mapper/crypt_bcache2
> Nov  8 06:55:40 gargamel kernel: [35631.988906] BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 516, gen 0
> Nov  8 06:55:40 gargamel kernel: [35631.988907] BTRFS error (device dm-6): unable to fixup (regular) error at logical 27887837184 on dev /dev/mapper/crypt_bcache2
> Nov  8 06:55:40 gargamel kernel: [35631.988908] BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 517, gen 0
> Nov  8 06:55:40 gargamel kernel: [35631.988909] BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 518, gen 0
> Nov  8 06:55:40 gargamel kernel: [35631.988910] BTRFS error (device dm-6): unable to fixup (regular) error at logical 27885830144 on dev /dev/mapper/crypt_bcache2
> Nov  8 06:55:40 gargamel kernel: [35631.988911] BTRFS error (device dm-6): unable to fixup (regular) error at logical 27885961216 on dev /dev/mapper/crypt_bcache2
> Nov  8 06:55:40 gargamel kernel: [35631.988912] BTRFS error (device dm-6): unable to fixup (regular) error at logical 27887534080 on dev /dev/mapper/crypt_bcache2
> Nov  8 06:55:40 gargamel kernel: [35631.988882] BTRFS warning (device dm-6): checksum error at logical 27887403008 on dev /dev/mapper/crypt_bcache2, sector 56581120, root 9461, inode 45837, offset 15460614144, length 4096, links 1 (path: system/mlocate/mlocate.db)
> Nov  8 06:55:40 gargamel kernel: [35631.988885] BTRFS warning (device dm-6): checksum error at logical 27887009792 on dev /dev/mapper/crypt_bcache2, sector 56580352, root 9461, inode 45837, offset 15460220928, length 4096, links 1 (path: system/mlocate/mlocate.db)
> Nov  8 06:55:40 gargamel kernel: [35631.988887] BTRFS warning (device dm-6): checksum error at logical 27886878720 on dev /dev/mapper/crypt_bcache2, sector 56580096, root 9461, inode 45837, offset 15460089856, length 4096, links 1 (path: system/mlocate/mlocate.db)
> Nov  8 06:55:40 gargamel kernel: [35631.988890] BTRFS warning (device dm-6): checksum error at logical 27887837184 on dev /dev/mapper/crypt_bcache2, sector 56581968, root 9461, inode 45837, offset 15461048320, length 4096, links 1 (path: system/mlocate/mlocate.db)
> Nov  8 06:55:40 gargamel kernel: [35631.988895] BTRFS warning (device dm-6): checksum error at logical 27885830144 on dev /dev/mapper/crypt_bcache2, sector 56578048, root 9461, inode 45837, offset 15459041280, length 4096, links 1 (path: system/mlocate/mlocate.db)
> Nov  8 06:55:40 gargamel kernel: [35631.988896] BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 513, gen 0
> Nov  8 06:55:40 gargamel kernel: [35631.988897] BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 514, gen 0
> Nov  8 06:55:40 gargamel kernel: [35631.988899] BTRFS warning (device dm-6): checksum error at logical 27885961216 on dev /dev/mapper/crypt_bcache2, sector 56578304, root 9461, inode 45837, offset 15459172352, length 4096, links 1 (path: system/mlocate/mlocate.db)
> Nov  8 06:55:40 gargamel kernel: [35631.988900] BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 515, gen 0
> Nov  8 06:55:40 gargamel kernel: [35631.988903] BTRFS warning (device dm-6): checksum error at logical 27887534080 on dev /dev/mapper/crypt_bcache2, sector 56581376, root 9461, inode 45837, offset 15460745216, length 4096, links 1 (path: system/mlocate/mlocate.db)
> Nov  8 06:55:40 gargamel kernel: [35631.988904] BTRFS error (device dm-6): unable to fixup (regular) error at logical 27887009792 on dev /dev/mapper/crypt_bcache2
> Nov  8 06:55:40 gargamel kernel: [35631.988905] BTRFS error (device dm-6): unable to fixup (regular) error at logical 27886878720 on dev /dev/mapper/crypt_bcache2
> Nov  8 06:55:40 gargamel kernel: [35631.988906] BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 516, gen 0
> Nov  8 06:55:40 gargamel kernel: [35631.988907] BTRFS error (device dm-6): unable to fixup (regular) error at logical 27887837184 on dev /dev/mapper/crypt_bcache2
> Nov  8 06:55:40 gargamel kernel: [35631.988908] BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 517, gen 0
> Nov  8 06:55:40 gargamel kernel: [35631.988909] BTRFS error (device dm-6): bdev /dev/mapper/crypt_bcache2 errs: wr 0, rd 0, flush 0, corrupt 518, gen 0
> Nov  8 06:55:40 gargamel kernel: [35631.988910] BTRFS error (device dm-6): unable to fixup (regular) error at logical 27885830144 on dev /dev/mapper/crypt_bcache2
> Nov  8 06:55:40 gargamel kernel: [35631.988911] BTRFS error (device dm-6): unable to fixup (regular) error at logical 27885961216 on dev /dev/mapper/crypt_bcache2
> Nov  8 06:55:40 gargamel kernel: [35631.988912] BTRFS error (device dm-6): unable to fixup (regular) error at logical 27887534080 on dev /dev/mapper/crypt_bcache2
>
>
>
>>>
>>> BTRFS info (device dm-0): use zlib compression
>>> BTRFS info (device dm-0): disk space caching is enabled
>>> BTRFS info (device dm-0): has skinny extents
>>> BTRFS info (device dm-0): bdev /dev/mapper/crypt_bcache0 errs: wr 0, rd 0,
>>> flush 0, corrupt 512, gen 0
>>> BTRFS info (device dm-0): detected SSD devices, enabling SSD mode
>>> BTRFS info (device dm-0): continuing balance
>>> BTRFS info (device dm-0): The free space cache file (1593999097856) is
>>> invalid. skip it
>>>
>>> BTRFS info (device dm-0): The free space cache file (1671308509184) is
>>> invalid. skip it
>>>
>>> BTRFS info (device dm-0): relocating block group 13835461197824 flags 34
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 0 PID: 22825 at fs/btrfs/disk-io.c:520
>>> btree_csum_one_bio.isra.39+0xf7/0x100
>>
>> Dirty tree block's bytenr doesn't match with page's logical.
>> It seems that the tree block is not up-to-date, maybe corrupted.
>>
>> Seems not related to the 8T limit.
>>
>> Could you please add pr_info() to print out the 'found_start' and 'start'?
>> Also I'm not familiar with this code, the number may has a clue to show
>> what's going wrong.
>>
>> Thanks,
>> Qu
>>
>>> Modules linked in: bcache configs rc_hauppauge ir_kbd_i2c
>>> cpufreq_userspace cpufreq_powersave cpufreq_conservative autofs4
>>> snd_hda_codec_hdmi joydev snd_hda_codec_realtek snd_hda_codec_generic
>>> tuner_simple tuner_types tda9887 snd_hda_intel snd_hda_codec snd_hda_core
>>> snd_hwdep tda8290 coretemp snd_pcm_oss snd_mixer_oss tuner snd_pcm msp3400
>>> snd_seq_midi snd_seq_midi_event firewire_sbp2 saa7127 snd_rawmidi
>>> hwmon_vid dm_crypt dm_mod saa7115 snd_seq bttv hid_generic snd_seq_device
>>> snd_timer ehci_pci ivtv tea575x videobuf_dma_sg rc_core videobuf_core
>>> input_leds tveeprom cx2341x v4l2_common ehci_hcd videodev media
>>> acpi_cpufreq tpm_tis tpm_tis_core gpio_ich snd soundcore tpm psmouse
>>> lpc_ich evdev asus_atk0110 serio_raw lp parport raid456 async_raid6_recov
>>> async_pq async_xor async_memcpy async_tx multipath usbhid hid sr_mod cdrom
>>> sg firewire_ohci firewire_core floppy crc_itu_t i915 atl1 fjes mii
>>> uhci_hcd usbcore usb_common
>>> CPU: 0 PID: 22825 Comm: kworker/u9:2 Tainted: G        W
>>> 4.8.5-ia32-20161028 #2
>>> Hardware name: System manufacturer P5E-VM HDMI/P5E-VM HDMI, BIOS 0604
>>> 07/16/2008
>>> Workqueue: btrfs-worker-high btrfs_worker_helper
>>> 00200286 00200286 d3d81e48 df414827 00000000 dfa12da5 d3d81e78 df05677a
>>> df9ed884 00000000 00005929 dfa12da5 00000208 df2cf067 00000208 f7463fa0
>>> f401a080 00000000 d3d81e8c df05684a 00000009 00000000 00000000 d3d81eb4
>>> Call Trace:
>>> [<df414827>] dump_stack+0x58/0x81
>>> [<df05677a>] __warn+0xea/0x110
>>> [<df2cf067>] ? btree_csum_one_bio.isra.39+0xf7/0x100
>>> [<df05684a>] warn_slowpath_null+0x2a/0x30
>>> [<df2cf067>] btree_csum_one_bio.isra.39+0xf7/0x100
>>> [<df2cf085>] __btree_submit_bio_start+0x15/0x20
>>> [<df2cdd10>] run_one_async_start+0x30/0x40
>>> [<df31286d>] btrfs_scrubparity_helper+0xcd/0x2d0
>>> [<df2cde70>] ? run_one_async_free+0x20/0x20
>>> [<df312bbd>] btrfs_worker_helper+0xd/0x10
>>> [<df06d05b>] process_one_work+0x10b/0x400
>>> [<df06d387>] worker_thread+0x37/0x4b0
>>> [<df06d350>] ? process_one_work+0x400/0x400
>>> [<df0722db>] kthread+0x9b/0xb0
>>> [<df799922>] ret_from_kernel_thread+0xe/0x24
>>> [<df072240>] ? kthread_stop+0x100/0x100
>>> ---[ end trace f461faff989bf258 ]---
>>> BTRFS: error (device dm-0) in btrfs_commit_transaction:2232: errno=-5 IO
>>> failure (Error while writing out transaction)
>>> BTRFS info (device dm-0): forced readonly
>>> BTRFS warning (device dm-0): Skipping commit of aborted transaction.
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 0 PID: 22318 at fs/btrfs/transaction.c:1854
>>> btrfs_commit_transaction+0x2f5/0xcc0
>>> BTRFS: Transaction aborted (error -5)
>>> Modules linked in: bcache configs rc_hauppauge ir_kbd_i2c
>>> cpufreq_userspace cpufreq_powersave cpufreq_conservative autofs4
>>> snd_hda_codec_hdmi joydev snd_hda_codec_realtek snd_hda_codec_generic
>>> tuner_simple tuner_types tda9887 snd_hda_intel snd_hda_codec snd_hda_core
>>> snd_hwdep tda8290 coretemp snd_pcm_oss snd_mixer_oss tuner snd_pcm msp3400
>>> snd_seq_midi snd_seq_midi_event firewire_sbp2 saa7127 snd_rawmidi
>>> hwmon_vid dm_crypt dm_mod saa7115 snd_seq bttv hid_generic snd_seq_device
>>> snd_timer ehci_pci ivtv tea575x videobuf_dma_sg rc_core videobuf_core
>>> input_leds tveeprom cx2341x v4l2_common ehci_hcd videodev media
>>> acpi_cpufreq tpm_tis tpm_tis_core gpio_ich snd soundcore tpm psmouse
>>> lpc_ich evdev asus_atk0110 serio_raw lp parport raid456 async_raid6_recov
>>> async_pq async_xor async_memcpy async_tx multipath usbhid hid sr_mod cdrom
>>> sg firewire_ohci firewire_core floppy crc_itu_t i915 atl1 fjes mii
>>> uhci_hcd usbcore usb_common
>>> CPU: 0 PID: 22318 Comm: btrfs-balance Tainted: G        W
>>> 4.8.5-ia32-20161028 #2
>>> Hardware name: System manufacturer P5E-VM HDMI/P5E-VM HDMI, BIOS 0604
>>> 07/16/2008
>>> 00000286 00000286 d74a3ca4 df414827 d74a3ce8 dfa132ab d74a3cd4 df05677a
>>> dfa075cc d74a3d04 0000572e dfa132ab 0000073e df2d7de5 0000073e f698dc00
>>> e9173e70 fffffffb d74a3cf0 df0567db 00000009 00000000 d74a3ce8 dfa075cc
>>> Call Trace:
>>> [<df414827>] dump_stack+0x58/0x81
>>> [<df05677a>] __warn+0xea/0x110
>>> [<df2d7de5>] ? btrfs_commit_transaction+0x2f5/0xcc0
>>> [<df0567db>] warn_slowpath_fmt+0x3b/0x40
>>> [<df2d7de5>] btrfs_commit_transaction+0x2f5/0xcc0
>>> [<df096800>] ? prepare_to_wait_event+0xd0/0xd0
>>> [<df33334f>] prepare_to_relocate+0x12f/0x180
>>> [<df339a41>] relocate_block_group+0x31/0x790
>>> [<df0b1427>] ? vprintk_default+0x37/0x40
>>> [<df796ca0>] ? mutex_lock+0x10/0x30
>>> [<df2f8f45>] ? btrfs_wait_ordered_roots+0x1d5/0x1f0
>>> [<df14eed6>] ? printk+0x17/0x19
>>> [<df2a47b2>] ? btrfs_printk+0x102/0x110
>>> [<df33a388>] btrfs_relocate_block_group+0x1e8/0x2e0
>>> [<df308a9f>] btrfs_relocate_chunk.isra.29+0x3f/0xf0
>>> [<df30221f>] ? free_extent_buffer+0x4f/0xa0
>>> [<df30a555>] btrfs_balance+0xb05/0x1820
>>> [<df0b0afa>] ? console_unlock+0x40a/0x630
>>> [<df30b2c1>] balance_kthread+0x51/0x80
>>> [<df30b270>] ? btrfs_balance+0x1820/0x1820
>>> [<df0722db>] kthread+0x9b/0xb0
>>> [<df799922>] ret_from_kernel_thread+0xe/0x24
>>> [<df072240>] ? kthread_stop+0x100/0x100
>>> ---[ end trace f461faff989bf259 ]---
>>> BTRFS: error (device dm-0) in cleanup_transaction:1854: errno=-5 IO failure
>>> BTRFS info (device dm-0): delayed_refs has NO entry
>>>
>>
>>
>>
>


