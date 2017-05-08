Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37664 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750786AbdEHSGB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 14:06:01 -0400
Received: by mail-wm0-f49.google.com with SMTP id m123so73698662wma.0
        for <linux-btrfs@vger.kernel.org>; Mon, 08 May 2017 11:06:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170508095820.633970a3@natsu>
References: <20170508095820.633970a3@natsu>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Mon, 8 May 2017 20:05:44 +0200
Message-ID: <CANznX5FbxnO66uqA=UK7h-f5MbnCR0zDMs6iYfyYidPZ7MyU9Q@mail.gmail.com>
Subject: Re: "corrupt leaf, invalid item offset size pair"
To: Roman Mamedov <rm@romanrm.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

May be someone more talented will be able to assist you but in my
experience this kind of damage is fatal in practice (even if you could
theoretically fix it, it's probably easier to recreate the fs and
restore the content from backup, or use the rescue tool to save some
of the old content which you never had copies from and restore that).
I think the problem is that the disturbed disk gets out of sync
(obviously, it misses some queued/buffered writes) from the rest of
the fs/disk(s) but later gets accepted back like it's in a perfectly
fine state (and/or Btrfs is ready to deal with problems like this,
though it looks like it is not), and then some fatal corruption starts
developing (due to the problematic disk being treated like it has
correct data, even though it has some errors). If you have it mounted
RW long enough, it will probably get worse and gets unmountable at
some point (and thus harder, if not impossible to rescure any data).
This is how I usually lost my RAID-5 mode Btrfs filesystems before I
stopped experimenting with that. I never had this problem since I
disabled SATA HotPlug (in the firmware setup of the motherboard) and
switched to RAID-10 mode (and eventually replaced both faulty SATA
cables in the system, one at a time after an incident...).

On Mon, May 8, 2017 at 6:58 AM, Roman Mamedov <rm@romanrm.net> wrote:
> Hello,
>
> It appears like during some trouble with HDD cables and controllers, I got some disk corruption.
> As a result, after a short period of time my Btrfs went read-only, and now does not mount anymore.
>
> [Sun May  7 23:08:02 2017] BTRFS error (device dm-8): parent transid verify failed on 13799442505728 wanted 625048 found 624487
> [Sun May  7 23:08:02 2017] BTRFS info (device dm-8): read error corrected: ino 1 off 13799442505728 (dev /dev/mapper/vg-r6p1 sector 6736670512)
> [Sun May  7 23:08:33 2017] BTRFS error (device dm-8): parent transid verify failed on 13799589576704 wanted 625088 found 624488
> [Sun May  7 23:08:33 2017] BTRFS error (device dm-8): parent transid verify failed on 13799589576704 wanted 625088 found 624402
> [Sun May  7 23:08:33 2017] ------------[ cut here ]------------
> [Sun May  7 23:08:33 2017] WARNING: CPU: 3 PID: 2022 at fs/btrfs/extent-tree.c:6555 __btrfs_free_extent.isra.67+0x2c2/0xd40 [btrfs]()
> [Sun May  7 23:08:33 2017] BTRFS: Transaction aborted (error -5)
> [Sun May  7 23:08:33 2017] Modules linked in: dm_mirror dm_region_hash dm_log ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_nat xt_limit xt_length nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack ip6t_rpfilter ipt_rpfilter xt_multiport iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip6table_raw iptable_raw ip6table_mangle iptable_mangle ip6table_filter ip6_tables iptable_filter ip_tables x_tables cpufreq_userspace cpufreq_conservative cpufreq_stats cpufreq_powersave nbd nfsd nfs_acl rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 dns_resolver nfs lockd grace sunrpc fscache 8021q garp mrp bridge stp llc bonding tcp_illinois aoe crc32 loop it87 hwmon_vid fuse kvm_amd kvm irqbypass crct10dif_pclmul eeepc_wmi crc32_pclmul ghash_clmulni_intel asus_wmi sparse_keymap rfkill
> [Sun May  7 23:08:33 2017]  video sha256_ssse3 sha256_generic hmac mxm_wmi drbg ansi_cprng snd_hda_codec_realtek aesni_intel snd_hda_codec_generic aes_x86_64 snd_hda_intel lrw gf128mul snd_hda_codec glue_helper snd_pcsp snd_hda_core ablk_helper snd_hwdep cryptd snd_pcm snd_timer cp210x joydev snd serio_raw k10temp evdev usbserial edac_mce_amd edac_core soundcore fam15h_power sp5100_tco acpi_cpufreq tpm_infineon wmi i2c_piix4 tpm_tis tpm 8250_fintek shpchp processor button ext4 crc16 mbcache jbd2 btrfs dm_cache_smq raid10 raid1 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq crc32c_generic md_mod dm_cache_mq dm_cache dm_persistent_data dm_bio_prison dm_bufio libcrc32c dm_mod sg sd_mod ata_generic hid_generic usbhid hid ohci_pci sata_mv ahci pata_jmicron libahci crc32c_intel sata_sil24
> [Sun May  7 23:08:33 2017]  ehci_pci ohci_hcd xhci_pci psmouse xhci_hcd ehci_hcd libata usbcore scsi_mod e1000e usb_common ptp pps_core
> [Sun May  7 23:08:33 2017] CPU: 3 PID: 2022 Comm: btrfs-transacti Not tainted 4.4.66-rm1+ #181
> [Sun May  7 23:08:33 2017] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 LE R2.0, BIOS 2601 03/24/2015
> [Sun May  7 23:08:33 2017]  0000000000000286 000000002595262f ffff8800d675baf0 ffffffff812ff351
> [Sun May  7 23:08:33 2017]  ffff8800d675bb38 ffffffffa03929d2 ffff8800d675bb28 ffffffff8107eb95
> [Sun May  7 23:08:33 2017]  00000c42b8ffb000 00000000fffffffb ffff8805b6c60800 0000000000000000
> [Sun May  7 23:08:33 2017] Call Trace:
> [Sun May  7 23:08:33 2017]  [<ffffffff812ff351>] dump_stack+0x63/0x82
> [Sun May  7 23:08:33 2017]  [<ffffffff8107eb95>] warn_slowpath_common+0x95/0xe0
> [Sun May  7 23:08:33 2017]  [<ffffffff8107ec3c>] warn_slowpath_fmt+0x5c/0x80
> [Sun May  7 23:08:33 2017]  [<ffffffffa02f0e52>] __btrfs_free_extent.isra.67+0x2c2/0xd40 [btrfs]
> [Sun May  7 23:08:33 2017]  [<ffffffffa035c1c7>] ? btrfs_merge_delayed_refs+0x67/0x610 [btrfs]
> [Sun May  7 23:08:33 2017]  [<ffffffffa02f54cc>] __btrfs_run_delayed_refs+0x99c/0x1260 [btrfs]
> [Sun May  7 23:08:33 2017]  [<ffffffff810b6a97>] ? dequeue_task_fair+0x597/0x870
> [Sun May  7 23:08:33 2017]  [<ffffffff810b5d12>] ? put_prev_entity+0x42/0x760
> [Sun May  7 23:08:33 2017]  [<ffffffffa02f8c0e>] btrfs_run_delayed_refs+0x7e/0x2b0 [btrfs]
> [Sun May  7 23:08:33 2017]  [<ffffffff810ea6c8>] ? del_timer_sync+0x48/0x50
> [Sun May  7 23:08:33 2017]  [<ffffffffa030e42d>] btrfs_commit_transaction+0x5d/0xa60 [btrfs]
> [Sun May  7 23:08:33 2017]  [<ffffffffa030eec9>] ? start_transaction+0x99/0x4d0 [btrfs]
> [Sun May  7 23:08:33 2017]  [<ffffffffa03098dc>] transaction_kthread+0x1dc/0x250 [btrfs]
> [Sun May  7 23:08:33 2017]  [<ffffffffa0309700>] ? btrfs_cleanup_transaction+0x560/0x560 [btrfs]
> [Sun May  7 23:08:33 2017]  [<ffffffff8109e13a>] kthread+0xfa/0x110
> [Sun May  7 23:08:33 2017]  [<ffffffff8109e040>] ? kthread_park+0x60/0x60
> [Sun May  7 23:08:33 2017]  [<ffffffff815c60cf>] ret_from_fork+0x3f/0x70
> [Sun May  7 23:08:33 2017]  [<ffffffff8109e040>] ? kthread_park+0x60/0x60
> [Sun May  7 23:08:33 2017] ---[ end trace 13439d259c35afcf ]---
> [Sun May  7 23:08:33 2017] BTRFS: error (device dm-8) in __btrfs_free_extent:6555: errno=-5 IO failure
> [Sun May  7 23:08:33 2017] BTRFS info (device dm-8): forced readonly
> [Sun May  7 23:08:33 2017] BTRFS: error (device dm-8) in btrfs_run_delayed_refs:2930: errno=-5 IO failure
> [Sun May  7 23:14:26 2017] BTRFS error (device dm-8): cleaner transaction attach returned -30
>
> Unmounted and trying to mount again:
>
> [Sun May  7 23:53:37 2017] BTRFS error (device dm-8): parent transid verify failed on 13799631413248 wanted 625091 found 624488
> [Sun May  7 23:53:37 2017] BTRFS critical (device dm-8): corrupt leaf, invalid item offset size pair: block=13799631413248,root=1, slot=0
> [Sun May  7 23:53:37 2017] BTRFS: Failed to read block groups: -5
> [Sun May  7 23:53:37 2017] BTRFS: open_ctree failed
>
> # btrfs-debug-tree -b 13799631413248 /dev/nbd7
> btrfs-progs v4.9.1
> parent transid verify failed on 13799631413248 wanted 625091 found 624488
> parent transid verify failed on 13799631413248 wanted 625091 found 624488
> parent transid verify failed on 13799631413248 wanted 625091 found 624488
> parent transid verify failed on 13799631413248 wanted 625091 found 624488
> Ignoring transid failure
> leaf parent key incorrect 13799631413248
> leaf 13799631413248 items 70 free space 1792 generation 624488 owner 2
> fs uuid f577dd93-84ef-4805-b6f9-c0835ae2519c
> chunk uuid 721ab016-5a11-4a13-9f4f-7289caa09528
>         item 0 key (8127633715200 SHARED_DATA_REF 20946085449728) itemoff 3991 itemsize 4
>                 shared data backref count 1
>         item 1 key (8127633715200 SHARED_DATA_REF 21519362891776) itemoff 3987 itemsize 4
>                 shared data backref count 1
>         item 2 key (8127633715200 SHARED_DATA_REF 21519599603712) itemoff 3983 itemsize 4
>                 shared data backref count 1
>         item 3 key (8127633715200 SHARED_DATA_REF 21519678705664) itemoff 3979 itemsize 4
>                 shared data backref count 1
>         item 4 key (8127633715200 SHARED_DATA_REF 21519750795264) itemoff 3975 itemsize 4
>                 shared data backref count 1
>         item 5 key (8127633715200 SHARED_DATA_REF 21519758098432) itemoff 3971 itemsize 4
>                 shared data backref count 1
>         item 6 key (8127633715200 SHARED_DATA_REF 21520049438720) itemoff 3967 itemsize 4
>                 shared data backref count 1
>         item 7 key (8127633715200 SHARED_DATA_REF 21520551002112) itemoff 3963 itemsize 4
>                 shared data backref count 1
>         item 8 key (8127633715200 SHARED_DATA_REF 21521762160640) itemoff 3959 itemsize 4
>                 shared data backref count 1
>         item 9 key (8127633715200 SHARED_DATA_REF 21522059493376) itemoff 3955 itemsize 4
>                 shared data backref count 1
>         item 10 key (8127633715200 SHARED_DATA_REF 21522089746432) itemoff 3951 itemsize 4
>                 shared data backref count 1
>         item 11 key (8127633715200 SHARED_DATA_REF 21522187358208) itemoff 3947 itemsize 4
>                 shared data backref count 1
>         item 12 key (8127633715200 SHARED_DATA_REF 21522194255872) itemoff 3943 itemsize 4
>                 shared data backref count 1
>         item 13 key (8127633715200 SHARED_DATA_REF 21522515390464) itemoff 3939 itemsize 4
>                 shared data backref count 1
>         item 14 key (8127633731584 EXTENT_ITEM 8192) itemoff 3886 itemsize 53
>                 extent refs 23 gen 612323 flags DATA
>                 extent data backref root 5134 objectid 3152643 offset 2015232 count 1
>         item 15 key (8127633731584 SHARED_DATA_REF 11213212483584) itemoff 3882 itemsize 4
>                 shared data backref count 1
>         item 16 key (8127633731584 SHARED_DATA_REF 11297611177984) itemoff 3878 itemsize 4
>                 shared data backref count 1
>         item 17 key (8127633731584 SHARED_DATA_REF 11298000412672) itemoff 3874 itemsize 4
>                 shared data backref count 1
>         item 18 key (8127633731584 SHARED_DATA_REF 11511996227584) itemoff 3870 itemsize 4
>                 shared data backref count 1
>         item 19 key (8127633731584 SHARED_DATA_REF 11512058925056) itemoff 3866 itemsize 4
>                 shared data backref count 1
>         item 20 key (8127633731584 SHARED_DATA_REF 12723035762688) itemoff 3862 itemsize 4
>                 shared data backref count 1
>         item 21 key (8127633731584 SHARED_DATA_REF 12723095769088) itemoff 3858 itemsize 4
>                 shared data backref count 1
>         item 22 key (8127633731584 SHARED_DATA_REF 13110340263936) itemoff 3854 itemsize 4
>                 shared data backref count 1
>         item 23 key (8127633731584 SHARED_DATA_REF 13531045240832) itemoff 3850 itemsize 4
>                 shared data backref count 1
>         item 24 key (8127633731584 SHARED_DATA_REF 13799248728064) itemoff 3846 itemsize 4
>                 shared data backref count 1
>         item 25 key (8127633731584 SHARED_DATA_REF 13828741074944) itemoff 3842 itemsize 4
>                 shared data backref count 1
>         item 26 key (8127633731584 SHARED_DATA_REF 13880030121984) itemoff 3838 itemsize 4
>                 shared data backref count 1
>         item 27 key (8127633731584 SHARED_DATA_REF 13880905883648) itemoff 3834 itemsize 4
>                 shared data backref count 1
>         item 28 key (8127633731584 SHARED_DATA_REF 13881540820992) itemoff 3830 itemsize 4
>                 shared data backref count 1
>         item 29 key (8127633731584 SHARED_DATA_REF 19115923763200) itemoff 3826 itemsize 4
>                 shared data backref count 1
>         item 30 key (8127633731584 SHARED_DATA_REF 19504403165184) itemoff 3822 itemsize 4
>                 shared data backref count 1
>         item 31 key (8127633731584 SHARED_DATA_REF 21519363059712) itemoff 3818 itemsize 4
>                 shared data backref count 1
>         item 32 key (8127633731584 SHARED_DATA_REF 21519646965760) itemoff 3814 itemsize 4
>                 shared data backref count 1
>         item 33 key (8127633731584 SHARED_DATA_REF 21519750897664) itemoff 3810 itemsize 4
>                 shared data backref count 1
>         item 34 key (8127633731584 SHARED_DATA_REF 21520050360320) itemoff 3806 itemsize 4
>                 shared data backref count 1
>         item 35 key (8127633731584 SHARED_DATA_REF 21522083491840) itemoff 3802 itemsize 4
>                 shared data backref count 1
>         item 36 key (8127633731584 SHARED_DATA_REF 21522188722176) itemoff 3798 itemsize 4
>                 shared data backref count 1
>         item 37 key (8127633772544 EXTENT_ITEM 4096) itemoff 3719 itemsize 79
>                 extent refs 3 gen 612323 flags DATA
>                 extent data backref root 5134 objectid 3152644 offset 1384448 count 1
>                 shared data backref parent 13880020971520 count 1
>                 shared data backref parent 13786852163584 count 1
>         item 38 key (8127633780736 EXTENT_ITEM 8192) itemoff 3666 itemsize 53
>                 extent refs 65 gen 612323 flags DATA
>                 extent data backref root 5134 objectid 3152644 offset 2707456 count 1
>         item 39 key (8127633780736 SHARED_DATA_REF 11213212332032) itemoff 3662 itemsize 4
>                 shared data backref count 1
>         item 40 key (8127633780736 SHARED_DATA_REF 11291294793728) itemoff 3658 itemsize 4
>                 shared data backref count 1
>         item 41 key (8127633780736 SHARED_DATA_REF 11297609768960) itemoff 3654 itemsize 4
>                 shared data backref count 1
>         item 42 key (8127633780736 SHARED_DATA_REF 11297674838016) itemoff 3650 itemsize 4
>                 shared data backref count 1
>         item 43 key (8127633780736 SHARED_DATA_REF 11297691869184) itemoff 3646 itemsize 4
>                 shared data backref count 1
>         item 44 key (8127633780736 SHARED_DATA_REF 11297997262848) itemoff 3642 itemsize 4
>                 shared data backref count 1
>         item 45 key (8127633780736 SHARED_DATA_REF 11511834492928) itemoff 3638 itemsize 4
>                 shared data backref count 1
>         item 46 key (8127633780736 SHARED_DATA_REF 11511995428864) itemoff 3634 itemsize 4
>                 shared data backref count 1
>         item 47 key (8127633780736 SHARED_DATA_REF 11512059453440) itemoff 3630 itemsize 4
>                 shared data backref count 1
>         item 48 key (8127633780736 SHARED_DATA_REF 11741499969536) itemoff 3626 itemsize 4
>                 shared data backref count 1
>         item 49 key (8127633780736 SHARED_DATA_REF 12557262172160) itemoff 3622 itemsize 4
>                 shared data backref count 1
>         item 50 key (8127633780736 SHARED_DATA_REF 12723035766784) itemoff 3618 itemsize 4
>                 shared data backref count 1
>         item 51 key (8127633780736 SHARED_DATA_REF 12723074371584) itemoff 3614 itemsize 4
>                 shared data backref count 1
>         item 52 key (8127633780736 SHARED_DATA_REF 12723085656064) itemoff 3610 itemsize 4
>                 shared data backref count 1
>         item 53 key (8127633780736 SHARED_DATA_REF 12723149246464) itemoff 3606 itemsize 4
>                 shared data backref count 1
>         item 54 key (8127633780736 SHARED_DATA_REF 12723194355712) itemoff 3602 itemsize 4
>                 shared data backref count 1
>         item 55 key (8127633780736 SHARED_DATA_REF 12723200917504) itemoff 3598 itemsize 4
>                 shared data backref count 1
>         item 56 key (8127633780736 SHARED_DATA_REF 13109964296192) itemoff 3594 itemsize 4
>                 shared data backref count 1
>         item 57 key (8127633780736 SHARED_DATA_REF 13110075899904) itemoff 3590 itemsize 4
>                 shared data backref count 1
>         item 58 key (8127633780736 SHARED_DATA_REF 13110340214784) itemoff 3586 itemsize 4
>                 shared data backref count 1
>         item 59 key (8127633780736 SHARED_DATA_REF 13476514705408) itemoff 3582 itemsize 4
>                 shared data backref count 1
>         item 60 key (8127633780736 SHARED_DATA_REF 13480430403584) itemoff 3578 itemsize 4
>                 shared data backref count 1
>         item 61 key (8127633780736 SHARED_DATA_REF 13480631832576) itemoff 3574 itemsize 4
>                 shared data backref count 1
>         item 62 key (8127633780736 SHARED_DATA_REF 13481065959424) itemoff 3570 itemsize 4
>                 shared data backref count 1
>         item 63 key (8127633780736 SHARED_DATA_REF 13531045257216) itemoff 3566 itemsize 4
>                 shared data backref count 1
>         item 64 key (8127633780736 SHARED_DATA_REF 13531228708864) itemoff 3562 itemsize 4
>                 shared data backref count 1
>         item 65 key (8127633780736 SHARED_DATA_REF 13787139198976) itemoff 3558 itemsize 4
>                 shared data backref count 1
>         item 66 key (8127633780736 SHARED_DATA_REF 13799249633280) itemoff 3554 itemsize 4
>                 shared data backref count 1
>         item 67 key (8127633780736 SHARED_DATA_REF 13799290990592) itemoff 3550 itemsize 4
>                 shared data backref count 1
>         item 68 key (8127633780736 SHARED_DATA_REF 13799711997952) itemoff 3546 itemsize 4
>                 shared data backref count 1
>         item 69 key (8127633780736 SHARED_DATA_REF 13800605405184) itemoff 3542 itemsize 4
>                 shared data backref count 1
>
>
> Btrfsck logs are attached (normal and lowmem).
>
> Is there any way to fix this?
>
> Thanks
>
> (sorry for a possible duplicate message)
>
> --
> With respect,
> Roman
