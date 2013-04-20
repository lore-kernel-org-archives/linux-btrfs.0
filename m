Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:54994 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab3DTNUy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 09:20:54 -0400
Received: by mail-oa0-f43.google.com with SMTP id k7so1228709oag.16
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2013 06:20:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKuK5J3eRzHmRbfgBYuo38AYAC8=BKyB5knSUeXsC=_gfFr-pA@mail.gmail.com>
References: <CAKuK5J3NgU-V5XH_vZFTLZpisZL-OQ7Kn0Riis-VghB0YfLaYg@mail.gmail.com>
 <CAKuK5J3eRzHmRbfgBYuo38AYAC8=BKyB5knSUeXsC=_gfFr-pA@mail.gmail.com>
From: Jon Nelson <jnelson@jamponi.net>
Date: Sat, 20 Apr 2013 08:20:34 -0500
Message-ID: <CAKuK5J0VUeJfyC66PWzbqwEdkKksMtVhYwd+5irsoP3Gz9V9dA@mail.gmail.com>
Subject: Re: corrupted filesystem. mounts with -o recovery,ro but not -o
 recovery or -o ro
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using 3.8.8, I tried mounting with "-o recovery" and "-o
recovery,nospace_cache" (which shouldn't be any different, if I'm
understanding the kernel sources properly) without any benefit.

Then I tried btrfs-next ( bba653d1207646b17671c6cb9a0629736811848a as
of this writing ) also without being able to mount the filesystem,
except for one big improvement -- it doesn't BUG/crash the kernel, it
just fails the mount.

As before, "-o recovery,ro" works.

These seem to be the most useful of the messages:

2013-04-20T08:10:06.263708-05:00 turnip kernel: [  638.385206] BTRFS
error (device sda3) in btrfs_run_delayed_refs:2657: errno=-2 No such
entry
2013-04-20T08:10:06.263711-05:00 turnip kernel: [  638.385211] BTRFS
warning (device sda3): Skipping commit of aborted transaction.
2013-04-20T08:10:06.263713-05:00 turnip kernel: [  638.385215] BTRFS
error (device sda3) in cleanup_transaction:1450: errno=-2 No such
entry
2013-04-20T08:10:06.263715-05:00 turnip kernel: [  638.385322] BTRFS
error (device sda3): Error removing orphan entry, stopping orphan
cleanup
2013-04-20T08:10:06.263717-05:00 turnip kernel: [  638.385334] BTRFS
critical (device sda3): could not do orphan cleanup -22
2013-04-20T08:10:06.263720-05:00 turnip kernel: [  638.385350] btrfs:
commit super ret -30

Using debug-tree, I can determine that the most probable root backup
is just one generation back, but btrfs-restore doesn't seem to want to
let me use it:
btrfs root backup slot 0
        tree root gen 246528 block 2621770289152
                extent root gen 246528 block 2621506080768
                chunk root gen 220757 block 2622035951616
                device root gen 220757 block 2621945528320
                csum root gen 246529 block 2621775081472
                fs root gen 246529 block 2621774274560
                440384839680 used 1629622038016 total 4 devices
btrfs root backup slot 1
        tree root gen 246529 block 2619191820288
                extent root gen 246530 block 2619724374016
                chunk root gen 220757 block 2622035951616
                device root gen 220757 block 2621945528320
                csum root gen 246530 block 2619804864512
                fs root gen 246530 block 2619723927552
                440382750720 used 1629622038016 total 4 devices
btrfs root backup slot 2
        tree root gen 246530 block 2621340016640
                extent root gen 246530 block 2619724374016
                chunk root gen 220757 block 2622035951616
                device root gen 220757 block 2621945528320
                csum root gen 246530 block 2619804864512
                fs root gen 246530 block 2619723927552
                440385257472 used 1629622038016 total 4 devices
btrfs root backup slot 3
        tree root gen 246527 block 2621585006592
                extent root gen 246528 block 2621506080768
                chunk root gen 220757 block 2622035951616
                device root gen 220757 block 2621945528320
                csum root gen 246527 block 2621345435648
                fs root gen 246528 block 2621586079744
                440384839680 used 1629622038016 total 4 devices

turnip:~/recovery # btrfs restore -r 2619191820288 -vvvvvv -i  /dev/sdd /tmp/foo
Error reading root
turnip:~/recovery #

Is there a way for me to use btrfs tools to tell the superblock to go
ahead and use backup root #1 in this case?


On Tue, Apr 16, 2013 at 11:44 AM, Jon Nelson <jnelson@jamponi.net> wrote:
> Tried to mount with "-o recovery" using 3.8.7.  No change. Does
> anybody have any suggestions?
>
>
> On Sat, Apr 13, 2013 at 6:21 PM, Jon Nelson <jnelson@jamponi.net> wrote:
>> I have a 4-disk btrfs filesystem in "raid1" mode.
>> I'm running openSUSE 12.3, 3.7.10, x86_64.
>> A few days ago something went wrong and the filesystem re-mounted itself RO.
>> After reboot, it didn't come up.
>> After a fair bit of work, I can get the filesystem to mount with "-o
>> recovery,ro".  However, if I use -o recovery alone or any other option
>> I eventually hit a BUG and that's that. I've tried with up to kernel
>> 3.8.6 without improvement.
>>
>> My first question is this: how I can make it so I can use the
>> filesystem without having to mount it with "-o recovery,ro" from a
>> rescue environment (I have imaged all four drives *and* made a full
>> filesystem-level backup, except for snapshots and some others).
>>
>> My second set of question is: what went wrong initially, what went
>> wrong with the recovery(s), and are there fixes in kernels after 3.8.6
>> that might be involved?
>>
>> I have *some* logs, and I might be able to share portions of them.
>> I also took a btrfs-image.
>>
>>
>> Using a very recent btrfs-progs git pull, 'btrfs repair ...' gives me:
>> ERROR: device scan failed '/dev/sdb' - Device or resource busy
>> ERROR: device scan failed '/dev/sda' - Device or resource busy
>> failed to open /dev/sr0: No medium found
>> ERROR: device scan failed '/dev/sdb' - Device or resource busy
>> ERROR: device scan failed '/dev/sda' - Device or resource busy
>> failed to open /dev/sr0: No medium found
>> checking extents
>> Backref 341888225280 parent 2621340434432 owner 0 offset 0 num_refs 0
>> not found in extent tree
>> Incorrect local backref count on 341888225280 parent 2621340434432
>> owner 0 offset 0 found 1 wanted 0 back 0x6dc8500
>> Incorrect local backref count on 341888225280 root 1 owner 496 offset
>> 0 found 0 wanted 1 back 0x2bb636c0
>> backpointer mismatch on [341888225280 262144]
>> Unable to find block group for 0
>> btrfs: extent-tree.c:284: find_search_start: Assertion `!(1)' failed.
>> enabling repair mode
>> Checking filesystem on /dev/sdd
>> UUID: 7feedf1e-9711-4900-af9c-92738ea8aace
>>
>>
>> and some of the errors are here:
>>
>> [  314.095449] ------------[ cut here ]------------
>> [  314.095526] WARNING: at
>> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.8.6/linux-3.8/fs/btrfs/extent-tree.c:5208
>> __btrfs_free_extent+0x853/0x890 [btrfs]()
>> [  314.095541] Hardware name: TA790GX XE
>> [  314.095555] Modules linked in: dm_mod af_packet
>> cpufreq_conservative cpufreq_userspace cpufreq_powersave
>> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
>> snd_hwdep snd_pcm snd_timer snd bt
>> rfs acpi_cpufreq mperf kvm_amd zlib_deflate libcrc32c kvm radeon
>> sr_mod ttm drm_kms_helper cdrom processor sg via_velocity drm
>> i2c_algo_bit shpchp pci_hotplug sp5100_tco i2c_piix4 edac_core
>> edac_mce_amd thermal
>> ata_generic thermal_sys r8169 pata_atiixp k10temp pcspkr microcode
>> crc_ccitt wmi soundcore snd_page_alloc button autofs4
>> [  314.095867] Pid: 5310, comm: btrfs-transacti Not tainted 3.8.6-2-desktop #1
>> [  314.095875] Call Trace:
>> [  314.095904]  [<ffffffff81004748>] dump_trace+0x88/0x300
>> [  314.095923]  [<ffffffff815a9128>] dump_stack+0x69/0x6f
>> [  314.095937]  [<ffffffff81044f49>] warn_slowpath_common+0x79/0xc0
>> [  314.095968]  [<ffffffffa0400db3>] __btrfs_free_extent+0x853/0x890 [btrfs]
>> [  314.096061]  [<ffffffffa0404b0f>] run_clustered_refs+0x48f/0xb20 [btrfs]
>> [  314.096147]  [<ffffffffa0408a9a>] btrfs_run_delayed_refs+0xca/0x320 [btrfs]
>> [  314.096249]  [<ffffffffa04182e0>] btrfs_commit_transaction+0x80/0xb00 [btrfs]
>> [  314.096379]  [<ffffffffa0411b4d>] transaction_kthread+0x19d/0x220 [btrfs]
>> [  314.096492]  [<ffffffff81068043>] kthread+0xb3/0xc0
>> [  314.096506]  [<ffffffff815bbf7c>] ret_from_fork+0x7c/0xb0
>> [  314.096515] ---[ end trace 64d3998241407ddc ]---
>> [  314.096520] btrfs unable to find ref byte nr 2621340344320 parent 0
>> root 2  owner 1 offset 0
>> [  314.096526] ------------[ cut here ]------------
>> [  314.096551] WARNING: at
>> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.8.6/linux-3.8/fs/btrfs/extent-tree.c:5265
>> __btrfs_free_extent+0x7ba/0x890 [btrfs]()
>> [  314.096554] Hardware name: TA790GX XE
>> [  314.096556] Modules linked in: dm_mod af_packet
>> cpufreq_conservative cpufreq_userspace cpufreq_powersave
>> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
>> snd_hwdep snd_pcm snd_timer snd btrfs acpi_cpufreq mperf kvm_amd
>> zlib_deflate libcrc32c kvm radeon sr_mod ttm drm_kms_helper cdrom
>> processor sg via_velocity drm i2c_algo_bit shpchp pci_hotplug
>> sp5100_tco i2c_piix4 edac_core edac_mce_amd thermal ata_generic
>> thermal_sys r8169 pata_atiixp k10temp pcspkr microcode crc_ccitt wmi
>> soundcore snd_page_alloc button autofs4
>> [  314.096613] Pid: 5310, comm: btrfs-transacti Tainted: G        W
>> 3.8.6-2-desktop #1
>> [  314.096615] Call Trace:
>> [  314.096627]  [<ffffffff81004748>] dump_trace+0x88/0x300
>> [  314.096636]  [<ffffffff815a9128>] dump_stack+0x69/0x6f
>> [  314.096646]  [<ffffffff81044f49>] warn_slowpath_common+0x79/0xc0
>> [  314.096673]  [<ffffffffa0400d1a>] __btrfs_free_extent+0x7ba/0x890 [btrfs]
>> [  314.096752]  [<ffffffffa0404b0f>] run_clustered_refs+0x48f/0xb20 [btrfs]
>> [  314.096832]  [<ffffffffa0408a9a>] btrfs_run_delayed_refs+0xca/0x320 [btrfs]
>> [  314.096921]  [<ffffffffa04182e0>] btrfs_commit_transaction+0x80/0xb00 [btrfs]
>> [  314.097041]  [<ffffffffa0411b4d>] transaction_kthread+0x19d/0x220 [btrfs]
>> [  314.097128]  [<ffffffff81068043>] kthread+0xb3/0xc0
>> [  314.097142]  [<ffffffff815bbf7c>] ret_from_fork+0x7c/0xb0
>> [  314.097150] ---[ end trace 64d3998241407ddd ]---
>> [  314.097156] btrfs: run_one_delayed_ref returned -2
>> [  314.097160] ------------[ cut here ]------------
>> [  314.097183] WARNING: at
>> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.8.6/linux-3.8/fs/btrfs/super.c:256
>> __btrfs_abort_transaction+0xc3/0xe0 [btrfs]()
>> [  314.097189] Hardware name: TA790GX XE
>> [  314.097192] btrfs: Transaction aborted
>> [  314.097194] Modules linked in: dm_mod af_packet
>> cpufreq_conservative cpufreq_userspace cpufreq_powersave
>> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
>> snd_hwdep snd_pcm snd_timer snd bt
>> rfs acpi_cpufreq mperf kvm_amd zlib_deflate libcrc32c kvm radeon
>> sr_mod ttm drm_kms_helper cdrom processor sg via_velocity drm
>> i2c_algo_bit shpchp pci_hotplug sp5100_tco i2c_piix4 edac_core
>> edac_mce_amd thermal
>> ata_generic thermal_sys r8169 pata_atiixp k10temp pcspkr microcode
>> crc_ccitt wmi soundcore snd_page_alloc button autofs4
>> [  314.097248] Pid: 5310, comm: btrfs-transacti Tainted: G        W
>> 3.8.6-2-desktop #1
>> [  314.097251] Call Trace:
>> [  314.097261]  [<ffffffff81004748>] dump_trace+0x88/0x300
>> [  314.097271]  [<ffffffff815a9128>] dump_stack+0x69/0x6f
>> [  314.097280]  [<ffffffff81044f49>] warn_slowpath_common+0x79/0xc0
>> [  314.097290]  [<ffffffff81045045>] warn_slowpath_fmt+0x45/0x50
>> [  314.097314]  [<ffffffffa03ef3a3>] __btrfs_abort_transaction+0xc3/0xe0 [btrfs]
>> [  314.097366]  [<ffffffffa0408c24>] btrfs_run_delayed_refs+0x254/0x320 [btrfs]
>> [  314.097482]  [<ffffffffa04182e0>] btrfs_commit_transaction+0x80/0xb00 [btrfs]
>> [  314.097598]  [<ffffffffa0411b4d>] transaction_kthread+0x19d/0x220 [btrfs]
>> [  314.097688]  [<ffffffff81068043>] kthread+0xb3/0xc0
>> [  314.097698]  [<ffffffff815bbf7c>] ret_from_fork+0x7c/0xb0
>> [  314.097706] ---[ end trace 64d3998241407dde ]---
>> [  314.097711] BTRFS error (device sdd) in btrfs_run_delayed_refs:2504: error 2
>> [  314.097718] BTRFS warning (device sdd): Skipping commit of aborted
>> transaction.
>> [  314.097723] BTRFS error (device sdd) in cleanup_transaction:1391: error 2
>> [  314.097770] BUG: unable to handle kernel paging request at ffffffff81068138
>> [  314.097929] IP: [<ffffffff815b5285>] _raw_spin_lock+0x15/0x40
>> [  314.098018] PGD 1a0f067 PUD 1a13063 PMD 10001e1
>> [  314.098168] Oops: 0003 [#1] PREEMPT SMP
>> [  314.098315] Modules linked in: dm_mod af_packet
>> cpufreq_conservative cpufreq_userspace cpufreq_powersave
>> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
>> snd_hwdep snd_pcm snd_timer snd btrfs acpi_cpufreq mperf kvm_amd
>> zlib_deflate libcrc32c kvm radeon sr_mod ttm drm_kms_helper cdrom
>> processor sg via_velocity drm i2c_algo_bit shpchp pci_hotplug
>> sp5100_tco i2c_piix4 edac_core edac_mce_amd thermal ata_generic
>> thermal_sys r8169 pata_atiixp k10temp pcspkr microcode crc_ccitt wmi
>> soundcore snd_page_alloc button autofs4
>> [  314.099548] CPU 1 <4>[  314.099553] Pid: 5310, comm:
>> btrfs-transacti Tainted: G        W    3.8.6-2-desktop #1 BIOSTAR
>> Group TA790GX XE/TA790GX XE
>> [  314.099556] RIP: 0010:[<ffffffff815b5285>]  [<ffffffff815b5285>]
>> _raw_spin_lock+0x15/0x40
>> [  314.099561] RSP: 0018:ffff8800977bfd80  EFLAGS: 00010202
>> [  314.099564] RAX: 0000000000010000 RBX: ffffffff81068120 RCX: 0000000000000206
>> [  314.099566] RDX: 0000000000000000 RSI: ffffffff81068120 RDI: ffffffff81068138
>> [  314.099570] RBP: 0000000000000206 R08: 0000000000000000 R09: ffff880098bedbc1
>> [  314.099574] R10: 0000000000000000 R11: 00000000000003e6 R12: 00b93025048b4865
>> [  314.099576] R13: ffffffff81067f90 R14: 0000000000000000 R15: ffffffff81068138
>> [  314.099580] FS:  00007fd79942c700(0000) GS:ffff88009dc40000(0000)
>> knlGS:0000000000000000
>> [  314.099582] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [  314.099584] CR2: ffffffff81068138 CR3: 000000007f0a3000 CR4: 00000000000007e0
>> [  314.099586] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [  314.099588] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [  314.099591] Process btrfs-transacti (pid: 5310, threadinfo
>> ffff8800977be000, task ffff880095334280)
>> [  314.099591] Stack:
>> [  314.099593]  ffffffffa03ff3ee ffff880096d9b700 ffff8800977bfd98
>> ffff8800977bfd98
>> [  314.099598]  00000000fffffffe ffff8800964d2e70 000000005169bbaa
>> 0000000000007530
>> [  314.099603]  ffffffffa04144bb 00000000fffffffe ffff8800954e6000
>> ffff8800964d1ed8
>> [  314.099608] Call Trace:
>> [  314.099636]  [<ffffffffa03ff3ee>] block_rsv_release_bytes+0x3e/0x1e0 [btrfs]
>> [  314.099711]  [<ffffffffa04144bb>]
>> btrfs_cleanup_one_transaction+0x2b/0xf0 [btrfs]
>> [  314.099822]  [<ffffffffa04183ac>]
>> btrfs_commit_transaction+0x14c/0xb00 [btrfs]
>> [  314.099937]  [<ffffffffa0411b4d>] transaction_kthread+0x19d/0x220 [btrfs]
>> [  314.100020]  [<ffffffff81068043>] kthread+0xb3/0xc0
>> [  314.100030]  [<ffffffff815bbf7c>] ret_from_fork+0x7c/0xb0
>> [  314.100069] Code: 66 0f 1f 44 00 00 f3 90 0f b7 07 66 39 d0 75 f6
>> c3 0f 1f 44 00 00 65 48 8b 04 25 30 b9 00 00 83 80 44 e0 ff ff 01 b8
>> 00 00 01 00 <f0> 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 0f 0f 1f 44 00 00
>> f3 90
>> [  314.100073] RIP  [<ffffffff815b5285>] _raw_spin_lock+0x15/0x40
>> [  314.100075]  RSP <ffff8800977bfd80>
>> [  314.100076] CR2: ffffffff81068138
>> [  314.100079] ---[ end trace 64d3998241407ddf ]---
>> [  314.100083] note: btrfs-transacti[5310] exited with preempt_count 1
>>
>>
>> --
>> Jon
>> Software Blacksmith
>
>
>
> --
> Jon
> Software Blacksmith



-- 
Jon
Software Blacksmith
