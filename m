Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43002 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab3DMPsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Apr 2013 11:48:36 -0400
Received: from merkaba.localnet (ppp-93-104-156-105.dynamic.mnet-online.de [93.104.156.105])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 0ACD1BB
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Apr 2013 17:47:56 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs scrub gives unable to find logical $hugenum len 16384
Date: Sat, 13 Apr 2013 17:48:31 +0200
Message-ID: <5157386.Pre7jntDtG@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Please answer soon whether it would be a good idea to replay a backup right
now as I am leaving to Berlin tomorrow for a week without my backup drive
with me. Well, I made space on an external 2,5 inch drive, that I can take with
me. I am taking that one with me, after having made sure it has a consistent
backup. :)


On investigating

[Akonadi] [Bug 318290] New: Empty mails: AkonadiAgentServer(4890)/libakonadi Akonadi::ResourceBase::itemRetrieved: Item does not provide part "HEAD"/"RFC822"
https://bugs.kde.org/show_bug.cgi?id=318290

I thought I better prove that my home BTRFS is correct.

On trying, I got this:

Apr 13 16:43:55 merkaba kernel: [   52.191224] btrfs: unable to find logical 12118427423283097349 len 16384
Apr 13 16:43:55 merkaba kernel: [   52.202277] ------------[ cut here ]------------
Apr 13 16:43:55 merkaba kernel: [   52.213522] kernel BUG at fs/btrfs/volumes.c:4417!
Apr 13 16:43:55 merkaba kernel: [   52.224288] invalid opcode: 0000 [#1] PREEMPT SMP 
Apr 13 16:43:55 merkaba kernel: [   52.234380] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables
 binfmt_misc cpufreq_userspace cpufreq_stats cpufreq_powersave nfnetlink_log cpufreq_conservative nfnetlink uinput nls_utf8 nls_cp437 vfat fat ext4
 crc16 jbd2 mbcache iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss psmouse snd_mixer_o
ss lpc_ich intel_powerclamp serio_raw pcspkr mfd_core i2c_i801 thinkpad_acpi snd_pcm battery iwlwifi snd_page_alloc tpm_tis nvram tpm ac tpm_bios c
fg80211 snd_seq_midi rfkill snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd mperf soundcore processor evdev joydev kvm_intel kv
m sbs sbshc coretemp hdaps(O) tp_smapi(O) thinkpad_ec(O) loop firewire_sbp2 fuse ecryptfs autofs4 btrfs xor zlib_deflate raid6_pq libcrc32c md_mod 
dm_mirror dm_region_hash dm_log dm_mod sg sd_mod sr_mod crc_t10dif cdrom hid_generic usbhid hid crc32_pclmul crc32c_intel ghash_clmulni_intel sdhc
Apr 13 16:43:55 merkaba kernel: i_pci sdhci ahci aesni_intel aes_x86_64 mmc_core xts lrw gf128mul ablk_helper cryptd sata_sil24 libahci thermal ehc
i_pci libata ehci_hcd microcode firewire_ohci e1000e scsi_mod firewire_core crc_itu_t ptp usbcore usb_common pps_core
Apr 13 16:43:55 merkaba kernel: [   52.328759] CPU 2 
Apr 13 16:43:55 merkaba kernel: [   52.328845] Pid: 961, comm: btrfs-endio-met Tainted: G           O 3.9.0-rc6-tp520+ #5 LENOVO 42433WG/42433WG
Apr 13 16:43:55 merkaba kernel: [   52.353047] RIP: 0010:[<ffffffffa029d7ff>]  [<ffffffffa029d7ff>] __btrfs_map_block+0x85/0xbb9 [btrfs]
Apr 13 16:43:55 merkaba kernel: [   52.365409] RSP: 0018:ffff88021359f998  EFLAGS: 00010296
Apr 13 16:43:55 merkaba kernel: [   52.377541] RAX: 000000000000003c RBX: ffff880210302118 RCX: ffff88021e28fb38
Apr 13 16:43:55 merkaba kernel: [   52.389608] RDX: 0000000000000000 RSI: ffff88021e28de38 RDI: 0000000000000246
Apr 13 16:43:55 merkaba kernel: [   52.401440] RBP: ffff88021359fa88 R08: 0000000000000000 R09: 0000000000000000
Apr 13 16:43:55 merkaba kernel: [   52.413284] R10: 00000000ffffffff R11: 0000000000000362 R12: a82d4d8909242f05
Apr 13 16:43:55 merkaba kernel: [   52.424989] R13: ffff880210302130 R14: ffff880210302000 R15: 0000000000000000
Apr 13 16:43:55 merkaba kernel: [   52.436868] FS:  0000000000000000(0000) GS:ffff88021e280000(0000) knlGS:0000000000000000
Apr 13 16:43:55 merkaba kernel: [   52.448924] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Apr 13 16:43:55 merkaba kernel: [   52.460976] CR2: ffffffffff600400 CR3: 0000000001a0c000 CR4: 00000000000407e0
Apr 13 16:43:55 merkaba kernel: [   52.472991] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Apr 13 16:43:55 merkaba kernel: [   52.484962] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Apr 13 16:43:55 merkaba kernel: [   52.496656] Process btrfs-endio-met (pid: 961, threadinfo ffff88021359e000, task ffff880213fe44d0)
Apr 13 16:43:55 merkaba kernel: [   52.508506] Stack:
Apr 13 16:43:55 merkaba kernel: [   52.520140]  ffff88021359f9d8 ffff88021359f9d8 ffffffff8106dcd6 0000000000000000
Apr 13 16:43:55 merkaba kernel: [   52.532065]  ffffffff81607630 ffff8802148fdbc0 ffff88021359fb40 ffff88020dba16f0
Apr 13 16:43:55 merkaba kernel: [   52.543923]  ffff88021359f9f8 ffffffff81067403 ffff88021e2d3d80 ffff88021e2d3d80
Apr 13 16:43:55 merkaba kernel: [   52.555787] Call Trace:
Apr 13 16:43:55 merkaba kernel: [   52.567494]  [<ffffffff8106dcd6>] ? update_rq_runnable_avg+0x15c/0x167
Apr 13 16:43:55 merkaba kernel: [   52.579295]  [<ffffffff81067403>] ? resched_task+0x43/0x62
Apr 13 16:43:55 merkaba kernel: [   52.590913]  [<ffffffff81064a36>] ? ttwu_stat+0x95/0xcd
Apr 13 16:43:55 merkaba kernel: [   52.602466]  [<ffffffffa02c5e07>] ? reada_add_block+0xbb/0x684 [btrfs]
Apr 13 16:43:55 merkaba kernel: [   52.613787]  [<ffffffffa02a18e8>] btrfs_map_block+0x15/0x17 [btrfs]
Apr 13 16:43:55 merkaba kernel: [   52.624937]  [<ffffffffa02c5e88>] reada_add_block+0x13c/0x684 [btrfs]
Apr 13 16:43:55 merkaba kernel: [   52.635913]  [<ffffffff8106ebf9>] ? check_preempt_wakeup+0x128/0x1e1
Apr 13 16:43:55 merkaba kernel: [   52.646865]  [<ffffffffa02c6692>] __readahead_hook.isra.4+0x2c2/0x3bc [btrfs]
Apr 13 16:43:55 merkaba kernel: [   52.657844]  [<ffffffffa02c6a68>] btree_readahead_hook+0x18/0x31 [btrfs]
Apr 13 16:43:55 merkaba kernel: [   52.668826]  [<ffffffffa027b412>] btree_readpage_end_io_hook+0x1a1/0x1f0 [btrfs]
Apr 13 16:43:55 merkaba kernel: [   52.679681]  [<ffffffff81064d21>] ? mmdrop+0x13/0x23
Apr 13 16:43:55 merkaba kernel: [   52.690535]  [<ffffffffa0298286>] end_bio_extent_readpage+0x145/0x76a [btrfs]
Apr 13 16:43:55 merkaba kernel: [   52.701378]  [<ffffffff81145060>] bio_endio+0x67/0x8f
Apr 13 16:43:55 merkaba kernel: [   52.712143]  [<ffffffffa027a1f3>] ? end_workqueue_fn+0x28/0x38 [btrfs]
Apr 13 16:43:55 merkaba kernel: [   52.722951]  [<ffffffffa027a1fe>] end_workqueue_fn+0x33/0x38 [btrfs]
Apr 13 16:43:55 merkaba kernel: [   52.733747]  [<ffffffffa02a508b>] worker_loop+0x16e/0x4af [btrfs]
Apr 13 16:43:55 merkaba kernel: [   52.744585]  [<ffffffffa02a4f1d>] ? btrfs_queue_worker+0x283/0x283 [btrfs]
Apr 13 16:43:55 merkaba kernel: [   52.755303]  [<ffffffff8105bf91>] kthread+0x88/0x90
Apr 13 16:43:55 merkaba kernel: [   52.765842]  [<ffffffff8105bf09>] ? __kthread_parkme+0x60/0x60
Apr 13 16:43:55 merkaba kernel: [   52.776376]  [<ffffffff814388fc>] ret_from_fork+0x7c/0xb0
Apr 13 16:43:55 merkaba kernel: [   52.786916]  [<ffffffff8105bf09>] ? __kthread_parkme+0x60/0x60
Apr 13 16:43:55 merkaba kernel: [   52.797149] Code: 70 ff ff ff e8 9b 63 19 e1 48 83 bd 70 ff ff ff 00 75 1a 48 8b 75 90 48 c7 c7 ac ed 2d a0 31 c0 48 8b 16 4c 89 e6 e8 d8 ed 18 e1 <0f> 0b 48 8b 95 70 ff ff ff 48 8b 42 18 4c 39 e0 77 0e 4c 8b 6a 
Apr 13 16:43:55 merkaba kernel: [   52.819046] RIP  [<ffffffffa029d7ff>] __btrfs_map_block+0x85/0xbb9 [btrfs]
Apr 13 16:43:55 merkaba kernel: [   52.829166]  RSP <ffff88021359f998>
Apr 13 16:43:55 merkaba kernel: [   52.838938] ---[ end trace a0105aa2812605a9 ]---


This is with:

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
f011a08c804d50eeff4abf2d308cdce492f015aa


I also got it with 3.8-trunk-amd64 Debian Kernel. This happens on a
ThinkPad T520 with Intel SSD 320.


btrfsck as of 

git://repo.or.cz/btrfs-progs-unstable/devel.git
8fc64cb11cd1e025357fec423445ceb0a35c3995

gives:

found 214751666176 bytes used err is 0
total csum bytes: 208227208
total tree bytes: 1469333504
total fs tree bytes: 1107738624
btree space waste bytes: 224600928
file data blocks allocated: 274189643776
 referenced 220317552640
Btrfs Btrfs v0.19


The newer btrfs check just gives this:

cat home-btrfs-check-2013-04-13.txt
checking extents
checking free space cache
btrfs: unable to add free space :-17
btrfs: free-space-cache.c:815: btrfs_add_free_space: Assertion `!(ret == -17)' failed.
Checking filesystem on /dev/merkaba/home
UUID: 1da2a1b8-[…]


The scrub consistently gets this after 3,93 GiB:

scrub status for 1da2a1b8-[…]
        scrub started at Sat Apr 13 16:43:38 2013, running for 20 seconds
        total bytes scrubbed: 3.93GB with 0 errors


So errors recorded so far:

merkaba:/var/tmp/btrfs-progs-integration#1> ./btrfs device stats /home
[/dev/mapper/merkaba-home].write_io_errs   0
[/dev/mapper/merkaba-home].read_io_errs    0
[/dev/mapper/merkaba-home].flush_io_errs   0
[/dev/mapper/merkaba-home].corruption_errs 0
[/dev/mapper/merkaba-home].generation_errs 0


Does my filesystem have a problem?

I did a rsync based backup today and this went without any errors. I did it
on tty1, so I would have noticed any kernel related errors, such as crc
ones.


Some sanity checking on the kernel log files:

merkaba:~> zgrep btrfs: /var/log/kern.log* | egrep -v "(disk space caching is enabled|use lzo compression|enabling auto defrag|unlinked.*orphans|relocating block group|found .* extents)"       
/var/log/kern.log:Apr 13 16:35:52 merkaba kernel: [58751.235249] btrfs: unable to find logical 13665438976774226374 len 16384
/var/log/kern.log:Apr 13 16:41:44 merkaba kernel: [  205.913664] btrfs: unable to find logical 5200868623701258288 len 16384
/var/log/kern.log:Apr 13 16:43:55 merkaba kernel: [   52.191224] btrfs: unable to find logical 12118427423283097349 len 16384
/var/log/kern.log:Apr 13 17:04:15 merkaba kernel: [  108.492228] btrfs: unable to find logical 7599900409826160776 len 16384
/var/log/kern.log.2.gz:Mar 27 20:11:15 merkaba kernel: [112646.479048] btrfs: run_one_delayed_ref returned -5
/var/log/kern.log.2.gz:Mar 27 20:11:15 merkaba kernel: [112646.479086] btrfs: Transaction aborted
/var/log/kern.log.2.gz:Mar 27 20:11:15 merkaba kernel: [112646.479458] btrfs: commit super ret -5
/var/log/kern.log.3.gz:Mar 19 22:57:31 merkaba kernel: [    5.055674] btrfs: truncated 1 orphans
/var/log/kern.log.3.gz:Mar 19 22:57:31 merkaba kernel: [    5.402142] btrfs: truncated 5 orphans

The Transaction about stuff was an external drive and is not related to my
home filesystem.

I will make a copy of those logs for further reference.


If you want to know anything else, please tell me. Please note however,
that during the next week I will play it safe. I will be in Berlin without
my backup drive with me. Since this is still somewhat a production laptop
and it happens in kernel 3.8 as well, a git bisect is out of question for me.
I could try with some older kernel however, say 3.7 or a newer one. But
well, I will play it safe this, unless I decide to replay backup anyway.

Ah, and this is a big metadata one:

merkaba:~> file -sk /dev/merkaba/home 
/dev/merkaba/home: symbolic link to `../dm-2'
merkaba:~> file -sk /dev/dm-2        
/dev/dm-2: sticky BTRFS Filesystem (label "home", sectorsize 4096, nodesize 16384, leafsize 16384)

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
