Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-3.smtp-out.eu-west-1.amazonses.com ([54.240.4.3]:46436 "EHLO
        a4-3.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966178AbdLSBKj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 20:10:39 -0500
Subject: Re: again "out of space" and remount read only, with 4.14
From: Martin Raiber <martin@urbackup.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <dfdbf8227acb0f10ed14edb0a8638ce0@virtall.com>
 <0102015ff8f9e46f-83a96bab-ee99-4ec2-b09f-7801b64fc2d5-000000@eu-west-1.amazonses.com>
 <ddbe76a2ddcf5d7d7b18f3c7f09294bd@virtall.com>
 <f2667837-fadf-d661-501a-ac349441ad1b@urbackup.org>
Message-ID: <010201606c528b87-9637e80e-2ff6-4f7a-a827-988456f8c148-000000@eu-west-1.amazonses.com>
Date: Tue, 19 Dec 2017 01:10:37 +0000
MIME-Version: 1.0
In-Reply-To: <f2667837-fadf-d661-501a-ac349441ad1b@urbackup.org>
Content-Type: text/plain; charset=utf-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03.12.2017 16:39 Martin Raiber wrote:
> Am 26.11.2017 um 17:02 schrieb Tomasz Chmielewski:
>> On 2017-11-27 00:37, Martin Raiber wrote:
>>> On 26.11.2017 08:46 Tomasz Chmielewski wrote:
>>>> Got this one on a 4.14-rc7 filesystem with some 400 GB left:
>>> I guess it is too late now, but I guess the "btrfs fi usage" output of
>>> the file system (especially after it went ro) would be useful.
>> It was more or less similar as it went ro:
>>
>> # btrfs fi usage /srv
>> Overall:
>>     Device size:                   5.25TiB
>>     Device allocated:              4.45TiB
>>     Device unallocated:          823.97GiB
>>     Device missing:                  0.00B
>>     Used:                          4.33TiB
>>     Free (estimated):            471.91GiB      (min: 471.91GiB)
>>     Data ratio:                       2.00
>>     Metadata ratio:                   2.00
>>     Global reserve:              512.00MiB      (used: 0.00B)
>>
>> Unallocated:
>>    /dev/sda4     411.99GiB
>>    /dev/sdb4     411.99GiB
> I wanted to check if is the same issue I have, e.g. with 4.14.1
> space_cache=v2:
>
> [153245.341823] BTRFS: error (device loop0) in
> btrfs_run_delayed_refs:3089: errno=-28 No space left
> [153245.341845] BTRFS: error (device loop0) in btrfs_drop_snapshot:9317:
> errno=-28 No space left
> [153245.341848] BTRFS info (device loop0): forced readonly
> [153245.341972] BTRFS warning (device loop0): Skipping commit of aborted
> transaction.
> [153245.341975] BTRFS: error (device loop0) in cleanup_transaction:1873:
> errno=-28 No space left
> # btrfs fi usage /media/backup
> Overall:
>     Device size:                  49.60TiB
>     Device allocated:             38.10TiB
>     Device unallocated:           11.50TiB
>     Device missing:                  0.00B
>     Used:                         36.98TiB
>     Free (estimated):             12.59TiB      (min: 12.59TiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   1.00
>     Global reserve:                2.00GiB      (used: 1.99GiB)
>
> Data,single: Size:37.70TiB, Used:36.61TiB
>    /dev/loop0     37.70TiB
>
> Metadata,single: Size:411.01GiB, Used:380.98GiB
>    /dev/loop0    411.01GiB
>
> System,single: Size:36.00MiB, Used:4.00MiB
>    /dev/loop0     36.00MiB
>
> Unallocated:
>    /dev/loop0     11.50TiB
>
> Note the global reserve being at maximum. I already increased that in
> the code to 2G and that seems to make this issue appear more rarely.

This time with enospc_debug mount option:

With Linux 4.14.3. Single large device.

[15179.739038] ------------[ cut here ]------------
[15179.739059] WARNING: CPU: 0 PID: 28694 at fs/btrfs/extent-tree.c:8458
btrfs_alloc_tree_block+0x38f/0x4a0
[15179.739060] Modules linked in: bcache loop dm_crypt algif_skcipher
af_alg st sr_mod cdrom xfs libcrc32c zbud intel_rapl sb_edac
x86_pkg_temp_thermal intel_powerclamp coretemp iTCO_wdt kvm_intel kvm
iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel pcbc raid1 mgag200 snd_pcm aesni_intel ttm snd_timer
drm_kms_helper snd soundcore aes_x86_64 crypto_simd glue_helper cryptd
pcspkr i2c_i801 joydev drm mei_me evdev lpc_ich mei mfd_core ipmi_si
ipmi_devintf ipmi_msghandler tpm_tis tpm_tis_core tpm wmi ioatdma button
shpchp fuse autofs4 hid_generic usbhid hid sg sd_mod dm_mod dax md_mod
crc32c_intel isci ahci mpt3sas libsas libahci igb raid_class ehci_pci
i2c_algo_bit libata dca ehci_hcd scsi_transport_sas ptp nvme pps_core
scsi_mod usbcore nvme_core
[15179.739133] CPU: 0 PID: 28694 Comm: btrfs Not tainted 4.14.3 #2
[15179.739134] Hardware name: Supermicro
X9DRi-LN4+/X9DR3-LN4+/X9DRi-LN4+/X9DR3-LN4+, BIOS 3.2 03/04/2015
[15179.739136] task: ffff8813e4f02ac0 task.stack: ffffc9000aea0000
[15179.739140] RIP: 0010:btrfs_alloc_tree_block+0x38f/0x4a0
[15179.739141] RSP: 0018:ffffc9000aea3558 EFLAGS: 00010292
[15179.739144] RAX: 000000000000001d RBX: 0000000000004000 RCX:
0000000000000000
[15179.739146] RDX: ffff880c4fa15b38 RSI: ffff880c4fa0de58 RDI:
ffff880c4fa0de58
[15179.739147] RBP: ffffc9000aea35d0 R08: 0000000000000001 R09:
0000000000000662
[15179.739149] R10: 0000160000000000 R11: 0000000000000662 R12:
ffff880c0a454000
[15179.739151] R13: ffff880c4ba33800 R14: 0000000000000001 R15:
ffff880c0a454128
[15179.739153] FS:  00007f0d699128c0(0000) GS:ffff880c4fa00000(0000)
knlGS:0000000000000000
[15179.739155] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15179.739156] CR2: 00007bbfcdf2c6e8 CR3: 000000151da91003 CR4:
00000000000606f0
[15179.739158] Call Trace:
[15179.739166]  __btrfs_cow_block+0x117/0x580
[15179.739169]  btrfs_cow_block+0xdf/0x200
[15179.739171]  btrfs_search_slot+0x1ea/0x990
[15179.739174]  lookup_inline_extent_backref+0xdf/0x570
[15179.739177]  ? __set_page_dirty_nobuffers+0x11e/0x160
[15179.739179]  insert_inline_extent_backref+0x40/0xb0
[15179.739183]  ? __slab_free+0x178/0x2c0
[15179.739185]  __btrfs_inc_extent_ref.isra.59+0x6b/0x220
[15179.739188]  __btrfs_run_delayed_refs+0x924/0x12c0
[15179.739191]  btrfs_run_delayed_refs+0x7a/0x260
[15179.739194]  create_pending_snapshot+0x5e4/0xf00
[15179.739197]  create_pending_snapshots+0x97/0xc0
[15179.739199]  ? create_pending_snapshots+0x97/0xc0
[15179.739201]  btrfs_commit_transaction+0x395/0x930
[15179.739202]  ? start_transaction+0x9b/0x440
[15179.739206]  ? remove_wait_queue+0x70/0x70
[15179.739209]  btrfs_mksubvol+0x4a6/0x4f0
[15179.739211]  ? remove_wait_queue+0x70/0x70
[15179.739213]  btrfs_ioctl_snap_create_transid+0x185/0x190
[15179.739216]  btrfs_ioctl_snap_create_v2+0x104/0x150
[15179.739218]  btrfs_ioctl+0x5e1/0x23b0
[15179.739222]  do_vfs_ioctl+0x92/0x5a0
[15179.739226]  ? __do_page_fault+0x267/0x4e0
[15179.739228]  SyS_ioctl+0x79/0x90
[15179.739234]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[15179.739235] RIP: 0033:0x7f0d6899c1c7
[15179.739236] RSP: 002b:00007ffede13b458 EFLAGS: 00000202 ORIG_RAX:
0000000000000010
[15179.739238] RAX: ffffffffffffffda RBX: 0000000000461757 RCX:
00007f0d6899c1c7
[15179.739239] RDX: 00007ffede13b498 RSI: 0000000050009417 RDI:
0000000000000003
[15179.739240] RBP: 0000000000000016 R08: 0000000000000008 R09:
00007f0d6890699a
[15179.739241] R10: 00007ffede13b220 R11: 0000000000000202 R12:
00007f0d68c612a0
[15179.739242] R13: 0000000000000016 R14: 0000000000000016 R15:
00007ffede13b388
[15179.739244] Code: 84 83 81 48 c7 c7 60 f9 ca 81 89 45 88 e8 1a cf 46
00 85 c0 8b 55 88 0f 84 15 fd ff ff 89 d6 48 c7 c7 68 f8 a4 81 e8 92 04
db ff <0f> ff e9 00 fd ff ff 4c 63 e8 31 d2 48 89 de 4c 89 ff e8 9a ec
[15179.739274] ---[ end trace ab2c9ed559309c04 ]---
[15179.739279] BTRFS: Transaction aborted (error -28)
[15179.739284] ------------[ cut here ]------------
[15179.739287] WARNING: CPU: 0 PID: 28694 at fs/btrfs/extent-tree.c:3089
btrfs_run_delayed_refs+0x258/0x260
[15179.739287] Modules linked in: bcache loop dm_crypt algif_skcipher
af_alg st sr_mod cdrom xfs libcrc32c zbud intel_rapl sb_edac
x86_pkg_temp_thermal intel_powerclamp coretemp iTCO_wdt kvm_intel kvm
iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel pcbc raid1 mgag200 snd_pcm aesni_intel ttm snd_timer
drm_kms_helper snd soundcore aes_x86_64 crypto_simd glue_helper cryptd
pcspkr i2c_i801 joydev drm mei_me evdev lpc_ich mei mfd_core ipmi_si
ipmi_devintf ipmi_msghandler tpm_tis tpm_tis_core tpm wmi ioatdma button
shpchp fuse autofs4 hid_generic usbhid hid sg sd_mod dm_mod dax md_mod
crc32c_intel isci ahci mpt3sas libsas libahci igb raid_class ehci_pci
i2c_algo_bit libata dca ehci_hcd scsi_transport_sas ptp nvme pps_core
scsi_mod usbcore nvme_core
[15179.739326] CPU: 0 PID: 28694 Comm: btrfs Tainted: G        W      
4.14.3 #2
[15179.739327] Hardware name: Supermicro
X9DRi-LN4+/X9DR3-LN4+/X9DRi-LN4+/X9DR3-LN4+, BIOS 3.2 03/04/2015
[15179.739328] task: ffff8813e4f02ac0 task.stack: ffffc9000aea0000
[15179.739330] RIP: 0010:btrfs_run_delayed_refs+0x258/0x260
[15179.739331] RSP: 0018:ffffc9000aea3a30 EFLAGS: 00010286
[15179.739332] RAX: 0000000000000026 RBX: ffff88183b8ccd98 RCX:
0000000000000006
[15179.739333] RDX: 0000000000000007 RSI: 0000000000000082 RDI:
ffff880c4fa0de50
[15179.739334] RBP: ffffc9000aea3a90 R08: 0000000000000001 R09:
0000000000000696
[15179.739335] R10: ffffc9000aea3910 R11: 0000000000000696 R12:
ffff880c91f29968
[15179.739336] R13: ffff880c0a454000 R14: ffff880ca9af8a80 R15:
ffffffffffffffff
[15179.739338] FS:  00007f0d699128c0(0000) GS:ffff880c4fa00000(0000)
knlGS:0000000000000000
[15179.739339] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15179.739340] CR2: 00007bbfcdf2c6e8 CR3: 000000151da91003 CR4:
00000000000606f0
[15179.739340] Call Trace:
[15179.739343]  create_pending_snapshot+0x5e4/0xf00
[15179.739346]  create_pending_snapshots+0x97/0xc0
[15179.739347]  ? create_pending_snapshots+0x97/0xc0
[15179.739349]  btrfs_commit_transaction+0x395/0x930
[15179.739351]  ? start_transaction+0x9b/0x440
[15179.739352]  ? remove_wait_queue+0x70/0x70
[15179.739354]  btrfs_mksubvol+0x4a6/0x4f0
[15179.739356]  ? remove_wait_queue+0x70/0x70
[15179.739358]  btrfs_ioctl_snap_create_transid+0x185/0x190
[15179.739361]  btrfs_ioctl_snap_create_v2+0x104/0x150
[15179.739363]  btrfs_ioctl+0x5e1/0x23b0
[15179.739365]  do_vfs_ioctl+0x92/0x5a0
[15179.739367]  ? __do_page_fault+0x267/0x4e0
[15179.739369]  SyS_ioctl+0x79/0x90
[15179.739372]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[15179.739373] RIP: 0033:0x7f0d6899c1c7
[15179.739374] RSP: 002b:00007ffede13b458 EFLAGS: 00000202 ORIG_RAX:
0000000000000010
[15179.739376] RAX: ffffffffffffffda RBX: 0000000000461757 RCX:
00007f0d6899c1c7
[15179.739377] RDX: 00007ffede13b498 RSI: 0000000050009417 RDI:
0000000000000003
[15179.739378] RBP: 0000000000000016 R08: 0000000000000008 R09:
00007f0d6890699a
[15179.739379] R10: 00007ffede13b220 R11: 0000000000000202 R12:
00007f0d68c612a0
[15179.739380] R13: 0000000000000016 R14: 0000000000000016 R15:
00007ffede13b388
[15179.739381] Code: 85 83 81 48 89 df 44 89 45 d0 e8 0d 7c fe ff 44 8b
45 d0 44 89 c0 eb 86 44 89 c6 48 c7 c7 88 ef a4 81 44 89 45 d0 e8 a9 47
db ff <0f> ff 44 8b 45 d0 eb c1 66 66 66 66 90 55 48 89 e5 41 55 41 54
[15179.739410] ---[ end trace ab2c9ed559309c05 ]---
[15179.739498] BTRFS: error (device md1) in btrfs_run_delayed_refs:3089:
errno=-28 No space left
[15179.739534] BTRFS: error (device md1) in btrfs_drop_snapshot:9331:
errno=-28 No space left
[15179.739538] BTRFS info (device md1): forced readonly
[15179.739649] BTRFS: error (device md1) in
create_pending_snapshot:1625: errno=-28 No space left
[15179.739729] BTRFS warning (device md1): Skipping commit of aborted
transaction.
[15179.739731] BTRFS: error (device md1) in cleanup_transaction:1873:
errno=-28 No space left

After it went ro:

btrfs fi usage /media/backup
Overall:
    Device size:                  56.08TiB
    Device allocated:             43.11TiB
    Device unallocated:           12.96TiB
    Device missing:                  0.00B
    Used:                         43.05TiB
    Free (estimated):             13.01TiB      (min: 13.01TiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:                6.00GiB      (used: 0.00B)

Data,single: Size:42.67TiB, Used:42.62TiB
   /dev/md1     42.67TiB

Metadata,single: Size:457.01GiB, Used:440.24GiB
   /dev/md1    457.01GiB

System,single: Size:36.00MiB, Used:4.52MiB
   /dev/md1     36.00MiB

Unallocated:
   /dev/md1     12.96TiB

