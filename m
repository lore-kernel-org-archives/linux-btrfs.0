From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: Having parent transid verify failed
Date: Fri, 06 May 2011 00:04:00 +0300
Message-ID: <4DC310C0.5080808@gmail.com>
References: <4DC287D8.3040705@gmail.com> <1304595695-sup-9289@think> <4DC28DC4.7050308@gmail.com> <1304605365-sup-4172@think> <4DC2B3D2.6080307@gmail.com> <1304607926-sup-3304@think> <4DC3084A.7030100@gmail.com> <1304627478-sup-2626@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304627478-sup-2626@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 5/5/2011 11:32 =CE=BC=CE=BC, Chris Mason wrote:
> Excerpts from Konstantinos Skarlatos's message of 2011-05-05 16:27:54=
 -0400:
>> I think i made some progress. When i tried to remove the directory t=
hat
>> i suspect contains the problematic file, i got this on the console
>>
>> rm -rf serverloft/
>
> Ok, our one bad block is in the extent allocation tree.  This is goin=
g
> to be the very hardest thing to fix.
>
> Until I finish off the code to rebuild parts of the extent allocation
> tree, I think your best bet is to copy the files off.
>
> The big question is, what happened to make this error?  Can you descr=
ibe
> your setup in more detail?

I created this btrfs filesystem on an arch linux system (amd64, quad=20
core) with kernel 2.3.38.1. it is on top of a md raid 5.

[root@linuxserver ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sde1[3] sdc1[1] sda1[0] sdf1[4]
       5860535808 blocks super 1.2 level 5, 512k chunk, algorithm 2=20
[4/4] [UUUU]

the raid was grown from 3 devices to 4, and then btrfs was grown to max=
=20
size. mount options were clear_cache,compress-force.

I was investigating a performance issue that i had, because over the=20
network i could only write to the filesystem at about 32mb/sec.

when writing btrfs-delalloc- cpu usage was at 100%.

While investigating i disabled compression, enabled space_cache and=20
tried zlib compression, and various combinations, while copying large=20
files back and forth using samba.

BTW I tried to change some mount options using mount -o remount but=20
although the new options were printed on dmesg i think that they were=20
not enabled.

I got the first error when i was copying some files and at the same tim=
e=20
created a directory over samba. After a while i upgraded to 2.6.38.5 bu=
t=20
nothing seems to have changed.

I really dont think there is a hardware error here, but to be safe I am=
=20
now running a check on the raid


>
> -chris
>
>>
>> 2011 May  5 23:32:53 mail [  200.580195] Oops: 0000 [#1] PREEMPT SMP
>> 2011 May  5 23:32:53 mail [  200.580220] last sysfs file:
>> /sys/module/vt/parameters/default_utf8
>> 2011 May  5 23:32:53 mail [  200.581145] Stack:
>> 2011 May  5 23:32:53 mail [  200.581276] Call Trace:
>> 2011 May  5 23:32:53 mail [  200.581732] Code: cc 00 00 48 8d 91 28 =
e0
>> ff ff 48 89 e5 48 81 ec 90 00 00 00 48 89 5d d8 4c 89 65 e0 48 89 f3=
 4c
>> 89 6d e8 4c 89 75 f0 4c 89 7d f8<48>  8b 76 30 83 42 1c 01 48 b8 00 =
00
>> 00 00 00 16 00 00 48 01 f0
>> 2011 May  5 23:32:53 mail [  200.583376] CR2: 0000000000000030
>>
>>
>> here is the  part of dmesg that does not contain the  thousands of
>> parent transid verify failed messages
>>
>>
>> May  5 23:32:51 mail kernel: [  198.371084] parent transid verify fa=
iled
>> on 3062073683968 wanted 5181 found 5188
>> May  5 23:32:51 mail kernel: [  198.371204] parent transid verify fa=
iled
>> on 3062073683968 wanted 5181 found 5188
>> May  5 23:32:53 mail kernel: [  200.572774] Modules linked in: ipv6
>> btrfs zlib_deflate crc32c libcrc32c ext2 raid456 async_raid6_recov
>> async_pq raid6_pq async_xor xor async_memcpy async_tx md_mod usb_sto=
rage
>> uas snd_seq_dummy snd_seq_oss radeon snd_seq_midi_event ttm snd_seq
>> snd_hda_codec_hdmi snd_seq_device drm_kms_helper ohci_hcd snd_hda_in=
tel
>> snd_hda_codec snd_pcm_oss snd_hwdep drm i2c_algo_bit snd_mixer_oss
>> snd_pcm i2c_piix4 snd_timer snd soundcore snd_page_alloc ehci_hcd wm=
i
>> i2c_core usbcore evdev processor button k10temp serio_raw pcspkr sg
>> r8169 edac_core shpchp pci_hotplug edac_mce_amd mii sp5100_tco ext4
>> mbcache jbd2 crc16 sd_mod pata_acpi ahci libahci pata_atiixp libata =
scsi_mod
>> May  5 23:32:53 mail kernel: [  200.572808] Pid: 1037, comm:
>> btrfs-transacti Not tainted 2.6.38-ARCH #1
>> May  5 23:32:53 mail kernel: [  200.572810] Call Trace:
>> May  5 23:32:53 mail kernel: [  200.572817]  [<ffffffff813a932b>] ?
>> __schedule_bug+0x59/0x5d
>> May  5 23:32:53 mail kernel: [  200.572820]  [<ffffffff813af827>] ?
>> schedule+0x9f7/0xad0
>> May  5 23:32:53 mail kernel: [  200.572823]  [<ffffffff811e5827>] ?
>> generic_unplug_device+0x37/0x40
>> May  5 23:32:53 mail kernel: [  200.572827]  [<ffffffffa07ac164>] ?
>> md_raid5_unplug_device+0x64/0x110 [raid456]
>> May  5 23:32:53 mail kernel: [  200.572830]  [<ffffffffa07ac223>] ?
>> raid5_unplug_queue+0x13/0x20 [raid456]
>> May  5 23:32:53 mail kernel: [  200.572833]  [<ffffffff81012d79>] ?
>> read_tsc+0x9/0x20
>> May  5 23:32:53 mail kernel: [  200.572837]  [<ffffffff8108418c>] ?
>> ktime_get_ts+0xac/0xe0
>> May  5 23:32:53 mail kernel: [  200.572840]  [<ffffffff810e36c0>] ?
>> sync_page+0x0/0x50
>> May  5 23:32:53 mail kernel: [  200.572842]  [<ffffffff813af96e>] ?
>> io_schedule+0x6e/0xb0
>> May  5 23:32:53 mail kernel: [  200.572844]  [<ffffffff810e36fb>] ?
>> sync_page+0x3b/0x50
>> May  5 23:32:53 mail kernel: [  200.572846]  [<ffffffff813b0077>] ?
>> __wait_on_bit+0x57/0x80
>> May  5 23:32:53 mail kernel: [  200.572848]  [<ffffffff810e38c0>] ?
>> wait_on_page_bit+0x70/0x80
>> May  5 23:32:53 mail kernel: [  200.572851]  [<ffffffff8107a030>] ?
>> wake_bit_function+0x0/0x40
>> May  5 23:32:53 mail kernel: [  200.572861]  [<ffffffffa08348d2>] ?
>> read_extent_buffer_pages+0x412/0x480 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.572867]  [<ffffffffa0809e00>] ?
>> btree_get_extent+0x0/0x1b0 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.572873]  [<ffffffffa080ac7e>] ?
>> btree_read_extent_buffer_pages.isra.60+0x5e/0xb0 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.572880]  [<ffffffffa080c0bc>] ?
>> read_tree_block+0x3c/0x60 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.572884]  [<ffffffffa07f272b>] ?
>> read_block_for_search.isra.34+0x1fb/0x410 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.572890]  [<ffffffffa08417d1>] ?
>> btrfs_tree_unlock+0x51/0x60 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.572895]  [<ffffffffa07f5ca0>] ?
>> btrfs_search_slot+0x430/0xa30 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.572900]  [<ffffffffa07fb3a6>] ?
>> lookup_inline_extent_backref+0x96/0x460 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.572904]  [<ffffffff8112b8d3>] ?
>> kmem_cache_alloc+0x133/0x150
>> May  5 23:32:53 mail kernel: [  200.572908]  [<ffffffffa07fd452>] ?
>> __btrfs_free_extent+0xc2/0x6d0 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.572914]  [<ffffffffa0800f59>] ?
>> run_clustered_refs+0x389/0x830 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.572920]  [<ffffffffa084d900>] ?
>> btrfs_find_ref_cluster+0x10/0x190 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.572925]  [<ffffffffa08014c0>] ?
>> btrfs_run_delayed_refs+0xc0/0x210 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.572927]  [<ffffffff813b0cf9>] ?
>> mutex_unlock+0x9/0x10
>> May  5 23:32:53 mail kernel: [  200.572933]  [<ffffffffa0810db8>] ?
>> btrfs_commit_transaction+0x78/0x750 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.572936]  [<ffffffff81079ff0>] ?
>> autoremove_wake_function+0x0/0x40
>> May  5 23:32:53 mail kernel: [  200.572941]  [<ffffffffa080a9bd>] ?
>> transaction_kthread+0x26d/0x290 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.572947]  [<ffffffffa080a750>] ?
>> transaction_kthread+0x0/0x290 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.572949]  [<ffffffff81079717>] ?
>> kthread+0x87/0x90
>> May  5 23:32:53 mail kernel: [  200.572952]  [<ffffffff8100bc24>] ?
>> kernel_thread_helper+0x4/0x10
>> May  5 23:32:53 mail kernel: [  200.572954]  [<ffffffff81079690>] ?
>> kthread+0x0/0x90
>> May  5 23:32:53 mail kernel: [  200.572956]  [<ffffffff8100bc20>] ?
>> kernel_thread_helper+0x0/0x10
>> May  5 23:32:53 mail kernel: [  200.572971] Modules linked in: ipv6
>> btrfs zlib_deflate crc32c libcrc32c ext2 raid456 async_raid6_recov
>> async_pq raid6_pq async_xor xor async_memcpy async_tx md_mod usb_sto=
rage
>> uas snd_seq_dummy snd_seq_oss radeon snd_seq_midi_event ttm snd_seq
>> snd_hda_codec_hdmi snd_seq_device drm_kms_helper ohci_hcd snd_hda_in=
tel
>> snd_hda_codec snd_pcm_oss snd_hwdep drm i2c_algo_bit snd_mixer_oss
>> snd_pcm i2c_piix4 snd_timer snd soundcore snd_page_alloc ehci_hcd wm=
i
>> i2c_core usbcore evdev processor button k10temp serio_raw pcspkr sg
>> r8169 edac_core shpchp pci_hotplug edac_mce_amd mii sp5100_tco ext4
>> mbcache jbd2 crc16 sd_mod pata_acpi ahci libahci pata_atiixp libata =
scsi_mod
>> May  5 23:32:53 mail kernel: [  200.572996] Pid: 1037, comm:
>> btrfs-transacti Not tainted 2.6.38-ARCH #1
>> May  5 23:32:53 mail kernel: [  200.572997] Call Trace:
>> May  5 23:32:53 mail kernel: [  200.572999]  [<ffffffff813a932b>] ?
>> __schedule_bug+0x59/0x5d
>> May  5 23:32:53 mail kernel: [  200.573001]  [<ffffffff813af827>] ?
>> schedule+0x9f7/0xad0
>> May  5 23:32:53 mail kernel: [  200.573003]  [<ffffffff811e5827>] ?
>> generic_unplug_device+0x37/0x40
>> May  5 23:32:53 mail kernel: [  200.573006]  [<ffffffffa07ac164>] ?
>> md_raid5_unplug_device+0x64/0x110 [raid456]
>> May  5 23:32:53 mail kernel: [  200.573009]  [<ffffffffa07ac223>] ?
>> raid5_unplug_queue+0x13/0x20 [raid456]
>> May  5 23:32:53 mail kernel: [  200.573011]  [<ffffffff81012d79>] ?
>> read_tsc+0x9/0x20
>> May  5 23:32:53 mail kernel: [  200.573013]  [<ffffffff8108418c>] ?
>> ktime_get_ts+0xac/0xe0
>> May  5 23:32:53 mail kernel: [  200.573016]  [<ffffffff810e36c0>] ?
>> sync_page+0x0/0x50
>> May  5 23:32:53 mail kernel: [  200.573017]  [<ffffffff813af96e>] ?
>> io_schedule+0x6e/0xb0
>> May  5 23:32:53 mail kernel: [  200.573020]  [<ffffffff810e36fb>] ?
>> sync_page+0x3b/0x50
>> May  5 23:32:53 mail kernel: [  200.573021]  [<ffffffff813b0077>] ?
>> __wait_on_bit+0x57/0x80
>> May  5 23:32:53 mail kernel: [  200.573024]  [<ffffffff810e38c0>] ?
>> wait_on_page_bit+0x70/0x80
>> May  5 23:32:53 mail kernel: [  200.573026]  [<ffffffff8107a030>] ?
>> wake_bit_function+0x0/0x40
>> May  5 23:32:53 mail kernel: [  200.573032]  [<ffffffffa08348d2>] ?
>> read_extent_buffer_pages+0x412/0x480 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573038]  [<ffffffffa0809e00>] ?
>> btree_get_extent+0x0/0x1b0 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573044]  [<ffffffffa080ac7e>] ?
>> btree_read_extent_buffer_pages.isra.60+0x5e/0xb0 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573050]  [<ffffffffa080c0bc>] ?
>> read_tree_block+0x3c/0x60 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573054]  [<ffffffffa07f272b>] ?
>> read_block_for_search.isra.34+0x1fb/0x410 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573060]  [<ffffffffa08417d1>] ?
>> btrfs_tree_unlock+0x51/0x60 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573065]  [<ffffffffa07f5ca0>] ?
>> btrfs_search_slot+0x430/0xa30 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573070]  [<ffffffffa07fb3a6>] ?
>> lookup_inline_extent_backref+0x96/0x460 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573072]  [<ffffffff8112b8d3>] ?
>> kmem_cache_alloc+0x133/0x150
>> May  5 23:32:53 mail kernel: [  200.573077]  [<ffffffffa07fd452>] ?
>> __btrfs_free_extent+0xc2/0x6d0 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573083]  [<ffffffffa0800f59>] ?
>> run_clustered_refs+0x389/0x830 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573088]  [<ffffffffa084d900>] ?
>> btrfs_find_ref_cluster+0x10/0x190 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573094]  [<ffffffffa08014c0>] ?
>> btrfs_run_delayed_refs+0xc0/0x210 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573096]  [<ffffffff813b0cf9>] ?
>> mutex_unlock+0x9/0x10
>> May  5 23:32:53 mail kernel: [  200.573102]  [<ffffffffa0810db8>] ?
>> btrfs_commit_transaction+0x78/0x750 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573104]  [<ffffffff81079ff0>] ?
>> autoremove_wake_function+0x0/0x40
>> May  5 23:32:53 mail kernel: [  200.573110]  [<ffffffffa080a9bd>] ?
>> transaction_kthread+0x26d/0x290 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573116]  [<ffffffffa080a750>] ?
>> transaction_kthread+0x0/0x290 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573118]  [<ffffffff81079717>] ?
>> kthread+0x87/0x90
>> May  5 23:32:53 mail kernel: [  200.573120]  [<ffffffff8100bc24>] ?
>> kernel_thread_helper+0x4/0x10
>> May  5 23:32:53 mail kernel: [  200.573122]  [<ffffffff81079690>] ?
>> kthread+0x0/0x90
>> May  5 23:32:53 mail kernel: [  200.573124]  [<ffffffff8100bc20>] ?
>> kernel_thread_helper+0x0/0x10
>> May  5 23:32:53 mail kernel: [  200.573138] Modules linked in: ipv6
>> btrfs zlib_deflate crc32c libcrc32c ext2 raid456 async_raid6_recov
>> async_pq raid6_pq async_xor xor async_memcpy async_tx md_mod usb_sto=
rage
>> uas snd_seq_dummy snd_seq_oss radeon snd_seq_midi_event ttm snd_seq
>> snd_hda_codec_hdmi snd_seq_device drm_kms_helper ohci_hcd snd_hda_in=
tel
>> snd_hda_codec snd_pcm_oss snd_hwdep drm i2c_algo_bit snd_mixer_oss
>> snd_pcm i2c_piix4 snd_timer snd soundcore snd_page_alloc ehci_hcd wm=
i
>> i2c_core usbcore evdev processor button k10temp serio_raw pcspkr sg
>> r8169 edac_core shpchp pci_hotplug edac_mce_amd mii sp5100_tco ext4
>> mbcache jbd2 crc16 sd_mod pata_acpi ahci libahci pata_atiixp libata =
scsi_mod
>> May  5 23:32:53 mail kernel: [  200.573162] Pid: 1037, comm:
>> btrfs-transacti Not tainted 2.6.38-ARCH #1
>> May  5 23:32:53 mail kernel: [  200.573163] Call Trace:
>> May  5 23:32:53 mail kernel: [  200.573165]  [<ffffffff813a932b>] ?
>> __schedule_bug+0x59/0x5d
>> May  5 23:32:53 mail kernel: [  200.573167]  [<ffffffff813af827>] ?
>> schedule+0x9f7/0xad0
>> May  5 23:32:53 mail kernel: [  200.573169]  [<ffffffff811e5827>] ?
>> generic_unplug_device+0x37/0x40
>> May  5 23:32:53 mail kernel: [  200.573172]  [<ffffffffa07ac164>] ?
>> md_raid5_unplug_device+0x64/0x110 [raid456]
>> May  5 23:32:53 mail kernel: [  200.573175]  [<ffffffffa07ac223>] ?
>> raid5_unplug_queue+0x13/0x20 [raid456]
>> May  5 23:32:53 mail kernel: [  200.573177]  [<ffffffff81012d79>] ?
>> read_tsc+0x9/0x20
>> May  5 23:32:53 mail kernel: [  200.573179]  [<ffffffff8108418c>] ?
>> ktime_get_ts+0xac/0xe0
>> May  5 23:32:53 mail kernel: [  200.573182]  [<ffffffff810e36c0>] ?
>> sync_page+0x0/0x50
>> May  5 23:32:53 mail kernel: [  200.573183]  [<ffffffff813af96e>] ?
>> io_schedule+0x6e/0xb0
>> May  5 23:32:53 mail kernel: [  200.573186]  [<ffffffff810e36fb>] ?
>> sync_page+0x3b/0x50
>> May  5 23:32:53 mail kernel: [  200.573187]  [<ffffffff813b0077>] ?
>> __wait_on_bit+0x57/0x80
>> May  5 23:32:53 mail kernel: [  200.573190]  [<ffffffff810e38c0>] ?
>> wait_on_page_bit+0x70/0x80
>> May  5 23:32:53 mail kernel: [  200.573192]  [<ffffffff8107a030>] ?
>> wake_bit_function+0x0/0x40
>> May  5 23:32:53 mail kernel: [  200.573198]  [<ffffffffa08348d2>] ?
>> read_extent_buffer_pages+0x412/0x480 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573204]  [<ffffffffa0809e00>] ?
>> btree_get_extent+0x0/0x1b0 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573209]  [<ffffffffa080ac7e>] ?
>> btree_read_extent_buffer_pages.isra.60+0x5e/0xb0 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573215]  [<ffffffffa080c0bc>] ?
>> read_tree_block+0x3c/0x60 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573220]  [<ffffffffa07f272b>] ?
>> read_block_for_search.isra.34+0x1fb/0x410 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573226]  [<ffffffffa08417d1>] ?
>> btrfs_tree_unlock+0x51/0x60 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573231]  [<ffffffffa07f5ca0>] ?
>> btrfs_search_slot+0x430/0xa30 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573236]  [<ffffffffa07fb3a6>] ?
>> lookup_inline_extent_backref+0x96/0x460 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573238]  [<ffffffff8112b8d3>] ?
>> kmem_cache_alloc+0x133/0x150
>> May  5 23:32:53 mail kernel: [  200.573243]  [<ffffffffa07fd452>] ?
>> __btrfs_free_extent+0xc2/0x6d0 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573248]  [<ffffffffa0800f59>] ?
>> run_clustered_refs+0x389/0x830 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573254]  [<ffffffffa084d900>] ?
>> btrfs_find_ref_cluster+0x10/0x190 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573259]  [<ffffffffa08014c0>] ?
>> btrfs_run_delayed_refs+0xc0/0x210 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573261]  [<ffffffff813b0cf9>] ?
>> mutex_unlock+0x9/0x10
>> May  5 23:32:53 mail kernel: [  200.573267]  [<ffffffffa0810db8>] ?
>> btrfs_commit_transaction+0x78/0x750 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573270]  [<ffffffff81079ff0>] ?
>> autoremove_wake_function+0x0/0x40
>> May  5 23:32:53 mail kernel: [  200.573275]  [<ffffffffa080a9bd>] ?
>> transaction_kthread+0x26d/0x290 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573281]  [<ffffffffa080a750>] ?
>> transaction_kthread+0x0/0x290 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.573283]  [<ffffffff81079717>] ?
>> kthread+0x87/0x90
>> May  5 23:32:53 mail kernel: [  200.573285]  [<ffffffff8100bc24>] ?
>> kernel_thread_helper+0x4/0x10
>> May  5 23:32:53 mail kernel: [  200.573287]  [<ffffffff81079690>] ?
>> kthread+0x0/0x90
>> May  5 23:32:53 mail kernel: [  200.573289]  [<ffffffff8100bc20>] ?
>> kernel_thread_helper+0x0/0x10
>> May  5 23:32:53 mail kernel: [  200.580169] PGD 68be4067 PUD 68b4206=
7 PMD 0
>> May  5 23:32:53 mail kernel: [  200.580250] CPU 2
>> May  5 23:32:53 mail kernel: [  200.580260] Modules linked in: ipv6
>> btrfs zlib_deflate crc32c libcrc32c ext2 raid456 async_raid6_recov
>> async_pq raid6_pq async_xor xor async_memcpy async_tx md_mod usb_sto=
rage
>> uas snd_seq_dummy snd_seq_oss radeon snd_seq_midi_event ttm snd_seq
>> snd_hda_codec_hdmi snd_seq_device drm_kms_helper ohci_hcd snd_hda_in=
tel
>> snd_hda_codec snd_pcm_oss snd_hwdep drm i2c_algo_bit snd_mixer_oss
>> snd_pcm i2c_piix4 snd_timer snd soundcore snd_page_alloc ehci_hcd wm=
i
>> i2c_core usbcore evdev processor button k10temp serio_raw pcspkr sg
>> r8169 edac_core shpchp pci_hotplug edac_mce_amd mii sp5100_tco ext4
>> mbcache jbd2 crc16 sd_mod pata_acpi ahci libahci pata_atiixp libata =
scsi_mod
>> May  5 23:32:53 mail kernel: [  200.580642]
>> May  5 23:32:53 mail kernel: [  200.580652] Pid: 1037, comm:
>> btrfs-transacti Not tainted 2.6.38-ARCH #1 Gigabyte Technology Co., =
Ltd.
>> GA-MA785G-UD3H/GA-MA785G-UD3H
>> May  5 23:32:53 mail kernel: [  200.580713] RIP:
>> 0010:[<ffffffffa0805192>]  [<ffffffffa0805192>]
>> btrfs_print_leaf+0x32/0x880 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.580760] RSP: 0018:ffff88006dc97b=
00
>> EFLAGS: 00010286
>> May  5 23:32:53 mail kernel: [  200.580785] RAX: 00000000fffffffb RB=
X:
>> 0000000000000000 RCX: ffff88006dc97fd8
>> May  5 23:32:53 mail kernel: [  200.580817] RDX: ffff88006dc96000 RS=
I:
>> 0000000000000000 RDI: ffff880071cc6800
>> May  5 23:32:53 mail kernel: [  200.580849] RBP: ffff88006dc97b90 R0=
8:
>> 0000000000000000 R09: 0000000000000000
>> May  5 23:32:53 mail kernel: [  200.580881] R10: 0000000000000001 R1=
1:
>> 00000000fffffffb R12: 0000000000000007
>> May  5 23:32:53 mail kernel: [  200.580913] R13: 0000028b982f4000 R1=
4:
>> 00000000fffffffb R15: 0000000000001000
>> May  5 23:32:53 mail kernel: [  200.580946] FS:  00007f618e3d3720(00=
00)
>> GS:ffff880077b00000(0000) knlGS:0000000000000000
>> May  5 23:32:53 mail kernel: [  200.580982] CS:  0010 DS: 0000 ES: 0=
000
>> CR0: 000000008005003b
>> May  5 23:32:53 mail kernel: [  200.581008] CR2: 0000000000000030 CR=
3:
>> 0000000068b62000 CR4: 00000000000006e0
>> May  5 23:32:53 mail kernel: [  200.581040] DR0: 0000000000000000 DR=
1:
>> 0000000000000000 DR2: 0000000000000000
>> May  5 23:32:53 mail kernel: [  200.581073] DR3: 0000000000000000 DR=
6:
>> 00000000ffff0ff0 DR7: 0000000000000400
>> May  5 23:32:53 mail kernel: [  200.581105] Process btrfs-transacti
>> (pid: 1037, threadinfo ffff88006dc96000, task ffff880071e51bc0)
>> May  5 23:32:53 mail kernel: [  200.581155]  0000000000002000
>> 0000000000001000 ffff88006dc97c38 0000028b982f4000
>> May  5 23:32:53 mail kernel: [  200.581196]  0000000000000000
>> ffffffff8112b8d3 ffff880071cc6800 0000000000000090
>> May  5 23:32:53 mail kernel: [  200.581236]  0000000000000090
>> 0000805070ac4120 a80000028b982f40 0000000000001000
>> May  5 23:32:53 mail kernel: [  200.581292]  [<ffffffff8112b8d3>] ?
>> kmem_cache_alloc+0x133/0x150
>> May  5 23:32:53 mail kernel: [  200.581324]  [<ffffffffa07fd9b7>]
>> __btrfs_free_extent+0x627/0x6d0 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.581359]  [<ffffffffa0800f59>]
>> run_clustered_refs+0x389/0x830 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.581395]  [<ffffffffa084d900>] ?
>> btrfs_find_ref_cluster+0x10/0x190 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.581431]  [<ffffffffa08014c0>]
>> btrfs_run_delayed_refs+0xc0/0x210 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.581464]  [<ffffffff813b0cf9>] ?
>> mutex_unlock+0x9/0x10
>> May  5 23:32:53 mail kernel: [  200.581493]  [<ffffffffa0810db8>]
>> btrfs_commit_transaction+0x78/0x750 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.581528]  [<ffffffff81079ff0>] ?
>> autoremove_wake_function+0x0/0x40
>> May  5 23:32:53 mail kernel: [  200.581562]  [<ffffffffa080a9bd>]
>> transaction_kthread+0x26d/0x290 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.581597]  [<ffffffffa080a750>] ?
>> transaction_kthread+0x0/0x290 [btrfs]
>> May  5 23:32:53 mail kernel: [  200.581628]  [<ffffffff81079717>]
>> kthread+0x87/0x90
>> May  5 23:32:53 mail kernel: [  200.581652]  [<ffffffff8100bc24>]
>> kernel_thread_helper+0x4/0x10
>> May  5 23:32:53 mail kernel: [  200.581681]  [<ffffffff81079690>] ?
>> kthread+0x0/0x90
>> May  5 23:32:53 mail kernel: [  200.581704]  [<ffffffff8100bc20>] ?
>> kernel_thread_helper+0x0/0x10
>> May  5 23:32:53 mail kernel: [  200.583376]  RSP<ffff88006dc97b00>
>> May  5 23:32:53 mail kernel: [  200.587924] ---[ end trace
>> fed5a0f4104a02ee ]---
>> May  5 23:32:56 mail kernel: [  203.373416] verify_parent_transid: 4=
1030
>> callbacks suppressed
>> May  5 23:32:56 mail kernel: [  203.374625] parent transid verify fa=
iled
>> on 3062073683968 wanted 5181 found 5188
>> May  5 23:32:56 mail kernel: [  203.376004] parent transid verify fa=
iled
>> on 3062073683968 wanted 5181 found 5188
>>
>> On 5/5/2011 6:06 =CE=BC=CE=BC, Chris Mason wrote:
>>> Excerpts from Konstantinos Skarlatos's message of 2011-05-05 10:27:=
30 -0400:
>>>> attached you can find the whole dmesg log. I can trigger the error=
 again
>>>> if more logs are needed
>>>
>>> Yes, I'll send you a patch to get rid of the printk for the transid
>>> failed message.  That way we can get a clean view of the other erro=
rs.
>>>
>>> Will you be able to compile/test it?
>>>
>>> -chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
