Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from washoe.dartmouth.edu ([129.170.30.229]:58600 "EHLO
	smtp.onerussian.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485AbcHIWmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 18:42:38 -0400
Received: from smtp.onerussian.com ([192.168.100.6] helo=washoe.onerussian.com)
	by smtp.onerussian.com with esmtps (TLS1.2:RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <yoh@onerussian.com>)
	id 1bXFNI-0000iF-Fq
	for linux-btrfs@vger.kernel.org; Tue, 09 Aug 2016 18:19:52 -0400
Received: from yoh by washoe.onerussian.com with local (Exim 4.84)
	(envelope-from <yoh@onerussian.com>)
	id 1bXFNI-0000iA-29
	for linux-btrfs@vger.kernel.org; Tue, 09 Aug 2016 18:19:52 -0400
Date: Tue, 9 Aug 2016 18:19:52 -0400
From: Yaroslav Halchenko <yoh@onerussian.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: recent complete stalls of btrfs (4.7.0-rc2+) -- any advice?
Message-ID: <20160809221951.GA26923@onerussian.com>
References: <20160610234114.GB11174@onerussian.com>
 <CAJCQCtS1UTBx1-GELqUTbrdcxmncN3bv7X3OjGGrjvzom28m+w@mail.gmail.com>
 <20160612151531.GA28826@hopa.kiewit.dartmouth.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160612151531.GA28826@hopa.kiewit.dartmouth.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sun, 12 Jun 2016, Yaroslav Halchenko wrote:
> On Fri, 10 Jun 2016, Chris Murphy wrote:

> > > Are those issues something which was fixed since 4.6.0-rc4+ or I should
> > > be on look out for them to come back?  What other information should I
> > > provide if I run into them again to help you troubleshoot/fix it?

> > > P.S. Please CC me the replies


> > 4.6.2 is current and it's a lot easier to just use that and see if it
> > still happens than for someone to track down whether it's been fixed
> > since a six week old RC.

> Dear Chris,

> Thank you for the reply!  Now running v4.7-rc2-300-g3d0f0b6

> The thing is that this issue doesn't happen right away, and it takes a
> while for it to develop, and seems to be only after an intensive load.
> So the version I run will always be "X weeks old" if I just keep hopping
> the recent release of master, and it would be an indefinite goose
> chase if left un-analyzed.  That is why I would still appreciate an
> advice on what specifics to report/attempt if such crash happens next
> time, or may be if someone is having an idea of what could have lead to
> this crash to start with.

The beast has died on me today's morning :-/  Last kern.log msg was

    (Fixing recursive fault but reboot is needed!)

One of the tracebacks is the same as before (ending on
btrfs_commit_transaction), so I guess it could be the same issue as
before?  Most probably I will perform the same kernel build/upgrade dance
again BUT I still hope that someone might just either spot some sign of
recently (since v4.7-rc2-300-g3d0f0b6) fixed issue or, if not spotted, actually
looks in detail on possibly a new issue which wasn't addressed yet.  I would be
"happy" to provide more information or enable any necessary additional
monitoring to provide more information in case of the next crash.

I have rebooted the box around 11am, and it was completely unresponsive since
some time earlier but I think it still "somewhat functioned" after the last
traceback reported in the kern.log which I shared at
http://www.onerussian.com/tmp/kern-smaug-20160809.log otherwise journalctl -b
-1 doesn't show any other grave errors.   The very last oops in the kern.log I
also cite here.  Out of academic interest?  why seems to be ext4 functionality
within the stack for btrfs_commit_transaction?  is some logic common/reused
between the two file systems?  Or it is just a mere fact that some partitions
on ext4 and something in btrfs triggered them as well?

Aug  9 07:46:15 smaug kernel: [5132590.362689] Oops: 0000 [#3] SMP
Aug  9 07:46:15 smaug kernel: [5132590.367913] Modules linked in: uas usb_storage vboxdrv(O) nls_utf8 ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs veth xt_addrtype ipt_MASQUERADE nf_nat_masquerade_ipv4 bridge stp llc cpufreq_stats cpufreq_userspace cpufreq_conservative cpufreq_powersave xt_pkttype nf_log_ipv4 nf_log_common xt_tcpudp ip6table_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_TCPMSS xt_LOG ipt_REJECT nf_reject_ipv4 iptable_mangle xt_multiport xt_state xt_limit xt_conntrack nfsd nf_conntrack_ftp auth_rpcgss oid_registry nfs_acl nfs lockd grace nf_conntrack ip6table_filter ip6_tables iptable_filter ip_tables x_tables fscache sunrpc binfmt_misc intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp ipmi_watchdog ipmi_poweroff ipmi_devintf kvm_intel iTCO_wdt iTCO_vendor_support kvm irqbypass fuse crct10dif_pclmul crc32_pclmul ghash_clmulni_intel drbg ansi_cprng aesni_intel aes_x86_64 lrw gf128mul snd_pcm glue_helper ablk_helper cryptd snd_timer snd soundcore pcspkr evdev joydev ast ttm drm_kms_helper i2c_i801 drm i2c_algo_bit mei_me lpc_ich mfd_core mei ipmi_si ioatdma shpchp wmi ipmi_msghandler ecryptfs cbc tpm_tis tpm acpi_power_meter acpi_pad button sha256_ssse3 sha256_generic hmac encrypted_keys autofs4 ext4 crc16 jbd2 mbcache btrfs dm_mod raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 md_mod ses enclosure sg sd_mod hid_generic usbhid hid crc32c_intel mpt3sas raid_class scsi_transport_sas xhci_pci xhci_hcd ehci_pci ahci ehci_hcd libahci libata usbcore ixgbe scsi_mod usb_common dca ptp pps_core mdio fjes
Aug  9 07:46:15 smaug kernel: [5132590.538375] CPU: 6 PID: 2878531 Comm: git Tainted: G      D W IO    4.7.0-rc2+ #1
Aug  9 07:46:15 smaug kernel: [5132590.547950] Hardware name: Supermicro X10DRi/X10DRI-T, BIOS 1.0b 09/17/2014
Aug  9 07:46:15 smaug kernel: [5132590.557009] task: ffff8817b855b0c0 ti: ffff88000e0dc000 task.ti: ffff88000e0dc000
Aug  9 07:46:15 smaug kernel: [5132590.566572] RIP: 0010:[<ffffffffa0444be3>]  [<ffffffffa0444be3>] jbd2__journal_start+0x33/0x1e0 [jbd2]
Aug  9 07:46:15 smaug kernel: [5132590.578009] RSP: 0018:ffff88000e0df8f0  EFLAGS: 00010282
Aug  9 07:46:15 smaug kernel: [5132590.585427] RAX: ffff88155eae8140 RBX: ffff881ed5a9d128 RCX: 0000000002400040
Aug  9 07:46:15 smaug kernel: [5132590.594678] RDX: 00000000000fd0e4 RSI: 0000000000000002 RDI: ffff882034d0f000
Aug  9 07:46:15 smaug kernel: [5132590.603929] RBP: ffff882034d0f000 R08: 0000000000000001 R09: 0000000000001569
Aug  9 07:46:15 smaug kernel: [5132590.613264] R10: 00000000107aa8b7 R11: fffffffffffffff0 R12: ffff881ed5a9d128
Aug  9 07:46:15 smaug kernel: [5132590.622566] R13: ffff882033909000 R14: ffff881816302a00 R15: ffff881ed5a9d128
Aug  9 07:46:15 smaug kernel: [5132590.631846] FS:  0000000000000000(0000) GS:ffff88207fc80000(0000) knlGS:0000000000000000
Aug  9 07:46:15 smaug kernel: [5132590.642060] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Aug  9 07:46:15 smaug kernel: [5132590.649898] CR2: 00000000000fd0e4 CR3: 0000000001a06000 CR4: 00000000001406e0
Aug  9 07:46:15 smaug kernel: [5132590.659130] Stack:
Aug  9 07:46:15 smaug kernel: [5132590.663228]  ffffffffa049cc54 0000156902020200 ffff881ed5a9d128 0000000000000801
Aug  9 07:46:15 smaug kernel: [5132590.672811]  ffff881ed5a9d128 ffff882033909000 ffff881816302a00 ffff881ed5a9d128
Aug  9 07:46:15 smaug kernel: [5132590.682392]  ffffffffa0470b9d ffff881ed5a9d128 0000000000000801 ffffffff8121fe67
Aug  9 07:46:15 smaug kernel: [5132590.691981] Call Trace:
Aug  9 07:46:15 smaug kernel: [5132590.696597]  [<ffffffffa049cc54>] ? __ext4_journal_start_sb+0x34/0xf0 [ext4]
Aug  9 07:46:15 smaug kernel: [5132590.705791]  [<ffffffffa0470b9d>] ? ext4_dirty_inode+0x2d/0x60 [ext4]
Aug  9 07:46:15 smaug kernel: [5132590.714340]  [<ffffffff8121fe67>] ? __mark_inode_dirty+0x177/0x360
Aug  9 07:46:15 smaug kernel: [5132590.722623]  [<ffffffff8120e389>] ? generic_update_time+0x79/0xd0
Aug  9 07:46:15 smaug kernel: [5132590.730814]  [<ffffffff8120da8d>] ? file_update_time+0xbd/0x110
Aug  9 07:46:15 smaug kernel: [5132590.738845]  [<ffffffff81175f69>] ? __generic_file_write_iter+0x99/0x1e0
Aug  9 07:46:15 smaug kernel: [5132590.747708]  [<ffffffffa04631b6>] ? ext4_file_write_iter+0x196/0x3d0 [ext4]
Aug  9 07:46:15 smaug kernel: [5132590.756756]  [<ffffffff811f170b>] ? __vfs_write+0xeb/0x160
Aug  9 07:46:15 smaug kernel: [5132590.764301]  [<ffffffff811f2103>] ? __kernel_write+0x53/0x100
Aug  9 07:46:15 smaug kernel: [5132590.772081]  [<ffffffff810ff672>] ? do_acct_process+0x462/0x4e0
Aug  9 07:46:15 smaug kernel: [5132590.780035]  [<ffffffff810ffd4c>] ? acct_process+0xdc/0x100
Aug  9 07:46:15 smaug kernel: [5132590.787648]  [<ffffffff8107e403>] ? do_exit+0x7f3/0xb80
Aug  9 07:46:15 smaug kernel: [5132590.794894]  [<ffffffff8102fa5c>] ? oops_end+0x9c/0xd0
Aug  9 07:46:15 smaug kernel: [5132590.802027]  [<ffffffff81062d35>] ? no_context+0x135/0x390
Aug  9 07:46:15 smaug kernel: [5132590.809496]  [<ffffffff815ca1f8>] ? page_fault+0x28/0x30
Aug  9 07:46:15 smaug kernel: [5132590.816808]  [<ffffffffa0381af0>] ? btrfs_commit_transaction+0x350/0xa30 [btrfs]
Aug  9 07:46:15 smaug kernel: [5132590.826213]  [<ffffffff810ba590>] ? wait_woken+0x90/0x90
Aug  9 07:46:15 smaug kernel: [5132590.833501]  [<ffffffffa039a11b>] ? btrfs_sync_file+0x2fb/0x3e0 [btrfs]
Aug  9 07:46:15 smaug kernel: [5132590.842074]  [<ffffffff81225318>] ? do_fsync+0x38/0x60
Aug  9 07:46:15 smaug kernel: [5132590.849114]  [<ffffffff8122558c>] ? SyS_fsync+0xc/0x10
Aug  9 07:46:15 smaug kernel: [5132590.856096]  [<ffffffff815c81f6>] ? entry_SYSCALL_64_fastpath+0x1e/0xa8
Aug  9 07:46:15 smaug kernel: [5132590.864522] Code: 56 41 55 41 54 55 53 48 89 fd 65 48 8b 04 25 c0 d4 00 00 48 83 ec 10 48 85 ff 48 8b 80 90 06 00 00 74 20 48 85 c0 74 33 48 8b 10 <48> 3b 3a 75 29 83 40 14 01 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e
Aug  9 07:46:15 smaug kernel: [5132590.888065] RIP  [<ffffffffa0444be3>] jbd2__journal_start+0x33/0x1e0 [jbd2]
Aug  9 07:46:15 smaug kernel: [5132590.896830]  RSP <ffff88000e0df8f0>
Aug  9 07:46:15 smaug kernel: [5132590.902039] CR2: 00000000000fd0e4
Aug  9 07:46:15 smaug kernel: [5132590.907032] ---[ end trace 3b9450d000ed06b4 ]---
Aug  9 07:46:15 smaug kernel: [5132590.914612] Fixing recursive fault but reboot is needed!

Thank you very much in advance for any ideas/feedback.  

Please CC me the responses
-- 
Yaroslav O. Halchenko
Center for Open Neuroscience     http://centerforopenneuroscience.org
Dartmouth College, 419 Moore Hall, Hinman Box 6207, Hanover, NH 03755
Phone: +1 (603) 646-9834                       Fax: +1 (603) 646-1419
WWW:   http://www.linkedin.com/in/yarik        
