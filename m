Return-Path: <SRS0=CP9i=S5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E74FC43218
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Apr 2019 05:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB92F206A3
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Apr 2019 05:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbfD0FTn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 27 Apr 2019 01:19:43 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38156 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725933AbfD0FTm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Apr 2019 01:19:42 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 7B8512D282E; Sat, 27 Apr 2019 01:19:40 -0400 (EDT)
Date:   Sat, 27 Apr 2019 01:19:40 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Simon Mages <mages.simon@googlemail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: can't balance raid1 - rootflags=degraded,subvol=root
Message-ID: <20190427051940.GA20359@hungrycats.org>
References: <CACxPiz16h4sWkJLAw6ZbTki1bGqcPjk9g8mCwEbJrP7J0fVWUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxPiz16h4sWkJLAw6ZbTki1bGqcPjk9g8mCwEbJrP7J0fVWUw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 26, 2019 at 11:55:31PM +0200, Simon Mages wrote:
> Hi,
> 
> Zygo and darkling from #btrfs tried to give me some tips on how to fix
> this, but finally they send me here.
> 
> This is the timestamp of me joining #btrfs, maybe this is of use to someone.
> http://logs.tvrrug.org.uk/logs/%23btrfs/latest.html#2019-04-26T16:37:22
> 
> I used a linux 4.19.x to create a btrfs on a single disk. After that i
> did an installation into this new btrfs and rebooted into the fresh
> install which was using kernel 5.0.7 (now 5.0.9) . Then i added a
> second disk to the btrfs and used the btrfs-balance(8) filters to
> convert the data and metadata into a raid1.
> 
> After that i tried to reboot but hit a kernel panic (i have no initrd,
> i did not know at the time that this needed). After that i played with
> the rootflags without much success. Finally i settled with booting in
> degraded mode. (rootflags=degraded,subvol=root).
> 
> Later i realized that the raid1 was not working properly, there was a
> mix of raid1 and single:
> """
> $ btrfs fi df /
> Data, RAID1: total=24.00GiB, used=22.64GiB
> Data, single: total=37.00GiB, used=36.89GiB
> System, RAID1: total=32.00MiB, used=0.00B
> System, single: total=32.00MiB, used=16.00KiB
> Metadata, RAID1: total=1.00GiB, used=727.88MiB
> Metadata, single: total=1.00GiB, used=15.48MiB
> GlobalReserve, single: total=107.23MiB, used=0.00B
> """
> 
> I tried to fix it with btrfs-balance(8) and -dusage but this would
> just not work for the Data part.
> """
> # btrfs balance start -dconvert=raid1,soft -mconvert=raid1,soft /
> ERROR: error during balancing '/': No space left on device
> There may be more info in syslog - try dmesg | tail
> 
> # dmesg | tail
> [950598.809467] BTRFS info (device sdb2): relocating block group
> 160554811392 flags data
> [950605.077004] BTRFS info (device sdb2): found 4476 extents
> [950617.776373] BTRFS info (device sdb2): found 4476 extents
> [950618.071295] BTRFS info (device sdb2): relocating block group
> 159481069568 flags data
> [950621.671259] BTRFS info (device sdb2): relocating block group
> 129382744064 flags system
> [950622.151091] BTRFS info (device sdb2): relocating block group
> 128309002240 flags metadata
> [950630.654790] BTRFS info (device sdb2): found 17251 extents
> [950631.008841] BTRFS info (device sdb2): relocating block group
> 127235260416 flags data
> [950634.313828] BTRFS info (device sdb2): 33 enospc errors during balance
> [950634.313833] BTRFS info (device sdb2): balance: ended with status: -28
> 
> # btrfs fi df /
> Data, RAID1: total=24.00GiB, used=22.63GiB
> Data, single: total=33.00GiB, used=32.99GiB
> System, RAID1: total=32.00MiB, used=16.00KiB
> Metadata, RAID1: total=1.00GiB, used=734.02MiB
> GlobalReserve, single: total=102.45MiB, used=0.00B
> 
> # btrfs fi show
> Label: none  uuid: 93605aa3-9934-45c1-9772-49b40d04a637
>         Total devices 2 FS bytes used 56.34GiB
>         devid    1 size 2.73TiB used 58.03GiB path /dev/sdb2
>         devid    2 size 2.73TiB used 25.03GiB path /dev/sda2
> """
> 
> Then i tried to scrub the btrfs in read only mode to see if anythings
> wrong, but doing so disabled disk io, i reset the machine, rebuild the
> kernel with btrfs debugging and tried scrubing again.
> 
> .config:
> """
> CONFIG_BTRFS_FS=y
> CONFIG_BTRFS_FS_POSIX_ACL=y
> # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
> CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
> CONFIG_BTRFS_DEBUG=y
> # CONFIG_BTRFS_ASSERT is not set
> CONFIG_BTRFS_FS_REF_VERIFY=y
> """
> 
> scrubing again:
> """
> # btrfs scrub start -r /
> scrub started on /, fsid 93605aa3-9934-45c1-9772-49b40d04a637 (pid=462)
> # btrfs scrub status /   <<< it never returned
> 
> 
> [  108.034261] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000080
> [  108.034342] #PF error: [normal kernel read fault]
> [  108.034387] PGD 0 P4D 0
> [  108.034420] Oops: 0000 [#1] SMP PTI
> [  108.034460] CPU: 0 PID: 464 Comm: btrfs Not tainted 5.0.9_1 #2
> [  108.034517] Hardware name: System manufacturer System Product
> Name/P8H77-M PRO, BIOS 9002 05/30/2014
> [  108.034598] RIP: 0010:scrub_add_page_to_rd_bio+0xa3/0x2d0
> [  108.034634] Code: 38 4c 8b 73 18 48 89 43 28 49 8b 47 10 48 89 43
> 10 4d 85 f6 0f 84 47 01 00 00 49 89 5e 50 4d 89 66 48 48 8b 53 10 48
> 8b 52 68 <48> 8b 92 80 00 00 00
> 49 39 56 08 74 16 66 41 81 66 14 ff fd 48 8b
> [  108.034735] RSP: 0018:ffffb5aac1f8bb98 EFLAGS: 00010202
> [  108.034770] RAX: ffff9e6e3d4a55b0 RBX: ffff9e6e49728000 RCX: 0000000000000000
> [  108.034813] RDX: 0000000000000000 RSI: 0000000000411200 RDI: ffff9e6e3d4a55b0
> [  108.034856] RBP: ffff9e6e4045d800 R08: ffff9e6e4fc270c0 R09: 00000000002ed4a4
> [  108.034899] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffb23ee930
> [  108.034942] R13: ffff9e6e4045da18 R14: ffff9e6e3d4a55b0 R15: ffff9e6e3d4f0f80
> [  108.034986] FS:  00007f88aaaea700(0000) GS:ffff9e6e4fc00000(0000)
> knlGS:0000000000000000
> [  108.035034] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  108.035070] CR2: 0000000000000080 CR3: 00000004017f4003 CR4: 00000000001606f0
> [  108.035120] Call Trace:
> [  108.035147]  ? __switch_to_asm+0x34/0x70
> [  108.035176]  ? __switch_to_asm+0x40/0x70
> [  108.035204]  ? __switch_to_asm+0x34/0x70
> [  108.035233]  ? __switch_to_asm+0x40/0x70
> [  108.035262]  ? kmem_cache_alloc_trace+0xf6/0x1a0
> [  108.035294]  scrub_pages+0x22b/0x420
> [  108.035323]  scrub_supers+0x92/0x130
> [  108.035351]  btrfs_scrub_dev+0x4ac/0x560
> [  108.035380]  ? __kmalloc_track_caller+0x107/0x1e0
> [  108.035414]  ? btrfs_ioctl+0xf42/0x2cf0
> [  108.035443]  ? __check_object_size+0xce/0x183
> [  108.035474]  btrfs_ioctl+0xf8c/0x2cf0
> [  108.035503]  ? __switch_to_asm+0x40/0x70
> [  108.035531]  ? __switch_to_asm+0x34/0x70
> [  108.035559]  ? __switch_to_asm+0x40/0x70
> [  108.035589]  ? do_vfs_ioctl+0xa4/0x630
> [  108.035616]  do_vfs_ioctl+0xa4/0x630
> [  108.035644]  ? create_task_io_context+0x95/0xf0
> [  108.035676]  ? get_task_io_context+0x39/0x70
> [  108.035706]  ksys_ioctl+0x60/0x90
> [  108.035732]  ? __switch_to_asm+0x40/0x70
> [  108.035760]  __x64_sys_ioctl+0x16/0x20
> [  108.035789]  do_syscall_64+0x48/0x100
> [  108.037131]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  108.038491] RIP: 0033:0x7f88ab3ec3c7
> [  108.039834] Code: 00 00 00 75 0c 48 c7 c0 ff ff ff ff 48 83 c4 18
> c3 e8 8d e1 01 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 b8 10 00 00
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 89 ba 0c 00 f7 d8 64 89
> 01 48
> [  108.042704] RSP: 002b:00007f88aaae9d38 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [  108.044143] RAX: ffffffffffffffda RBX: 00005639f6c97770 RCX: 00007f88ab3ec3c7
> [  108.045578] RDX: 00005639f6c97770 RSI: 00000000c400941b RDI: 0000000000000003
> [  108.046583] RBP: 0000000000000000 R08: 00007f88aaaea700 R09: 0000000000000000
> [  108.045578] RDX: 00005639f6c97770 RSI: 00000000c400941b RDI: 0000000000000003
> [  108.046583] RBP: 0000000000000000 R08: 00007f88aaaea700 R09: 0000000000000000
> [  108.047278] R10: 00007f88aaaea700 R11: 0000000000000246 R12: 00007ffcaadb1c9e
> [  108.047958] R13: 00007ffcaadb1c9f R14: 00007f88aaaea700 R15: 0000000000000000
> [  108.048655] Modules linked in: nft_ct nf_conntrack nf_defrag_ipv6
> nf_defrag_ipv4 nfnetlink_log nft_log joydev nft_fib_inet nft_fib_ipv4
> nft_fib_ipv6 nft_fib nf_tables_set hid_generic nf_tables nfnetlink
> usbkbd i915 usbhid hid kvmgt vfio_mdev mdev coretemp vfio_iommu_type1
> intel_rapl vfio i2c_algo_bit x86_pkg_temp_thermal drm_kms_helper
> intel_powerclamp drm kvm_intel kvm intel_gtt eeepc_wmi xhci_pci
> agpgart asus_wmi ehci_pci xhci_hcd irqbypass ehci_hcd syscopyarea
> sysfillrect iTCO_wdt ghash_clmulni_intel usbcore mei_me sparse_keymap
> input_leds intel_cstate sysimgblt r8169 evdev hwmon
> iTCO_vendor_support mac_hid pcc_cpufreq fb_sys_fops mei wmi_bmof video
> wmi serio_raw thermal lpc_ich realtek i2c_i801 intel_rapl_perf pcspkr
> button fan sch_fq_codel
> [  108.052942] CR2: 0000000000000080
> [  108.053670] ---[ end trace 1ddb1e90384b81e4 ]---
> [  108.054446] RIP: 0010:scrub_add_page_to_rd_bio+0xa3/0x2d0
> [  108.055167] Code: 38 4c 8b 73 18 48 89 43 28 49 8b 47 10 48 89 43
> 10 4d 85 f6 0f 84 47 01 00 00 49 89 5e 50 4d 89 66 48 48 8b 53 10 48
> 8b 52 68 <48> 8b 92 80 00 00 00 49 39 56 08 74 16 66 41 81 66 14 ff fd
> 48 8b
> [  108.056705] RSP: 0018:ffffb5aac1f8bb98 EFLAGS: 00010202
> [  108.057466] RAX: ffff9e6e3d4a55b0 RBX: ffff9e6e49728000 RCX: 0000000000000000
> [  108.058223] RDX: 0000000000000000 RSI: 0000000000411200 RDI: ffff9e6e3d4a55b0
> [  108.058956] RBP: ffff9e6e4045d800 R08: ffff9e6e4fc270c0 R09: 00000000002ed4a4
> [  108.059750] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffb23ee930
> [  108.060519] R13: ffff9e6e4045da18 R14: ffff9e6e3d4a55b0 R15: ffff9e6e3d4f0f80
> [  108.061297] FS:  00007f88aaaea700(0000) GS:ffff9e6e4fc00000(0000)
> knlGS:0000000000000000
> [  108.062079] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  108.062867] CR2: 0000000000000080 CR3: 00000004017f4003 CR4: 00000000001606f0
> """
> 
> After the scrubing was started the system was still usable for a
> little while, but then suddenly after maybe half a minute nothing
> requireing disk io was possible. Which includes invoking any kind of
> program. But i was able to see that the scrub process was in state
> 'Sl' (lowercase L). Acording to the manpage of ps:
> S    interruptible sleep (waiting for an event to complete)
> l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
> 
> My next move is to use an initrd and therfore not having to boot
> degraded. Maybe the problem then just goes away, but i am happy to
> help debugging it further if there is any intereset.

OK, now all the weird behavior makes sense.  You have to do this
step first.  I had assumed you had fixed the bootloader immediately so
you were out of degraded mode, and were having problems working with
the full array after that.

Degraded mode is to boot your system and restore the full complement
of drives, either by reconfiguring so all the drives are present at
mount time, or by replacing any disks that failed, or by downgrading and
converting the RAID profile to require fewer drives.  You should not spend
more than the minimum possible time or write iops to the filesystem in
degraded mode.  btrfs can sort of coast along in degraded mode, but
the longer the filesystem is degraded, the lower the probability of
successful recovery.

Some things just won't work if you are below the minimum number of
devices for your RAID profile.  e.g. you can't allocate more block groups
in degraded mode (RAID1 needs 2 disks and you have only 1, so you get
ENOSPC), so whatever unused space you have allocated for btrfs metadata
is the only space you'll be able to use to get your filesystem out of
degraded mode.  Once you run out of metadata space, you'll be unable to
add more, because adding or resizing disks requires metadata space for
device tree updates.  In the worst case you end up with a filesystem
that is effectively read-only, permanently.

In theory, there is no way to re-add a missing device after mounting a
degraded btrfs filesystem.  Theoretically, you must wipe and replace the
missing drive content with 'btrfs replace', as if the drive had failed
and been replaced with a new one.  Practically, in many cases, if the
missing drive has been offline for a short period of time, the filesystem
can be remounted with the missing disk present (i.e. no -odegraded)
and the inconsistencies between mirror copies can be fixed by running
btrfs scrub.  Scrub can't fix inconsistencies in nodatacow(*) files, so
if you have any nodatacow files and you want to keep the data in them,
then the only option after a disk temporarily goes offline is to do a
full replace on the disk.

Given that you have many single-profile block groups on this filesystem,
I wouldn't try 'btrfs replace' in case some of them are on the missing
drive.  Get the initrd set up, boot with the filesystem mounted properly,
start a scrub to resync the disks, and hope for the best.


(*) technically it is nodatasum files that scrub can't fix, but purely
nodatasum files are rare in the field.  nodatacow files are much more
common--you can make one with chattr +C, and some setup scripts do--and
nodatacow implies nodatasum.

> BR
> Simon
> 
> # uname -a
> Linux mephisto 5.0.9_1 #2 SMP Fri Apr 26 20:34:19 CEST 2019 x86_64
> Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz GenuineIntel GNU/Linux
> 
> # btrfs --version
> btrfs-progs v4.20.2
> 
> # btrfs fi show
> Label: none  uuid: 93605aa3-9934-45c1-9772-49b40d04a637
>         Total devices 2 FS bytes used 60.25GiB
>         devid    1 size 2.73TiB used 63.06GiB path /dev/sdb2
>         devid    2 size 2.73TiB used 25.03GiB path /dev/sda2

'btrfs fi show' output can be confusing because it does its own
userspace device scan, so it shows you the btrfs filesystem you
_could_ have mounted, not the btrfs filesystem you _did_ mount.

'btrfs fi show -m' might be more accurate.  'btrfs fi usage' and
'btrfs dev usage' are pretty reliable as well.

> # btrfs fi df /
> Data, RAID1: total=24.00GiB, used=22.64GiB
> Data, single: total=37.00GiB, used=36.89GiB
> System, RAID1: total=32.00MiB, used=0.00B
> System, single: total=32.00MiB, used=16.00KiB
> Metadata, RAID1: total=1.00GiB, used=727.70MiB
> Metadata, single: total=1.00GiB, used=15.66MiB
> GlobalReserve, single: total=107.23MiB, used=0.00B

[...snip logs...]
> [    0.870411] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    0.870523] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    0.871392] ACPI BIOS Error (bug): Could not resolve [\_SB.PCI0.SAT0.SPT0._GTF.DSSP], AE_NOT_FOUND (20181213/psargs-330)
> [    0.871541] ACPI Error: Method parse/execution failed \_SB.PCI0.SAT0.SPT0._GTF, AE_NOT_FOUND (20181213/psparse-531)
> [    0.871735] ACPI BIOS Error (bug): Could not resolve [\_SB.PCI0.SAT0.SPT1._GTF.DSSP], AE_NOT_FOUND (20181213/psargs-330)
> [    0.871873] ACPI Error: Method parse/execution failed \_SB.PCI0.SAT0.SPT1._GTF, AE_NOT_FOUND (20181213/psparse-531)
> [    0.872094] ata1.00: ATA-8: WDC WD3000FYYZ-01UL1B2, 01.01K03, max UDMA/133
> [    0.872195] ata1.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 32), AA
> [    0.872445] ata2.00: ATA-8: TOSHIBA DT01ACA300, MX6OABB0, max UDMA/133
> [    0.872531] ata2.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 32), AA
> [    0.873117] ACPI BIOS Error (bug): Could not resolve [\_SB.PCI0.SAT0.SPT0._GTF.DSSP], AE_NOT_FOUND (20181213/psargs-330)
> [    0.873253] ACPI Error: Method parse/execution failed \_SB.PCI0.SAT0.SPT0._GTF, AE_NOT_FOUND (20181213/psparse-531)
> [    0.873588] ata1.00: configured for UDMA/133
> [    0.873879] ACPI BIOS Error (bug): 
> [    0.873881] scsi 0:0:0:0: Direct-Access     ATA      WDC WD3000FYYZ-0 1K03 PQ: 0 ANSI: 5
> [    0.873881] Could not resolve [\_SB.PCI0.SAT0.SPT1._GTF.DSSP], AE_NOT_FOUND (20181213/psargs-330)
> [    0.874227] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    0.874238] ACPI Error: Method parse/execution failed \_SB.PCI0.SAT0.SPT1._GTF, AE_NOT_FOUND (20181213/psparse-531)
> [    0.874283] sd 0:0:0:0: [sda] 5860533168 512-byte logical blocks: (3.00 TB/2.73 TiB)
> [    0.874295] sd 0:0:0:0: [sda] Write Protect is off
> [    0.874296] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    0.874335] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    0.875087] ata2.00: configured for UDMA/133
> [    0.875249] scsi 1:0:0:0: Direct-Access     ATA      TOSHIBA DT01ACA3 ABB0 PQ: 0 ANSI: 5
> [    0.875513] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [    0.875535] sd 1:0:0:0: [sdb] 5860533168 512-byte logical blocks: (3.00 TB/2.73 TiB)
> [    0.875719] sd 1:0:0:0: [sdb] 4096-byte physical blocks
> [    0.875803] sd 1:0:0:0: [sdb] Write Protect is off
> [    0.875881] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    0.875895] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    0.909228]  sdb: sdb1 sdb2
> [    0.910039] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    0.912922]  sda: sda1 sda2
> [    0.913320] sd 0:0:0:0: [sda] Attached SCSI disk
> [    0.913435] md: Waiting for all devices to be available before autodetect
> [    0.913514] md: If you don't use raid, use raid=noautodetect
> [    0.913731] md: Autodetecting RAID arrays.
> [    0.913806] md: autorun ...
> [    0.913878] md: ... autorun DONE.
> [    0.937791] BTRFS: device fsid 93605aa3-9934-45c1-9772-49b40d04a637 devid 1 transid 3660 /dev/root
> [    0.938461] BTRFS info (device sdb2): allowing degraded mounts
> [    0.938561] BTRFS info (device sdb2): disk space caching is enabled
> [    0.938655] BTRFS info (device sdb2): has skinny extents
> [    0.939621] BTRFS warning (device sdb2): devid 2 uuid bfb889b6-9c4b-40ae-a5d7-56195f7d0fc1 is missing
> [    0.945385] BTRFS warning (device sdb2): devid 2 uuid bfb889b6-9c4b-40ae-a5d7-56195f7d0fc1 is missing

^^ here, btrfs never finds the second device.

In the rest of the log, we don't find devid 2 (sda2) either:

[...]
> [    2.607303] BTRFS info (device sdb2): disk space caching is enabled
[...]
> [    3.880674] BTRFS info (device sdb2): device fsid 93605aa3-9934-45c1-9772-49b40d04a637 devid 1 moved old:/dev/root new:/dev/sdb2
[...]

