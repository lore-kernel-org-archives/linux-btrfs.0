Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36593 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755774AbcLXSDb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Dec 2016 13:03:31 -0500
Received: by mail-it0-f65.google.com with SMTP id n68so27570028itn.3
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Dec 2016 10:03:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOE4rSyfCg5CT3+_ip+pgfcXd9KvTLTfX2P2ea+e-feP_jN0pQ@mail.gmail.com>
References: <CAOE4rSyfCg5CT3+_ip+pgfcXd9KvTLTfX2P2ea+e-feP_jN0pQ@mail.gmail.com>
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Date: Sat, 24 Dec 2016 20:03:13 +0200
Message-ID: <CAOE4rSxONyMK5RJXV8Fngainb3vc=++HEi+DUcNX=1Fqb52HqA@mail.gmail.com>
Subject: Re: [BUG] kernel BUG at fs/btrfs/extent_io.c:2315 btrfs_check_repairable
 (v4.8.11)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-12-24 19:35 GMT+02:00 Dāvis Mosāns <davispuh@gmail.com>:
> btrfs scrub on two disk RAID1 btrfs partition with compression enabled
> causes kernel panic.

a bit different info

[ 1915.415566] BTRFS info (device sdn): csum failed ino 5590401 extent
821501775872 csum 516487097 wanted 4242536704 mirror 0
[ 1915.415629] BTRFS critical (device sdn): stripe index math went
horribly wrong, got stripe_index=2688743039, num_stripes=2
[ 1915.415734] BTRFS critical (device sdn): stripe index math went
horribly wrong, got stripe_index=2688743039, num_stripes=2
[ 1915.415739] BTRFS info (device sdn): csum failed ino 5590401 extent
2608597172224 csum 1578882010 wanted 4242536704 mirror -1606224256
[ 1915.415810] ------------[ cut here ]------------
[ 1915.415812] kernel BUG at /mnt/linux/fs/btrfs/extent_io.c:2315!
[ 1915.415814] invalid opcode: 0000 [#1] PREEMPT SMP
[ 1915.415839] Modules linked in: xt_CHECKSUM ipt_MASQUERADE
nf_nat_masquerade_ipv4 tun cfg80211 rfkill nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_CT xt_tcpudp ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
nfnetlink ebtable_broute ebtable_nat ip6table_mangle ip6table_security
ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_raw
iptable_mangle iptable_security iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw
ebtable_filter ebtables bridge ip6table_filter stp ip6_tables llc
iptable_filter it87 hwmon_vid saa7134_alsa saa7134 kvm_amd
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic kvm
tveeprom snd_hda_intel snd_usb_audio rc_core snd_hda_codec v4l2_common
irqbypass videobuf2_dma_sg snd_hda_core
[ 1915.415869]  snd_usbmidi_lib crct10dif_pclmul videobuf2_memops
mousedev crc32_pclmul snd_rawmidi joydev snd_hwdep snd_seq_device
videobuf2_v4l2 ghash_clmulni_intel videobuf2_core videodev evdev
snd_pcm aesni_intel aes_x86_64 snd_timer lrw gf128mul mxm_wmi mac_hid
media snd fam15h_power glue_helper ablk_helper pcspkr cryptd r8169 mii
k10temp soundcore acpi_cpufreq sp5100_tco tpm_infineon i2c_piix4
tpm_tis tpm_tis_core wmi shpchp button tpm nfsd auth_rpcgss
oid_registry nfs_acl sch_fq_codel lockd vboxnetflt(O) vboxnetadp(O)
pci_stub vboxpci(O) grace sunrpc vboxdrv(O) nvidia_uvm(PO) btrfs xor
zlib_deflate raid6_pq hid_generic usbhid hid sd_mod ata_generic
pata_acpi serio_raw atkbd libps2 ohci_pci nvidia_drm(PO)
nvidia_modeset(PO) nvidia(PO) firewire_ohci xhci_pci firewire_core
crc_itu_t ehci_pci xhci_hcd
[ 1915.415880]  ehci_hcd ohci_hcd drm_kms_helper syscopyarea
sysfillrect pata_atiixp sysimgblt fb_sys_fops ahci drm libahci usbcore
usb_common i2c_core i8042 serio mvsas libsas scsi_transport_sas libata
scsi_mod crc32c_generic crc32c_intel vfat fat ip_tables x_tables
[ 1915.415883] CPU: 4 PID: 2216 Comm: kworker/u16:14 Tainted: P
   O    4.8.11-ARCH-dirty #1
[ 1915.415884] Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
[ 1915.415911] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[ 1915.415912] task: ffff8806084ad580 task.stack: ffff88056f070000
[ 1915.415932] RIP: 0010:[<ffffffffa11b879c>]  [<ffffffffa11b879c>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[ 1915.415939] RSP: 0018:ffff88056f073cc0  EFLAGS: 00010206
[ 1915.415941] RAX: 0000000000000001 RBX: ffff8805adb7ac00 RCX: 0000000000000000
[ 1915.415942] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff88061180ef70
[ 1915.415943] RBP: ffff88056f073cd8 R08: 0000025f57c00000 R09: 0000025f97c00000
[ 1915.415944] R10: ffff8805c37bcc60 R11: 00000000a0610b40 R12: 00000000a0610b40
[ 1915.415946] R13: ffff8805a0610068 R14: ffff8805a0610068 R15: ffff88060f792c20
[ 1915.415947] FS:  0000000000000000(0000) GS:ffff88062ed00000(0000)
knlGS:0000000000000000
[ 1915.415949] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1915.415950] CR2: 0000559cf25b1000 CR3: 00000005f1f0a000 CR4: 00000000000406e0
[ 1915.415951] Stack:
[ 1915.415954]  ffffea0014692740 0000000000040000 ffff8805a06100f0
ffff88056f073d90
[ 1915.415956]  ffffffffa11b8cdf 00000001801c0017 ffff88056f073d10
ffff8806084ad580
[ 1915.415958]  ffff8806084ad580 ffff8805a0610000 ffff88060f792a70
0000000000000000
[ 1915.415959] Call Trace:
[ 1915.415981]  [<ffffffffa11b8cdf>] end_bio_extent_readpage+0x44f/0x5f0 [btrfs]
[ 1915.415987]  [<ffffffff812b0dc3>] bio_endio+0x53/0x60
[ 1915.416006]  [<ffffffffa118ba0c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[ 1915.416024]  [<ffffffffa11cae9d>] btrfs_scrubparity_helper+0x7d/0x340 [btrfs]
[ 1915.416043]  [<ffffffffa11cb24e>] btrfs_endio_helper+0xe/0x10 [btrfs]
[ 1915.416047]  [<ffffffff810951d5>] process_one_work+0x1e5/0x470
[ 1915.416049]  [<ffffffff810954a8>] worker_thread+0x48/0x4e0
[ 1915.416052]  [<ffffffff81095460>] ? process_one_work+0x470/0x470
[ 1915.416057]  [<ffffffff8109b118>] kthread+0xd8/0xf0
[ 1915.416061]  [<ffffffff8102d7b0>] ? __switch_to+0x300/0x720
[ 1915.416064]  [<ffffffff815cb4bf>] ret_from_fork+0x1f/0x40
[ 1915.416067]  [<ffffffff8109b040>] ? kthread_worker_fn+0x170/0x170
[ 1915.416092] Code: 25 89 4b 28 e9 7c ff ff ff 44 3b 63 28 75 1c c7
43 30 00 00 00 00 c7 43 28 00 00 00 00 b9 01 00 00 00 31 c0 eb d2 8d
48 02 eb d6 <0f> 0b 66 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55
41 54
[ 1915.416110] RIP  [<ffffffffa11b879c>]
btrfs_check_repairable+0xfc/0x100 [btrfs]
[ 1915.416117]  RSP <ffff88056f073cc0>
