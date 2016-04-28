Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:59557 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbcD1MKO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 08:10:14 -0400
Date: Thu, 28 Apr 2016 15:10:10 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v5 00/13] Introduce device state 'failed', spare device
 and auto replace
Message-ID: <20160428121010.GA19558@jeknote.loshitsa1.net>
References: <1460979104-27497-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460979104-27497-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 18, 2016 at 07:31:31PM +0800, Anand Jain wrote:
> Thanks for various comments, tests and feedback.
> 
> 
> Changelog:
> ---------
> 
> v4->v5:
> Kernel:
>   a. Originally we had bugs as fixed in the patches below
>      [PATCH] btrfs: s_bdev is not null after missing replace
>      [PATCH] btrfs: cleanup assigning next active device with a check
>      Incorporate those changes at force close device.
> 
>   b. Fixup
>       btrfs: Introduce a new function to check if all chunks a OK for degraded mount
>      as in
>       [PATCH] btrfs: fix btrfs_check_degradable() to free extent map
> 
> Progs:
>   None.
> 
> v3->v4:
> Kernel:
>  a.
>   Mainly bug fixes. Thanks to Yauhen for the bug reports.
>   Fixed the issue of bdev not being null. Also fixed the
>   issue where auto replace didn't check for
>   mutually_exclusive_operation_running. In this process,
>   the function force_device_close() is changed quite a
>   bit, mainly bdev is copied and nulled within the lock
>   context, and later close on the copied bdev is called.
>  b.
>   changed the wording hot spare to spare device, as some of
>   the legacy raid setup would need a perticular device
>   order for some reasons. So the hot spare would copy
>   back the replace target to the replaced disk. However
>   we don't need such a setup in modern hw and btrfs won't
>   do that way. To avoid any confusion I won't use the term
>   hot spare here.
> 
> progs:
>  No change. Same as v2.

Hmmm.... It seems like I have reproduced bug with null bdev fixed in v3.

Kernel 4.6-rc4, device was closed during of replacing it by other.

Sequense was:
1) create FS (RAID5), mount, write 40 MB file, sync
2) detach drive
3) start replace detached (but still not closed) drive by another
4) touch mount point, call 'btrfs fi sync' (I use udev script to initiate write immediately after drive removal)
4) <device is closed here> -> oops.

Failed line in generic_make_request_checks() seems to be

(gdb) list *(generic_make_request_checks+0x226)
0xffffffff812b9ff6 is in generic_make_request_checks (block/blk-core.c:1998).
1993
1994            if (!blkcg_bio_issue_check(q, bio))
1995                    return false;
1996
1997            trace_block_bio_queue(q, bio);
1998            return true;
1999
2000    end_io:
2001            bio->bi_error = err;
2002            bio_endio(bio);


Logs:

[  501.174109] BTRFS: device fsid 36dac817-e212-4ebd-b0a9-158511142cca devid 1 transid 3 /dev/sdc
[  501.225342] BTRFS: device fsid 36dac817-e212-4ebd-b0a9-158511142cca devid 2 transid 3 /dev/sde
[  501.248114] BTRFS: device fsid 36dac817-e212-4ebd-b0a9-158511142cca devid 3 transid 3 /dev/sdf
[  501.424316] BTRFS info (device sdf): disk space caching is enabled
[  501.437013] BTRFS: has skinny extents
[  501.440414] BTRFS: flagging fs with big metadata feature
[  501.454078] BTRFS: creating UUID tree
[  501.492933] BTRFS info (device sdf): event FSID=36dac817-e212-4ebd-b0a9-158511142cca,EVENT=state_changed,FS_STATE=good,,
[  502.047861] sd 3:0:0:0: [sdf] Synchronizing SCSI cache
[  502.065678] sd 3:0:0:0: [sdf] Stopping disk
[  502.093117] ata4.00: disabled
[  502.232151] ata4: hard resetting link
[  502.553636] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  502.569587] ata4.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
[  502.573199] ata4.00: 41943040 sectors, multi 128: LBA48 NCQ (depth 31/32)
[  502.605463] ata4.00: configured for UDMA/133
[  502.625707] ata4: EH complete
[  502.658374] scsi 3:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0 ANSI: 5
[  502.742139] sd 3:0:0:0: [sdd] 41943040 512-byte logical blocks: (21.5 GB/20.0 GiB)
[  502.764534] sd 3:0:0:0: Attached scsi generic sg3 type 0
[  502.772915] sd 3:0:0:0: [sdd] Write Protect is off
[  502.780088] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  502.834239] sd 3:0:0:0: [sdd] Attached SCSI disk
[  504.997866] BTRFS info (device sdf): dev_replace from /dev/sdf (devid 3) to /dev/sdd started
[  505.079668] BTRFS error (device sdf): bdev /dev/sdf errs: wr 0, rd 0, flush 1, corrupt 0, gen 0
[  505.090617] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
[  505.100133] BTRFS error (device sdf): bdev /dev/sdf errs: wr 1, rd 0, flush 1, corrupt 0, gen 0
[  505.104022] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
[  505.138437] BTRFS error (device sdf): bdev /dev/sdf errs: wr 2, rd 0, flush 1, corrupt 0, gen 0
[  505.174972] BTRFS info (device sdf): event FSID=36dac817-e212-4ebd-b0a9-158511142cca,EVENT=scrub_started,FS_STATE=replacing,,
[  505.210637] BTRFS warning (device sdf): i/o error at logical 20987904 on dev /dev/sdf, sector 2080: metadata leaf (level 0) in tree 3
[  505.245229] BTRFS warning (device sdf): i/o error at logical 20987904 on dev /dev/sdf, sector 2080: metadata leaf (level 0) in tree 3
[  505.281491] BTRFS error (device sdf): bdev /dev/sdf errs: wr 2, rd 1, flush 1, corrupt 0, gen 0
[  505.323670] BTRFS error (device sdf): fixed up error at logical 20987904 on dev /dev/sdf
[  505.396037] BTRFS error (device sdf): bdev /dev/sdf errs: wr 2, rd 1, flush 2, corrupt 0, gen 0
[  505.816820] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
[  505.980350] BTRFS error (device sdf): bdev /dev/sdf errs: wr 3, rd 1, flush 2, corrupt 0, gen 0
[  506.060469] BTRFS warning (device sdf): lost page write due to IO error on /dev/sdf
[  506.083004] BTRFS error (device sdf): bdev /dev/sdf errs: wr 4, rd 1, flush 2, corrupt 0, gen 0
[  506.152976] BTRFS critical (device sdf): fatal error on device /dev/sdf
[  506.154907] BTRFS warning (device sdf): i/o error at logical 37765120 on dev /dev/sdf, sector 18464: metadata leaf (level 0) in tree 9
[  506.154909] BTRFS warning (device sdf): i/o error at logical 37765120 on dev /dev/sdf, sector 18464: metadata leaf (level 0) in tree 9
[  506.154912] BTRFS error (device sdf): bdev /dev/sdf errs: wr 4, rd 2, flush 2, corrupt 0, gen 0
[  506.155171] BTRFS error (device sdf): fixed up error at logical 37765120 on dev /dev/sdf
[  506.155351] BTRFS warning (device sdf): i/o error at logical 38109184 on dev /dev/sdf, sector 18752: metadata leaf (level 0) in tree 7
[  506.155353] BTRFS warning (device sdf): i/o error at logical 38109184 on dev /dev/sdf, sector 18752: metadata leaf (level 0) in tree 7
[  506.155355] BTRFS error (device sdf): bdev /dev/sdf errs: wr 4, rd 3, flush 2, corrupt 0, gen 0
[  506.155785] BTRFS error (device sdf): fixed up error at logical 38109184 on dev /dev/sdf
[  506.155811] BTRFS warning (device sdf): i/o error at logical 38125568 on dev /dev/sdf, sector 18784: metadata leaf (level 0) in tree 2
[  506.155813] BTRFS warning (device sdf): i/o error at logical 38125568 on dev /dev/sdf, sector 18784: metadata leaf (level 0) in tree 2
[  506.155815] BTRFS error (device sdf): bdev /dev/sdf errs: wr 4, rd 4, flush 2, corrupt 0, gen 0
[  506.156125] BTRFS error (device sdf): fixed up error at logical 38125568 on dev /dev/sdf
[  506.156143] BTRFS warning (device sdf): i/o error at logical 38141952 on dev /dev/sdf, sector 18816: metadata leaf (level 0) in tree 4
[  506.156144] BTRFS warning (device sdf): i/o error at logical 38141952 on dev /dev/sdf, sector 18816: metadata leaf (level 0) in tree 4
[  506.156390] BTRFS error (device sdf): fixed up error at logical 38141952 on dev /dev/sdf
[  506.157290] BTRFS warning (device sdf): i/o error at logical 38158336 on dev /dev/sdf, sector 18848: metadata leaf (level 0) in tree 1
[  506.157292] BTRFS warning (device sdf): i/o error at logical 38158336 on dev /dev/sdf, sector 18848: metadata leaf (level 0) in tree 1
[  506.159130] BTRFS error (device sdf): fixed up error at logical 38158336 on dev /dev/sdf
[  506.159155] BTRFS warning (device sdf): i/o error at logical 38174720 on dev /dev/sdf, sector 18880: metadata node (level 1) in tree 7
[  506.159167] BTRFS warning (device sdf): i/o error at logical 38174720 on dev /dev/sdf, sector 18880: metadata node (level 1) in tree 7
[  506.159314] BTRFS error (device sdf): fixed up error at logical 38174720 on dev /dev/sdf
[  506.159330] BTRFS warning (device sdf): i/o error at logical 38191104 on dev /dev/sdf, sector 18912: metadata leaf (level 0) in tree 7
[  506.159332] BTRFS warning (device sdf): i/o error at logical 38191104 on dev /dev/sdf, sector 18912: metadata leaf (level 0) in tree 7
[  506.159503] BTRFS error (device sdf): fixed up error at logical 38191104 on dev /dev/sdf
[  506.224289] BTRFS warning (device sdf): i/o error at logical 2186346496 on dev /dev/sdf, sector 2116608, root 5, inode 257, offset 65536, length 4096, links 1 (path: test.dat)
[  506.307665] BTRFS error (device sdf): fixed up error at logical 2186346496 on dev /dev/sdf
[  506.307801] BTRFS warning (device sdf): i/o error at logical 2186350592 on dev /dev/sdf, sector 2116616, root 5, inode 257, offset 69632, length 4096, links 1 (path: test.dat)
[  506.308063] BTRFS error (device sdf): fixed up error at logical 2186350592 on dev /dev/sdf
[  506.884108] BTRFS error (device sdf): unable to fixup (regular) error at logical 2190741504 on dev /dev/sdf
[  506.986767] BTRFS error (device sdf): unable to fixup (regular) error at logical 2190745600 on dev /dev/sdf
[  507.145938] BTRFS warning (device sdf): device /dev/sdf marked failed, closed, chunk(s) degraded
[  507.157268] BTRFS error (device sdf): unable to fixup (regular) error at logical 2190749696 on dev /dev/sdf
[  507.157281] BTRFS error (device sdf): unable to fixup (regular) error at logical 2190753792 on dev /dev/sdf
[  507.157288] BTRFS error (device sdf): unable to fixup (regular) error at logical 2190757888 on dev /dev/sdf
[  507.157294] BTRFS error (device sdf): unable to fixup (regular) error at logical 2190761984 on dev /dev/sdf
[  507.157303] BTRFS error (device sdf): unable to fixup (regular) error at logical 2190766080 on dev /dev/sdf
[  507.157309] BTRFS error (device sdf): unable to fixup (regular) error at logical 2190770176 on dev /dev/sdf
[  507.157314] BTRFS error (device sdf): unable to fixup (regular) error at logical 2190774272 on dev /dev/sdf
[  507.157320] BTRFS error (device sdf): unable to fixup (regular) error at logical 2190778368 on dev /dev/sdf
[  507.186438] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[  507.186452] IP: [<ffffffff812b9ff6>] generic_make_request_checks+0x226/0x500
[  507.186460] PGD 2af4a067 PUD 2ac1a067 PMD 0 
[  507.186462] Oops: 0000 [#1] SMP 
[  507.186528] Modules linked in: softdog cpufreq_userspace cpufreq_powersave cpufreq_stats cpufreq_conservative nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc loop ipmi_devintf ipmi_msghandler snd_pcm joydev snd_timer snd iTCO_wdt soundcore iTCO_vendor_support ohci_pci pcspkr ohci_hcd psmouse serio_raw evdev lpc_ich battery video ac mfd_core rng_core parport_pc parport 8250_fintek i2c_piix4 acpi_cpufreq button tpm_tis tpm processor ext4 crc16 jbd2 mbcache crc32c_generic btrfs xor raid6_pq dm_mod md_mod hid_generic usbhid hid xhci_pci xhci_hcd sr_mod cdrom sg sd_mod ata_generic ehci_pci ehci_hcd ata_piix ahci libahci libata usbcore usb_common scsi_mod e1000
[  507.186531] CPU: 0 PID: 5091 Comm: btrfs Not tainted 4.6.0-rc4-scst31x-debug-12+ #2
[  507.186532] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  507.186534] task: ffff88002aaeafc0 ti: ffff880029990000 task.ti: ffff880029990000
[  507.186537] RIP: 0010:[<ffffffff812b9ff6>]  [<ffffffff812b9ff6>] generic_make_request_checks+0x226/0x500
[  507.186538] RSP: 0018:ffff880029993718  EFLAGS: 00010202
[  507.186539] RAX: 0000000000000000 RBX: ffff88002c0fad68 RCX: ffff88002aaeafc0
[  507.186540] RDX: 0000000080000000 RSI: ffff88002c0fad68 RDI: 0000000000000000
[  507.186541] RBP: 0000000000000008 R08: ffffffff817d68e2 R09: ffffffff817d68d1
[  507.186542] R10: 0000000000000000 R11: ffffffff817d68c0 R12: ffff8800297be220
[  507.186543] R13: ffff88001d9d9900 R14: ffff880029909d80 R15: ffff8800297be000
[  507.186549] FS:  00007f3bdc2b4880(0000) GS:ffff88002fc00000(0000) knlGS:0000000000000000
[  507.186550] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  507.186551] CR2: 0000000000000008 CR3: 000000002a6a7000 CR4: 00000000000006f0
[  507.186555] Stack:
[  507.186558]  ffff88002aaeafc0 ffff88002aaeafc0 0000000000000001 0000000000000001
[  507.186565]  0000000000000000 ffff88002c0fad68 00000000ffffffff ffff8800297be220
[  507.186567]  ffff88001d9d9900 ffff880029909d80 ffff8800297be000 ffffffff812bc3ee
[  507.186568] Call Trace:
[  507.186572]  [<ffffffff812bc3ee>] ? generic_make_request+0x1e/0x1b0
[  507.186647]  [<ffffffffa027d8e8>] ? release_extent_buffer+0x28/0xc0 [btrfs]
[  507.186650]  [<ffffffff812bc5df>] ? submit_bio+0x5f/0x130
[  507.186670]  [<ffffffffa02b8549>] ? scrub_add_page_to_rd_bio+0xc9/0x280 [btrfs]
[  507.186673]  [<ffffffff811b6014>] ? alloc_pages_current+0x84/0x110
[  507.186702]  [<ffffffffa02bb306>] ? scrub_raid56_parity+0xb06/0xc80 [btrfs]
[  507.186723]  [<ffffffffa02bbfea>] ? scrub_stripe+0x92a/0x11b0 [btrfs]
[  507.186727]  [<ffffffff810596ca>] ? kvm_clock_read+0x1a/0x20
[  507.186775]  [<ffffffffa02bc97c>] ? scrub_chunk+0x10c/0x150 [btrfs]
[  507.186795]  [<ffffffffa02bcc13>] ? scrub_enumerate_chunks+0x253/0x510 [btrfs]
[  507.186799]  [<ffffffff810b2e00>] ? prepare_to_wait_event+0xd0/0xe0
[  507.186827]  [<ffffffffa02be193>] ? btrfs_scrub_dev+0x1c3/0x530 [btrfs]
[  507.186846]  [<ffffffffa025fae3>] ? start_transaction+0xa3/0x4e0 [btrfs]
[  507.186877]  [<ffffffffa02d1594>] ? btrfs_dev_replace_start+0x2a4/0x3f0 [btrfs]
[  507.186897]  [<ffffffffa02d171a>] ? btrfs_dev_replace_by_ioctl+0x3a/0x60 [btrfs]
[  507.186917]  [<ffffffffa029b0b3>] ? btrfs_ioctl+0x1d43/0x2190 [btrfs]
[  507.186920]  [<ffffffff811f6946>] ? iput+0x86/0x220
[  507.186924]  [<ffffffff812141b5>] ? __blkdev_put+0x1f5/0x250
[  507.186926]  [<ffffffff812ccec9>] ? disk_flush_events+0x39/0x60
[  507.186934]  [<ffffffff811f27b2>] ? dput+0xa2/0x210
[  507.186936]  [<ffffffff811ef02d>] ? do_vfs_ioctl+0x8d/0x5a0
[  507.186939]  [<ffffffff8108434b>] ? do_sigaction+0x17b/0x1a0
[  507.186941]  [<ffffffff811ef5b4>] ? SyS_ioctl+0x74/0x80
[  507.186944]  [<ffffffff8157b7f6>] ? entry_SYSCALL_64_fastpath+0x1e/0xa8
[  507.186964] Code: c5 e0 01 00 00 41 83 e5 10 ba ff ff ff 3f be 01 00 00 00 48 0f 44 fd e8 b9 56 05 00 66 66 66 66 90 b8 01 00 00 00 e9 8a 00 00 00 <48> 8b 47 08 48 8b 40 50 48 c1 f8 09 48 85 c0 0f 84 f2 fd ff ff 
[  507.186966] RIP  [<ffffffff812b9ff6>] generic_make_request_checks+0x226/0x500
[  507.186967]  RSP <ffff880029993718>
[  507.186968] CR2: 0000000000000008
[  507.186971] ---[ end trace 2485f8ef2600e6ab ]---
[  507.665193] sd 2:0:0:0: [sde] Synchronizing SCSI cache
[  507.665344] sd 2:0:0:0: [sde] Stopping disk
[  511.432359] BTRFS info (device sdf): num_devices 4 rw_devices 2 degraded-option: unset


-- 
Yauhen Kharuzhy
