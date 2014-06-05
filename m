Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36269 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaFENQr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 09:16:47 -0400
Received: by mail-wg0-f47.google.com with SMTP id k14so159349wgh.18
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 06:16:46 -0700 (PDT)
Message-ID: <53906DB9.6020905@gmail.com>
Date: Thu, 05 Jun 2014 16:16:41 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/ctree.h:2456
References: <538FA4E2.4050108@gmail.com> <53900E00.2040105@gmail.com> <20140605070554.GA10621@localhost.localdomain>
In-Reply-To: <20140605070554.GA10621@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/6/2014 10:05 πμ, Liu Bo wrote:
> Hi, Konstantinos
>
> On Thu, Jun 05, 2014 at 09:28:16AM +0300, Konstantinos Skarlatos wrote:
>> On 5/6/2014 1:59 πμ, Konstantinos Skarlatos wrote:
>>> Hi, I get this after doing a few runs of rsync on my btrfs filesystem.
>>> kernel: 3.15.0-rc8
>>> filesystem has 6x2tb disks, data is raid 0, fs was created with
>>> skinny metadata, mount options are noatime, compress-force=zlib.
>>> No quota or defrag or any of the new features is being used.
>>> attached full dmesg capture via netconsole.
>> adding some more info
> Can you reproduce it?  Or everything becomes good after a hard reboot?
>
> Looks that this is an 'impossible' case from code analysis.
>
> -liubo
I recompiled my kernel with CONFIG_BTRFS_DEBUG=y. after a few minutes of 
scrub and rsync, i got this


[  264.271695] BTRFS info (device sda): force zlib compression
[  264.276668] BTRFS info (device sda): disk space caching is enabled
[  264.282950] BTRFS: has skinny extents
[  363.412708] BTRFS: checking UUID tree
[ 1115.402092] BTRFS: checksum/header error at logical 4003307880448 on 
dev /dev/sda, sector 66783040: metadata node (level -1) in tree 
18446744073709551615
[ 1115.406251] ------------[ cut here ]------------
[ 1115.408251] kernel BUG at fs/btrfs/ctree.h:2456!
[ 1115.410257] invalid opcode: 0000 [#1] PREEMPT SMP
[ 1115.412291] Modules linked in: netconsole kvm_amd radeon kvm ttm 
drm_kms_helper snd_hda_codec_hdmi serio_raw drm k10temp edac_core evdev 
mac_hid microcode hwmon edac_mce_amd r8169 mii i2c_algo_bit pcspkr 
snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm 
snd_timer snd soundcore wmi shpchp sp5100_tco i2c_piix4 i2c_core button 
acpi_cpufreq processor ext4 crc16 mbcache jbd2 crc32c_generic btrfs xor 
raid6_pq sd_mod crc_t10dif crct10dif_common ata_generic pata_acpi atkbd 
libps2 ahci pata_jmicron libahci libata ohci_pci ohci_hcd ehci_pci 
ehci_hcd scsi_mod xhci_hcd usbcore i8042 serio usb_common
[ 1115.423444] CPU: 2 PID: 101 Comm: kworker/u16:6 Not tainted 
3.15.0-rc8-g54539cd #1
[ 1115.425705] Hardware name: Gigabyte Technology Co., Ltd. 
GA-890GPA-UD3H/GA-890GPA-UD3H, BIOS FD 07/23/2010
[ 1115.428023] Workqueue: btrfs-btrfs-scrub normal_work_helper [btrfs]
[ 1115.430296] task: ffff880203451e90 ti: ffff880203130000 task.ti: 
ffff880203130000
[ 1115.432548] RIP: 0010:[<ffffffffa04437ac>] [<ffffffffa04437ac>] 
tree_backref_for_extent+0x1cc/0x1d0 [btrfs]
[ 1115.435433] RSP: 0018:ffff880203133b40  EFLAGS: 00010283
[ 1115.438253] RAX: 0000000000000019 RBX: 0000000000002c05 RCX: 
ffff880203133af0
[ 1115.441083] RDX: ffff880000000000 RSI: 0000000000002c0e RDI: 
ffff88017e90efc0
[ 1115.443858] RBP: ffff880203133b88 R08: 0000000000004000 R09: 
ffff880203133b00
[ 1115.446573] R10: 0000000000000000 R11: 0000000000000002 R12: 
ffff88017e90efc0
[ 1115.449230] R13: 0000000000002be4 R14: ffff880203133bc0 R15: 
0000000000002c0e
[ 1115.451835] FS:  00007f9a2c9f1700(0000) GS:ffff88020fc80000(0000) 
knlGS:0000000000000000
[ 1115.454422] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1115.456960] CR2: 00007f05da035000 CR3: 00000001ddbc0000 CR4: 
00000000000007e0
[ 1115.459467] Stack:
[ 1115.461894]  ffff880203133bbf ffff880203133bd0 0000000000002bfc 
0000000000002c0e
[ 1115.464345]  00000000fffffffe 0000000000000021 ffffffffa0460834 
ffff88017e90efc0
[ 1115.466760]  ffff880202cbc000 ffff880203133c60 ffffffffa043ab5c 
ffffffffffffffff
[ 1115.469138] Call Trace:
[ 1115.471447]  [<ffffffffa043ab5c>] scrub_print_warning+0x28c/0x2d0 [btrfs]
[ 1115.473737]  [<ffffffffa03de746>] ? btrfs_csum_data+0x16/0x20 [btrfs]
[ 1115.475975]  [<ffffffffa043de94>] 
scrub_handle_errored_block+0x974/0xae0 [btrfs]
[ 1115.478176]  [<ffffffffa043e228>] scrub_bio_end_io_worker+0x228/0x810 
[btrfs]
[ 1115.480327]  [<ffffffffa0414b77>] normal_work_helper+0x77/0x350 [btrfs]
[ 1115.482438]  [<ffffffff810821c8>] process_one_work+0x168/0x450
[ 1115.484518]  [<ffffffff81082c02>] worker_thread+0x132/0x3e0
[ 1115.486601]  [<ffffffff81082ad0>] ? manage_workers.isra.23+0x2d0/0x2d0
[ 1115.488693]  [<ffffffff8108908b>] kthread+0xdb/0x100
[ 1115.490770]  [<ffffffff81088fb0>] ? kthread_create_on_node+0x180/0x180
[ 1115.492881]  [<ffffffff814f573c>] ret_from_fork+0x7c/0xb0
[ 1115.494997]  [<ffffffff81088fb0>] ? kthread_create_on_node+0x180/0x180
[ 1115.497129] Code: ff 48 83 c4 20 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 
1f 80 00 00 00 00 48 83 c4 20 b8 fe ff ff ff 5b 41 5c 41 5d 41 5e 41 5f 
5d c3 <0f> 0b 66 90 66 66 66 66 90 55 48 89 e5 41 57 41 56 41 55 41 54
[ 1115.501825] RIP  [<ffffffffa04437ac>] 
tree_backref_for_extent+0x1cc/0x1d0 [btrfs]
[ 1115.504103]  RSP <ffff880203133b40>
[ 1115.514902] ---[ end trace 54741a57d59e0263 ]---
[ 1115.516654] BUG: unable to handle kernel paging request at 
ffffffffffffffd8
[ 1115.518247] IP: [<ffffffff810896f0>] kthread_data+0x10/0x20
[ 1115.519811] PGD 1814067 PUD 1816067 PMD 0
[ 1115.521277] Oops: 0000 [#2] PREEMPT SMP
[ 1115.522735] Modules linked in: netconsole kvm_amd radeon kvm ttm 
drm_kms_helper snd_hda_codec_hdmi serio_raw drm k10temp edac_core evdev 
mac_hid microcode hwmon edac_mce_amd r8169 mii i2c_algo_bit pcspkr 
snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm 
snd_timer snd soundcore wmi shpchp sp5100_tco i2c_piix4 i2c_core



>> $ btrfs fi df /storage/btrfs
>> Data, single: total=8.89TiB, used=8.43TiB
>> System, RAID1: total=32.00MiB, used=992.00KiB
>> Metadata, RAID1: total=69.00GiB, used=66.75GiB
>> unknown, single: total=512.00MiB, used=112.00KiB
>>
>> $ btrfs fi show
>> Label: none  uuid: bde3c349-9e08-45bb-8517-b9a6dda81e88
>>          Total devices 6 FS bytes used 8.50TiB
>>          devid    1 size 3.64TiB used 3.02TiB path /dev/sdf
>>          devid    2 size 1.82TiB used 1.20TiB path /dev/sda
>>          devid    3 size 1.82TiB used 1.20TiB path /dev/sdb
>>          devid    4 size 1.82TiB used 1.20TiB path /dev/sdc
>>          devid    5 size 1.82TiB used 1.20TiB path /dev/sdd
>>          devid    6 size 1.82TiB used 1.20TiB path /dev/sdh
>>
>> Btrfs v3.14.2-dirty
>>
>> btrfs su li /storage/btrfs -q | grep "parent_uuid -" |wc -l
>> 22
>>
>> btrfs su li /storage/btrfs -q | grep -v "parent_uuid -" |wc -l
>> 5855
>>
>> So the filesystem has 22 subvolumes and 5855 snapshots.
>> No vm images or databases are stored here, everything comes and goes
>> with rsync, as this is a backup server.
>>
>>> [  855.493495] BTRFS info (device sdc): force zlib compression
>>> [  855.498427] BTRFS info (device sdc): disk space caching is enabled
>>> [  855.503348] BTRFS: has skinny extents
>>> [27199.947244] ------------[ cut here ]------------
>>> [27199.952216] kernel BUG at fs/btrfs/ctree.h:2456!
>>> [27199.957188] invalid opcode: 0000 [#1] PREEMPT SMP
>>> [27199.962184] Modules linked in: netconsole radeon kvm_amd
>>> snd_hda_codec_hdmi ttm drm_kms_helper drm kvm r8169 microcode
>>> evdev snd_hda_intel snd_hda_controller mac_hid edac_core
>>> snd_hda_codec snd_hwdep edac_mce_amd snd_pcm pcspkr snd_timer snd
>>> serio_raw i2c_algo_bit k10temp hwmon sp5100_tco i2c_piix4 i2c_core
>>> soundcore mii wmi shpchp button acpi_cpufreq processor ext4 crc16
>>> mbcache jbd2 crc32c_generic btrfs xor raid6_pq sd_mod crc_t10dif
>>> crct10dif_common ata_generic pata_acpi atkbd libps2 pata_jmicron
>>> ahci libahci ohci_pci libata ohci_hcd ehci_pci xhci_hcd ehci_hcd
>>> scsi_mod usbcore usb_common i8042 serio
>>> [27199.990017] CPU: 1 PID: 7953 Comm: rsync Not tainted
>>> 3.15.0-rc8-gfad01e8 #1
>>> [27199.995748] Hardware name: Gigabyte Technology Co., Ltd.
>>> GA-890GPA-UD3H/GA-890GPA-UD3H, BIOS FD 07/23/2010
>>> [27200.001584] task: ffff880202928000 ti: ffff8800129e0000
>>> task.ti: ffff8800129e0000
>>> [27200.007439] RIP: 0010:[<ffffffffa0594017>] [<ffffffffa0594017>]
>>> lookup_inline_extent_backref+0x407/0x5d0 [btrfs]
>>> [27200.013445] RSP: 0018:ffff8800129e3a90  EFLAGS: 00010283
>>> [27200.019397] RAX: 0000000000000038 RBX: ffff88002ef9af00 RCX:
>>> ffff8800129e3a40
>>> [27200.025312] RDX: ffff880000000000 RSI: 00000000000036b7 RDI:
>>> ffff88002ef9af00
>>> [27200.031119] RBP: ffff8800129e3b28 R08: 0000000000004000 R09:
>>> ffff8800129e3a50
>>> [27200.036801] R10: 0000000000000000 R11: 0000000000000003 R12:
>>> 00000000000000b8
>>> [27200.042377] R13: 0000000000000038 R14: 00000000000036b7 R15:
>>> 000000000000399c
>>> [27200.047899] FS:  00007f543bbec700(0000)
>>> GS:ffff88020fc40000(0000) knlGS:0000000000000000
>>> [27200.053379] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> [27200.058751] CR2: 00000000015b6fd8 CR3: 000000018a0da000 CR4:
>>> 00000000000007e0
>>> [27200.064060] Stack:
>>> [27200.069215]  00000c14cecab000 ffff88019abf1480 0000000000000327
>>> ffff8800129e3b68
>>> [27200.074437]  000000000000399c 00000000000000b8 ffff88002ef9af00
>>> 0000000d000000b8
>>> [27200.079585]  ffff8800ce8fc800 b000ffffa0594e27 00a800000c14ceca
>>> 0000000000000020
>>> [27200.084647] Call Trace:
>>> [27200.089554]  [<ffffffffa0595265>]
>>> insert_inline_extent_backref+0x55/0xe0 [btrfs]
>>> [27200.094467]  [<ffffffffa0595386>]
>>> __btrfs_inc_extent_ref+0x96/0x200 [btrfs]
>>> [27200.099290]  [<ffffffffa059c0f9>]
>>> __btrfs_run_delayed_refs+0x819/0x1240 [btrfs]
>>> [27200.104035]  [<ffffffffa058979d>] ?
>>> btrfs_put_tree_mod_seq+0x10d/0x150 [btrfs]
>>> [27200.108676]  [<ffffffffa05a091b>]
>>> btrfs_run_delayed_refs.part.52+0x7b/0x260 [btrfs]
>>> [27200.113241]  [<ffffffffa05a0b17>]
>>> btrfs_run_delayed_refs+0x17/0x20 [btrfs]
>>> [27200.117675]  [<ffffffffa05b1be3>]
>>> __btrfs_end_transaction+0x243/0x380 [btrfs]
>>> [27200.122031]  [<ffffffffa05b1d30>]
>>> btrfs_end_transaction+0x10/0x20 [btrfs]
>>> [27200.126275]  [<ffffffffa05bb31e>] btrfs_truncate+0x23e/0x330 [btrfs]
>>> [27200.130452]  [<ffffffffa05bbe48>] btrfs_setattr+0x228/0x2e0 [btrfs]
>>> [27200.134549]  [<ffffffff811c6781>] notify_change+0x221/0x380
>>> [27200.138641]  [<ffffffff811a9006>] do_truncate+0x66/0x90
>>> [27200.142715]  [<ffffffff811ad159>] ? __sb_start_write+0x49/0xf0
>>> [27200.146795]  [<ffffffff811a937b>]
>>> do_sys_ftruncate.constprop.10+0x10b/0x160
>>> [27200.150927]  [<ffffffff811a940e>] SyS_ftruncate+0xe/0x10
>>> [27200.155104]  [<ffffffff814f56a9>] system_call_fastpath+0x16/0x1b
>>> [27200.159297] Code: 48 39 45 10 74 74 0f 87 28 01 00 00 41 81 fd
>>> b6 00 00 00 74 1f 41 81 fd b0 00 00 00 74 16 41 81 fd b8 00 00 00
>>> 0f 84 69 01 00 00 <0f> 0b 0f 1f 80 00 00 00 00 b8 09 00 00 00 49
>>> 01 c6 4d 39 f7 0f
>>> [27200.168637] RIP  [<ffffffffa0594017>]
>>> lookup_inline_extent_backref+0x407/0x5d0 [btrfs]
>>> [27200.173160]  RSP <ffff8800129e3a90>
>>> [27200.194497] ---[ end trace e900836ae0ecd5f8 ]---
>>> [27200.198957] note: rsync[7953] exited with preempt_count 1
>>> [27228.287568] BUG: soft lockup - CPU#0 stuck for 23s!
>>> [kworker/u16:11:7840]
>>> [27228.288734] Modules linked in: netconsole radeon kvm_amd
>>> snd_hda_codec_hdmi ttm drm_kms_helper drm kvm r8169 microcode
>>> evdev snd_hda_intel snd_hda_controller mac_hid edac_core
>>> snd_hda_codec snd_hwdep edac_mce_amd snd_pcm pcspkr snd_timer snd
>>> serio_raw i2c_algo_bit k10temp hwmon sp5100_tco i2c_piix4 i2c_core
>>> soundcore mii wmi shpchp button acpi_cpufreq processor ext4 crc16
>>> mbcache jbd2 crc32c_generic btrfs xor raid6_pq sd_mod crc_t10dif
>>> crct10dif_common ata_generic pata_acpi atkbd libps2 pata_jmicron
>>> ahci libahci ohci_pci libata ohci_hcd ehci_pci xhci_hcd ehci_hcd
>>> scsi_mod usbcore usb_common i8042 serio
>>> [27228.294863] CPU: 0 PID: 7840 Comm: kworker/u16:11 Tainted: G D
>>> 3.15.0-rc8-gfad01e8 #1
>>> [27228.296032] Hardware name: Gigabyte Technology Co., Ltd.
>>> GA-890GPA-UD3H/GA-890GPA-UD3H, BIOS FD 07/23/2010
>>> [27228.297221] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
>>> [27228.298385] task: ffff880204ec9e90 ti: ffff8800335b8000
>>> task.ti: ffff8800335b8000
>>> [27228.299540] RIP: 0010:[<ffffffff8128f993>] [<ffffffff8128f993>]
>>> __write_lock_failed+0x13/0x20
>>> [27228.300703] RSP: 0018:ffff8800335bb918  EFLAGS: 00000287
>>> [27228.301842] RAX: 0000000000000000 RBX: ffff8800335bb9b0 RCX:
>>> 0000000000000001
>>> [27228.302984] RDX: 0000000000000000 RSI: ffff88008aa46280 RDI:
>>> ffff88008aa462f0
>>> [27228.304125] RBP: ffff8800335bb918 R08: 0000000000000001 R09:
>>> ffff880180d30500
>>> [27228.304256] BUG: soft lockup - CPU#1 stuck for 23s! [mkdir:7979]
>>> [27228.304277] Modules linked in: netconsole radeon kvm_amd
>>> snd_hda_codec_hdmi ttm drm_kms_helper drm kvm r8169 microcode
>>> evdev snd_hda_intel snd_hda_controller mac_hid edac_core
>>> snd_hda_codec snd_hwdep edac_mce_amd snd_pcm pcspkr snd_timer snd
>>> serio_raw i2c_algo_bit k10temp hwmon sp5100_tco i2c_piix4 i2c_core
>>> soundcore mii wmi shpchp button acpi_cpufreq processor ext4 crc16
>>> mbcache jbd2 crc32c_generic btrfs xor raid6_pq sd_mod crc_t10dif
>>> crct10dif_common ata_generic pata_acpi atkbd libps2 pata_jmicron
>>> ahci libahci ohci_pci libata ohci_hcd ehci_pci xhci_hcd ehci_hcd
>>> scsi_mod usbcore usb_common i8042 serio
>>> [27228.304279] CPU: 1 PID: 7979 Comm: mkdir Tainted: G      D
>>> 3.15.0-rc8-gfad01e8 #1
>>> [27228.304280] Hardware name: Gigabyte Technology Co., Ltd.
>>> GA-890GPA-UD3H/GA-890GPA-UD3H, BIOS FD 07/23/2010
>>> [27228.304281] task: ffff88020086b2f0 ti: ffff8800055e4000
>>> task.ti: ffff8800055e4000
>>> [27228.304286] RIP: 0010:[<ffffffff8128f993>] [<ffffffff8128f993>]
>>> __write_lock_failed+0x13/0x20
>>> [27228.304287] RSP: 0018:ffff8800055e7a38  EFLAGS: 00000287
>>> [27228.304287] RAX: 0000000000000000 RBX: ffff8800055e7ad0 RCX:
>>> 0000000000000001
>>> [27228.304288] RDX: 0000000000000000 RSI: ffff88002ef9af00 RDI:
>>> ffff88002ef9af70
>>> [27228.304288] RBP: ffff8800055e7a38 R08: 0000000000000001 R09:
>>> ffff880145df9a00
>>> [27228.304289] R10: ffff880000000000 R11: 0000000000000001 R12:
>>> ffffffffa05ab0f6
>>> [27228.304289] R13: ffff8800055e79c8 R14: 0000000000000001 R15:
>>> 0000000000016085
>>> [27228.304290] FS:  00007f5a38a33700(0000)
>>> GS:ffff88020fc40000(0000) knlGS:0000000000000000
>>> [27228.304291] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> [27228.304291] CR2: 0000000001c7f9b0 CR3: 000000019b669000 CR4:
>>> 00000000000007e0
>>> [27228.304292] Stack:
>>> [27228.304293]  ffff8800055e7a48 ffffffff814ecdff ffff8800055e7a68
>>> ffffffffa05e7f3e
>>> [27228.304294]  ffff880107b20990 0000000000000000 ffff8800055e7b00
>>> ffffffffa058e0f0
>>> [27228.304295]  ffffea0006209c40 ffff8800055e7aa8 ffffea0006209c40
>>> 00000008cb2206d8
>>> [27228.304295] Call Trace:
>>> [27228.304299]  [<ffffffff814ecdff>] _raw_write_lock+0x1f/0x30
>>> [27228.304316]  [<ffffffffa05e7f3e>]
>>> btrfs_try_tree_write_lock+0x2e/0x80 [btrfs]
>>> [27228.304322]  [<ffffffffa058e0f0>] btrfs_search_slot+0x480/0xa50
>>> [btrfs]
>>> [27228.304327]  [<ffffffffa0593cd5>]
>>> lookup_inline_extent_backref+0xc5/0x5d0 [btrfs]
>>> [27228.304332]  [<ffffffffa0595265>]
>>> insert_inline_extent_backref+0x55/0xe0 [btrfs]
>>> [27228.304337]  [<ffffffffa0595386>]
>>> __btrfs_inc_extent_ref+0x96/0x200 [btrfs]
>>> [27228.304344]  [<ffffffffa05f79a1>] ? find_ref_head+0x61/0x80 [btrfs]
>>> [27228.304350]  [<ffffffffa059c0f9>]
>>> __btrfs_run_delayed_refs+0x819/0x1240 [btrfs]
>>> [27228.304357]  [<ffffffffa06029c9>] ?
>>> __btrfs_release_delayed_node+0xc9/0x200 [btrfs]
>>> [27228.304361]  [<ffffffffa059202b>] ?
>>> block_rsv_add_bytes+0x4b/0x60 [btrfs]
>>> [27228.304366]  [<ffffffffa058979d>] ?
>>> btrfs_put_tree_mod_seq+0x10d/0x150 [btrfs]
>>> [27228.304372]  [<ffffffffa05a091b>]
>>> btrfs_run_delayed_refs.part.52+0x7b/0x260 [btrfs]
>>> [27228.304377]  [<ffffffffa05a0b17>]
>>> btrfs_run_delayed_refs+0x17/0x20 [btrfs]
>>> [27228.304384]  [<ffffffffa05b1be3>]
>>> __btrfs_end_transaction+0x243/0x380 [btrfs]
>>> [27228.304390]  [<ffffffffa05b1d30>]
>>> btrfs_end_transaction+0x10/0x20 [btrfs]
>>> [27228.304397]  [<ffffffffa05bf2d2>] btrfs_mkdir+0x72/0x1e0 [btrfs]
>>> [27228.304399]  [<ffffffff811b6b41>] vfs_mkdir+0xa1/0x100
>>> [27228.304401]  [<ffffffff811bb1aa>] SyS_mkdirat+0xaa/0xe0
>>> [27228.304403]  [<ffffffff811bb1f9>] SyS_mkdir+0x19/0x20
>>> [27228.304405]  [<ffffffff814f56a9>] system_call_fastpath+0x16/0x1b
>>> [27228.304415] Code: c3 b8 f2 ff ff ff 66 66 90 c3 90 90 90 90 90
>>> 90 90 90 90 90 90 90 90 90 55 48 89 e5 f0 81 07 00 00 10 00 f3 90
>>> 81 3f 00 00 10 00 <75> f6 f0 81 2f 00 00 10 00 75 e6 5d c3 55 48
>>> 89 e5 f0 ff 07 f3
>>> [27228.320945] BUG: soft lockup - CPU#2 stuck for 23s!
>>> [kworker/u16:0:7734]
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

