Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:34706 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751531AbdEHE6W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 May 2017 00:58:22 -0400
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
        by rin.romanrm.net (Postfix) with SMTP id C1F16180CBD79
        for <linux-btrfs@vger.kernel.org>; Mon,  8 May 2017 04:58:20 +0000 (UTC)
Date: Mon, 8 May 2017 09:58:20 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: "corrupt leaf, invalid item offset size pair"
Message-ID: <20170508095820.633970a3@natsu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/F9WtXJU85fz/h1+G7nLtZUW"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--MP_/F9WtXJU85fz/h1+G7nLtZUW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

It appears like during some trouble with HDD cables and controllers, I got some disk corruption.
As a result, after a short period of time my Btrfs went read-only, and now does not mount anymore.

[Sun May  7 23:08:02 2017] BTRFS error (device dm-8): parent transid verify failed on 13799442505728 wanted 625048 found 624487
[Sun May  7 23:08:02 2017] BTRFS info (device dm-8): read error corrected: ino 1 off 13799442505728 (dev /dev/mapper/vg-r6p1 sector 6736670512)
[Sun May  7 23:08:33 2017] BTRFS error (device dm-8): parent transid verify failed on 13799589576704 wanted 625088 found 624488
[Sun May  7 23:08:33 2017] BTRFS error (device dm-8): parent transid verify failed on 13799589576704 wanted 625088 found 624402
[Sun May  7 23:08:33 2017] ------------[ cut here ]------------
[Sun May  7 23:08:33 2017] WARNING: CPU: 3 PID: 2022 at fs/btrfs/extent-tree.c:6555 __btrfs_free_extent.isra.67+0x2c2/0xd40 [btrfs]()
[Sun May  7 23:08:33 2017] BTRFS: Transaction aborted (error -5)
[Sun May  7 23:08:33 2017] Modules linked in: dm_mirror dm_region_hash dm_log ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_nat xt_limit xt_length nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack ip6t_rpfilter ipt_rpfilter xt_multiport iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip6table_raw iptable_raw ip6table_mangle iptable_mangle ip6table_filter ip6_tables iptable_filter ip_tables x_tables cpufreq_userspace cpufreq_conservative cpufreq_stats cpufreq_powersave nbd nfsd nfs_acl rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache 8021q garp mrp bridge stp llc bonding tcp_illinois aoe crc32 loop it87 hwmon_vid fuse kvm_amd kvm irqbypass crct10dif_pclmul eeepc_wmi crc32_pclmul ghash_clmulni_intel asus_wmi sparse_keymap rfkill
[Sun May  7 23:08:33 2017]  video sha256_ssse3 sha256_generic hmac mxm_wmi drbg ansi_cprng snd_hda_codec_realtek aesni_intel snd_hda_codec_generic aes_x86_64 snd_hda_intel lrw gf128mul snd_hda_codec glue_helper snd_pcsp snd_hda_core ablk_helper snd_hwdep cryptd snd_pcm snd_timer cp210x joydev snd serio_raw k10temp evdev usbserial edac_mce_amd edac_core soundcore fam15h_power sp5100_tco acpi_cpufreq tpm_infineon wmi i2c_piix4 tpm_tis tpm 8250_fintek shpchp processor button ext4 crc16 mbcache jbd2 btrfs dm_cache_smq raid10 raid1 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq crc32c_generic md_mod dm_cache_mq dm_cache dm_persistent_data dm_bio_prison dm_bufio libcrc32c dm_mod sg sd_mod ata_generic hid_generic usbhid hid ohci_pci sata_mv ahci pata_jmicron libahci crc32c_intel sata_sil24
[Sun May  7 23:08:33 2017]  ehci_pci ohci_hcd xhci_pci psmouse xhci_hcd ehci_hcd libata usbcore scsi_mod e1000e usb_common ptp pps_core
[Sun May  7 23:08:33 2017] CPU: 3 PID: 2022 Comm: btrfs-transacti Not tainted 4.4.66-rm1+ #181
[Sun May  7 23:08:33 2017] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 LE R2.0, BIOS 2601 03/24/2015
[Sun May  7 23:08:33 2017]  0000000000000286 000000002595262f ffff8800d675baf0 ffffffff812ff351
[Sun May  7 23:08:33 2017]  ffff8800d675bb38 ffffffffa03929d2 ffff8800d675bb28 ffffffff8107eb95
[Sun May  7 23:08:33 2017]  00000c42b8ffb000 00000000fffffffb ffff8805b6c60800 0000000000000000
[Sun May  7 23:08:33 2017] Call Trace:
[Sun May  7 23:08:33 2017]  [<ffffffff812ff351>] dump_stack+0x63/0x82
[Sun May  7 23:08:33 2017]  [<ffffffff8107eb95>] warn_slowpath_common+0x95/0xe0
[Sun May  7 23:08:33 2017]  [<ffffffff8107ec3c>] warn_slowpath_fmt+0x5c/0x80
[Sun May  7 23:08:33 2017]  [<ffffffffa02f0e52>] __btrfs_free_extent.isra.67+0x2c2/0xd40 [btrfs]
[Sun May  7 23:08:33 2017]  [<ffffffffa035c1c7>] ? btrfs_merge_delayed_refs+0x67/0x610 [btrfs]
[Sun May  7 23:08:33 2017]  [<ffffffffa02f54cc>] __btrfs_run_delayed_refs+0x99c/0x1260 [btrfs]
[Sun May  7 23:08:33 2017]  [<ffffffff810b6a97>] ? dequeue_task_fair+0x597/0x870
[Sun May  7 23:08:33 2017]  [<ffffffff810b5d12>] ? put_prev_entity+0x42/0x760
[Sun May  7 23:08:33 2017]  [<ffffffffa02f8c0e>] btrfs_run_delayed_refs+0x7e/0x2b0 [btrfs]
[Sun May  7 23:08:33 2017]  [<ffffffff810ea6c8>] ? del_timer_sync+0x48/0x50
[Sun May  7 23:08:33 2017]  [<ffffffffa030e42d>] btrfs_commit_transaction+0x5d/0xa60 [btrfs]
[Sun May  7 23:08:33 2017]  [<ffffffffa030eec9>] ? start_transaction+0x99/0x4d0 [btrfs]
[Sun May  7 23:08:33 2017]  [<ffffffffa03098dc>] transaction_kthread+0x1dc/0x250 [btrfs]
[Sun May  7 23:08:33 2017]  [<ffffffffa0309700>] ? btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[Sun May  7 23:08:33 2017]  [<ffffffff8109e13a>] kthread+0xfa/0x110
[Sun May  7 23:08:33 2017]  [<ffffffff8109e040>] ? kthread_park+0x60/0x60
[Sun May  7 23:08:33 2017]  [<ffffffff815c60cf>] ret_from_fork+0x3f/0x70
[Sun May  7 23:08:33 2017]  [<ffffffff8109e040>] ? kthread_park+0x60/0x60
[Sun May  7 23:08:33 2017] ---[ end trace 13439d259c35afcf ]---
[Sun May  7 23:08:33 2017] BTRFS: error (device dm-8) in __btrfs_free_extent:6555: errno=-5 IO failure
[Sun May  7 23:08:33 2017] BTRFS info (device dm-8): forced readonly
[Sun May  7 23:08:33 2017] BTRFS: error (device dm-8) in btrfs_run_delayed_refs:2930: errno=-5 IO failure
[Sun May  7 23:14:26 2017] BTRFS error (device dm-8): cleaner transaction attach returned -30

Unmounted and trying to mount again:

[Sun May  7 23:53:37 2017] BTRFS error (device dm-8): parent transid verify failed on 13799631413248 wanted 625091 found 624488
[Sun May  7 23:53:37 2017] BTRFS critical (device dm-8): corrupt leaf, invalid item offset size pair: block=13799631413248,root=1, slot=0
[Sun May  7 23:53:37 2017] BTRFS: Failed to read block groups: -5
[Sun May  7 23:53:37 2017] BTRFS: open_ctree failed

# btrfs-debug-tree -b 13799631413248 /dev/nbd7 
btrfs-progs v4.9.1
parent transid verify failed on 13799631413248 wanted 625091 found 624488
parent transid verify failed on 13799631413248 wanted 625091 found 624488
parent transid verify failed on 13799631413248 wanted 625091 found 624488
parent transid verify failed on 13799631413248 wanted 625091 found 624488
Ignoring transid failure
leaf parent key incorrect 13799631413248
leaf 13799631413248 items 70 free space 1792 generation 624488 owner 2
fs uuid f577dd93-84ef-4805-b6f9-c0835ae2519c
chunk uuid 721ab016-5a11-4a13-9f4f-7289caa09528
	item 0 key (8127633715200 SHARED_DATA_REF 20946085449728) itemoff 3991 itemsize 4
		shared data backref count 1
	item 1 key (8127633715200 SHARED_DATA_REF 21519362891776) itemoff 3987 itemsize 4
		shared data backref count 1
	item 2 key (8127633715200 SHARED_DATA_REF 21519599603712) itemoff 3983 itemsize 4
		shared data backref count 1
	item 3 key (8127633715200 SHARED_DATA_REF 21519678705664) itemoff 3979 itemsize 4
		shared data backref count 1
	item 4 key (8127633715200 SHARED_DATA_REF 21519750795264) itemoff 3975 itemsize 4
		shared data backref count 1
	item 5 key (8127633715200 SHARED_DATA_REF 21519758098432) itemoff 3971 itemsize 4
		shared data backref count 1
	item 6 key (8127633715200 SHARED_DATA_REF 21520049438720) itemoff 3967 itemsize 4
		shared data backref count 1
	item 7 key (8127633715200 SHARED_DATA_REF 21520551002112) itemoff 3963 itemsize 4
		shared data backref count 1
	item 8 key (8127633715200 SHARED_DATA_REF 21521762160640) itemoff 3959 itemsize 4
		shared data backref count 1
	item 9 key (8127633715200 SHARED_DATA_REF 21522059493376) itemoff 3955 itemsize 4
		shared data backref count 1
	item 10 key (8127633715200 SHARED_DATA_REF 21522089746432) itemoff 3951 itemsize 4
		shared data backref count 1
	item 11 key (8127633715200 SHARED_DATA_REF 21522187358208) itemoff 3947 itemsize 4
		shared data backref count 1
	item 12 key (8127633715200 SHARED_DATA_REF 21522194255872) itemoff 3943 itemsize 4
		shared data backref count 1
	item 13 key (8127633715200 SHARED_DATA_REF 21522515390464) itemoff 3939 itemsize 4
		shared data backref count 1
	item 14 key (8127633731584 EXTENT_ITEM 8192) itemoff 3886 itemsize 53
		extent refs 23 gen 612323 flags DATA
		extent data backref root 5134 objectid 3152643 offset 2015232 count 1
	item 15 key (8127633731584 SHARED_DATA_REF 11213212483584) itemoff 3882 itemsize 4
		shared data backref count 1
	item 16 key (8127633731584 SHARED_DATA_REF 11297611177984) itemoff 3878 itemsize 4
		shared data backref count 1
	item 17 key (8127633731584 SHARED_DATA_REF 11298000412672) itemoff 3874 itemsize 4
		shared data backref count 1
	item 18 key (8127633731584 SHARED_DATA_REF 11511996227584) itemoff 3870 itemsize 4
		shared data backref count 1
	item 19 key (8127633731584 SHARED_DATA_REF 11512058925056) itemoff 3866 itemsize 4
		shared data backref count 1
	item 20 key (8127633731584 SHARED_DATA_REF 12723035762688) itemoff 3862 itemsize 4
		shared data backref count 1
	item 21 key (8127633731584 SHARED_DATA_REF 12723095769088) itemoff 3858 itemsize 4
		shared data backref count 1
	item 22 key (8127633731584 SHARED_DATA_REF 13110340263936) itemoff 3854 itemsize 4
		shared data backref count 1
	item 23 key (8127633731584 SHARED_DATA_REF 13531045240832) itemoff 3850 itemsize 4
		shared data backref count 1
	item 24 key (8127633731584 SHARED_DATA_REF 13799248728064) itemoff 3846 itemsize 4
		shared data backref count 1
	item 25 key (8127633731584 SHARED_DATA_REF 13828741074944) itemoff 3842 itemsize 4
		shared data backref count 1
	item 26 key (8127633731584 SHARED_DATA_REF 13880030121984) itemoff 3838 itemsize 4
		shared data backref count 1
	item 27 key (8127633731584 SHARED_DATA_REF 13880905883648) itemoff 3834 itemsize 4
		shared data backref count 1
	item 28 key (8127633731584 SHARED_DATA_REF 13881540820992) itemoff 3830 itemsize 4
		shared data backref count 1
	item 29 key (8127633731584 SHARED_DATA_REF 19115923763200) itemoff 3826 itemsize 4
		shared data backref count 1
	item 30 key (8127633731584 SHARED_DATA_REF 19504403165184) itemoff 3822 itemsize 4
		shared data backref count 1
	item 31 key (8127633731584 SHARED_DATA_REF 21519363059712) itemoff 3818 itemsize 4
		shared data backref count 1
	item 32 key (8127633731584 SHARED_DATA_REF 21519646965760) itemoff 3814 itemsize 4
		shared data backref count 1
	item 33 key (8127633731584 SHARED_DATA_REF 21519750897664) itemoff 3810 itemsize 4
		shared data backref count 1
	item 34 key (8127633731584 SHARED_DATA_REF 21520050360320) itemoff 3806 itemsize 4
		shared data backref count 1
	item 35 key (8127633731584 SHARED_DATA_REF 21522083491840) itemoff 3802 itemsize 4
		shared data backref count 1
	item 36 key (8127633731584 SHARED_DATA_REF 21522188722176) itemoff 3798 itemsize 4
		shared data backref count 1
	item 37 key (8127633772544 EXTENT_ITEM 4096) itemoff 3719 itemsize 79
		extent refs 3 gen 612323 flags DATA
		extent data backref root 5134 objectid 3152644 offset 1384448 count 1
		shared data backref parent 13880020971520 count 1
		shared data backref parent 13786852163584 count 1
	item 38 key (8127633780736 EXTENT_ITEM 8192) itemoff 3666 itemsize 53
		extent refs 65 gen 612323 flags DATA
		extent data backref root 5134 objectid 3152644 offset 2707456 count 1
	item 39 key (8127633780736 SHARED_DATA_REF 11213212332032) itemoff 3662 itemsize 4
		shared data backref count 1
	item 40 key (8127633780736 SHARED_DATA_REF 11291294793728) itemoff 3658 itemsize 4
		shared data backref count 1
	item 41 key (8127633780736 SHARED_DATA_REF 11297609768960) itemoff 3654 itemsize 4
		shared data backref count 1
	item 42 key (8127633780736 SHARED_DATA_REF 11297674838016) itemoff 3650 itemsize 4
		shared data backref count 1
	item 43 key (8127633780736 SHARED_DATA_REF 11297691869184) itemoff 3646 itemsize 4
		shared data backref count 1
	item 44 key (8127633780736 SHARED_DATA_REF 11297997262848) itemoff 3642 itemsize 4
		shared data backref count 1
	item 45 key (8127633780736 SHARED_DATA_REF 11511834492928) itemoff 3638 itemsize 4
		shared data backref count 1
	item 46 key (8127633780736 SHARED_DATA_REF 11511995428864) itemoff 3634 itemsize 4
		shared data backref count 1
	item 47 key (8127633780736 SHARED_DATA_REF 11512059453440) itemoff 3630 itemsize 4
		shared data backref count 1
	item 48 key (8127633780736 SHARED_DATA_REF 11741499969536) itemoff 3626 itemsize 4
		shared data backref count 1
	item 49 key (8127633780736 SHARED_DATA_REF 12557262172160) itemoff 3622 itemsize 4
		shared data backref count 1
	item 50 key (8127633780736 SHARED_DATA_REF 12723035766784) itemoff 3618 itemsize 4
		shared data backref count 1
	item 51 key (8127633780736 SHARED_DATA_REF 12723074371584) itemoff 3614 itemsize 4
		shared data backref count 1
	item 52 key (8127633780736 SHARED_DATA_REF 12723085656064) itemoff 3610 itemsize 4
		shared data backref count 1
	item 53 key (8127633780736 SHARED_DATA_REF 12723149246464) itemoff 3606 itemsize 4
		shared data backref count 1
	item 54 key (8127633780736 SHARED_DATA_REF 12723194355712) itemoff 3602 itemsize 4
		shared data backref count 1
	item 55 key (8127633780736 SHARED_DATA_REF 12723200917504) itemoff 3598 itemsize 4
		shared data backref count 1
	item 56 key (8127633780736 SHARED_DATA_REF 13109964296192) itemoff 3594 itemsize 4
		shared data backref count 1
	item 57 key (8127633780736 SHARED_DATA_REF 13110075899904) itemoff 3590 itemsize 4
		shared data backref count 1
	item 58 key (8127633780736 SHARED_DATA_REF 13110340214784) itemoff 3586 itemsize 4
		shared data backref count 1
	item 59 key (8127633780736 SHARED_DATA_REF 13476514705408) itemoff 3582 itemsize 4
		shared data backref count 1
	item 60 key (8127633780736 SHARED_DATA_REF 13480430403584) itemoff 3578 itemsize 4
		shared data backref count 1
	item 61 key (8127633780736 SHARED_DATA_REF 13480631832576) itemoff 3574 itemsize 4
		shared data backref count 1
	item 62 key (8127633780736 SHARED_DATA_REF 13481065959424) itemoff 3570 itemsize 4
		shared data backref count 1
	item 63 key (8127633780736 SHARED_DATA_REF 13531045257216) itemoff 3566 itemsize 4
		shared data backref count 1
	item 64 key (8127633780736 SHARED_DATA_REF 13531228708864) itemoff 3562 itemsize 4
		shared data backref count 1
	item 65 key (8127633780736 SHARED_DATA_REF 13787139198976) itemoff 3558 itemsize 4
		shared data backref count 1
	item 66 key (8127633780736 SHARED_DATA_REF 13799249633280) itemoff 3554 itemsize 4
		shared data backref count 1
	item 67 key (8127633780736 SHARED_DATA_REF 13799290990592) itemoff 3550 itemsize 4
		shared data backref count 1
	item 68 key (8127633780736 SHARED_DATA_REF 13799711997952) itemoff 3546 itemsize 4
		shared data backref count 1
	item 69 key (8127633780736 SHARED_DATA_REF 13800605405184) itemoff 3542 itemsize 4
		shared data backref count 1


Btrfsck logs are attached (normal and lowmem).

Is there any way to fix this?

Thanks

(sorry for a possible duplicate message)

-- 
With respect,
Roman

--MP_/F9WtXJU85fz/h1+G7nLtZUW
Content-Type: application/x-bzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=btrfsck.txt.bz2

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

--MP_/F9WtXJU85fz/h1+G7nLtZUW
Content-Type: application/x-bzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=btrfsck-lowmem.txt.bz2

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
i7kinChIUEUl3wA=

--MP_/F9WtXJU85fz/h1+G7nLtZUW--
