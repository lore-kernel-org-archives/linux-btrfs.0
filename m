From: "Lukas Vacek" <pheeror@gmail.com>
Subject: Re: umount oops
Date: Fri, 25 Jul 2008 13:14:19 +0200
Message-ID: <11129bee0807250414p7f28a4daxa3cd49c1bcd983c2@mail.gmail.com>
References: <11129bee0807241413s4eb4a75fj90772b1711fc7e52@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <11129bee0807241413s4eb4a75fj90772b1711fc7e52@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

sorry, I made a typo in the "testcase" (the second mount)
Basically, it might be enough to mount two different btrfs filesystems
to two different locations, umount one of them and watch
/var/log/kern.log for the oops

dd if=/dev/zero of=mountme bs=4k count=100000
dd if=/dev/zero of=mountme2 bs=4k count=100000
mkfs.btrfs mountme
mkfs.btrfs mountme2
mkdir loop loop2
mount -o loop mountme loop
mount -o loop mountme2 loop2
umount loop
# wait a moment

On 7/24/08, Lukas Vacek <pheeror@gmail.com> wrote:
> Hi,
>
> I tried very promising btrfs to test it a little and I experienced a
> little bug in implementation. I'm not sure where the bug lies however
> this works quite well to reproduce the problem:
>
> dd if=/dev/zero of=mountme bs=4k count=100000
> dd if=/dev/zero of=mountme2 bs=4k count=100000
> mkfs.btrfs mountme
> mkfs.btrfs mountme2
> mkdir loop loop2
> mount -o loop mountme loop
> mount -o loop mountme loop2
> umount loop
> # wait a moment
>
> maybe SMP machine will be necessary to experience the same
>
> thanks for the (otherwise ;-)) grea work and have a nice day,
> Lukas V.
>
> the interesting part of log goes next:
>
> Jul 24 22:44:00 minerva kernel: [ 1478.326985] device fsid
> 5442602040543dd1-d32561672012f7a2 devid 1 transid 12 /dev/loop1
> Jul 24 22:44:54 minerva kernel: [ 1532.882212] Unable to handle kernel
> paging request at 00007effdc171f47 RIP:
> Jul 24 22:44:54 minerva kernel: [ 1532.882256]  [wq_per_cpu+0x15/0x20]
> wq_per_cpu+0x15/0x20
> Jul 24 22:44:54 minerva kernel: [ 1532.882405] PGD 0
> Jul 24 22:44:54 minerva kernel: [ 1532.882476] Oops: 0000 [1] SMP
> Jul 24 22:44:54 minerva kernel: [ 1532.882572] CPU 1
> Jul 24 22:44:54 minerva kernel: [ 1532.882641] Modules linked in: loop
> binfmt_misc af_packet i915 drm rfcomm l2cap bluetooth ppdev ipv6
> acpi_cpufreq cpufreq_ondemand cpufreq_stats freq_table
> cpufreq_userspace cpufreq_conservative cpufreq_powersave video output
> container sbs sbshc dock battery iptable_filter ip_tables x_tables
> aes_x86_64 dm_crypt dm_mod ac btrfs libcrc32c lp snd_hda_intel
> snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
> snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
> snd_seq snd_timer iTCO_wdt iTCO_vendor_support snd_seq_device button
> snd evdev shpchp pci_hotplug intel_agp soundcore parport_pc parport
> pcspkr ext3 jbd mbcache usbhid hid sg sd_mod ata_piix pata_acpi floppy
> ehci_hcd ata_generic libata scsi_mod r8169 uhci_hcd usbcore thermal
> processor fan fbcon tileblit font bitblit softcursor fuse
> Jul 24 22:44:54 minerva kernel: [ 1532.885056] Pid: 3959, comm:
> btrfs-transacti Not tainted 2.6.24-19-generic #1
> Jul 24 22:44:54 minerva kernel: [ 1532.885117] RIP:
> 0010:[wq_per_cpu+0x15/0x20]  [wq_per_cpu+0x15/0x20]
> wq_per_cpu+0x15/0x20
> Jul 24 22:44:54 minerva kernel: [ 1532.885224] RSP:
> 0018:ffff81003e6a1c08  EFLAGS: 00010246
> Jul 24 22:44:54 minerva kernel: [ 1532.885281] RAX: 00007effdc171f3f
> RBX: ffff81003db0b770 RCX: 0000000000000000
> Jul 24 22:44:54 minerva kernel: [ 1532.885342] RDX: 0000000000000000
> RSI: 0000000000000001 RDI: ffff810023e8e940
> Jul 24 22:44:54 minerva kernel: [ 1532.885404] RBP: ffff81003db0a000
> R08: 0000000000000000 R09: ffffffff882c9d80
> Jul 24 22:44:54 minerva kernel: [ 1532.885465] R10: ffff81003653ade0
> R11: 0000000000000000 R12: ffff81003653ade0
> Jul 24 22:44:54 minerva kernel: [ 1532.885526] R13: 0000000000000001
> R14: ffff810014366680 R15: 0000000000000000
> Jul 24 22:44:54 minerva kernel: [ 1532.885588] FS:
> 0000000000000000(0000) GS:ffff81003e401700(0000)
> knlGS:0000000000000000
> Jul 24 22:44:54 minerva kernel: [ 1532.885671] CS:  0010 DS: 0018 ES:
> 0018 CR0: 000000008005003b
> Jul 24 22:44:54 minerva kernel: [ 1532.885728] CR2: 00007effdc171f47
> CR3: 00000000225cc000 CR4: 00000000000006e0
> Jul 24 22:44:54 minerva kernel: [ 1532.885789] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> Jul 24 22:44:54 minerva kernel: [ 1532.885851] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Jul 24 22:44:54 minerva kernel: [ 1532.885912] Process btrfs-transacti
> (pid: 3959, threadinfo ffff81003e6a0000, task ffff81003c74c7e0)
> Jul 24 22:44:54 minerva kernel: [ 1532.885996] Stack:
> ffffffff8024f97c ffff81001e3db480 ffffffff882ca4ce ffffffff882c9d80
> Jul 24 22:44:54 minerva kernel: [ 1532.886193]  0000000001c08fff
> ffff810014366680 ffff81003653ad40 0000000000001000
> Jul 24 22:44:54 minerva kernel: [ 1532.886364]  ffff81003ee140e8
> 0000000000000001 ffffffff882e19cf 0000000001c09000
> Jul 24 22:44:54 minerva kernel: [ 1532.886495] Call Trace:
> Jul 24 22:44:54 minerva kernel: [ 1532.886587]
> [shpchp:queue_work+0x2c/0x50] queue_work+0x2c/0x50
> Jul 24 22:44:54 minerva kernel: [ 1532.886665]
> [btrfs:btrfs_wq_submit_bio+0xbe/0xf0]
> :btrfs:btrfs_wq_submit_bio+0xbe/0xf0
> Jul 24 22:44:54 minerva kernel: [ 1532.886743]
> [btrfs:__btree_submit_bio_hook+0x0/0x60]
> :btrfs:__btree_submit_bio_hook+0x0/0x60
> Jul 24 22:44:54 minerva kernel: [ 1532.886826]
> [btrfs:submit_one_bio+0xcf/0x120] :btrfs:submit_one_bio+0xcf/0x120
> Jul 24 22:44:54 minerva kernel: [ 1532.886907]
> [btrfs:extent_write_full_page+0x9d/0xb0]
> :btrfs:extent_write_full_page+0x9d/0xb0
> Jul 24 22:44:54 minerva kernel: [ 1532.886992]
> [btrfs:btree_get_extent+0x0/0x1f0] :btrfs:btree_get_extent+0x0/0x1f0
> Jul 24 22:44:54 minerva kernel: [ 1532.887057]
> [btrfs:write_one_page+0x7b/0x430] write_one_page+0x7b/0x100
> Jul 24 22:44:54 minerva kernel: [ 1532.887140]
> [btrfs:btrfs_write_and_wait_transaction+0xc6/0x130]
> :btrfs:btrfs_write_and_wait_transaction+0xc6/0x130
> Jul 24 22:44:54 minerva kernel: [ 1532.887246]
> [btrfs:btrfs_commit_transaction+0x3c8/0x700]
> :btrfs:btrfs_commit_transaction+0x3c8/0x700
> Jul 24 22:44:54 minerva kernel: [ 1532.887314]  [<ffffffff80253a00>]
> autoremove_wake_function+0x0/0x30
> Jul 24 22:44:54 minerva kernel: [ 1532.887398]
> [btrfs:btrfs_transaction_cleaner+0xf0/0x110]
> :btrfs:btrfs_transaction_cleaner+0xf0/0x110
> Jul 24 22:44:54 minerva kernel: [ 1532.887479]
> [btrfs:btrfs_transaction_cleaner+0x0/0x110]
> :btrfs:btrfs_transaction_cleaner+0x0/0x110
> Jul 24 22:44:54 minerva kernel: [ 1532.887543]
> [run_workqueue+0xcc/0x170] run_workqueue+0xcc/0x170
> Jul 24 22:44:54 minerva kernel: [ 1532.887601]
> [worker_thread+0x0/0x110] worker_thread+0x0/0x110
> Jul 24 22:44:54 minerva kernel: [ 1532.887661]
> [worker_thread+0x0/0x110] worker_thread+0x0/0x110
> Jul 24 22:44:54 minerva kernel: [ 1532.887720]
> [worker_thread+0xa3/0x110] worker_thread+0xa3/0x110
> Jul 24 22:44:54 minerva kernel: [ 1532.887780]  [<ffffffff80253a00>]
> autoremove_wake_function+0x0/0x30
> Jul 24 22:44:54 minerva kernel: [ 1532.887842]
> [worker_thread+0x0/0x110] worker_thread+0x0/0x110
> Jul 24 22:44:54 minerva kernel: [ 1532.887902]
> [worker_thread+0x0/0x110] worker_thread+0x0/0x110
> Jul 24 22:44:54 minerva kernel: [ 1532.887960]  [kthread+0x4b/0x80]
> kthread+0x4b/0x80
> Jul 24 22:44:54 minerva kernel: [ 1532.888019]  [child_rip+0xa/0x12]
> child_rip+0xa/0x12
> Jul 24 22:44:54 minerva kernel: [ 1532.888083]  [kthread+0x0/0x80]
> kthread+0x0/0x80
> Jul 24 22:44:54 minerva kernel: [ 1532.888140]  [child_rip+0x0/0x12]
> child_rip+0x0/0x12
> Jul 24 22:44:54 minerva kernel: [ 1532.888198]
> Jul 24 22:44:54 minerva kernel: [ 1532.888243]
> Jul 24 22:44:54 minerva kernel: [ 1532.888244] Code: 48 8b 04 f0 c3 66
> 0f 1f 44 00 00 53 48 8b 4f 38 48 89 fb 48
> Jul 24 22:44:54 minerva kernel: [ 1532.888843] RIP
> [wq_per_cpu+0x15/0x20] wq_per_cpu+0x15/0x20
> Jul 24 22:44:54 minerva kernel: [ 1532.888924]  RSP <ffff81003e6a1c08>
> Jul 24 22:44:54 minerva kernel: [ 1532.888975] CR2: 00007effdc171f47
> Jul 24 22:44:54 minerva kernel: [ 1532.889036] ---[ end trace
> be35f60cd93f5943 ]---
>
