Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:43909 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaEBLNr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 May 2014 07:13:47 -0400
Received: by mail-qa0-f49.google.com with SMTP id cm18so3008786qab.8
        for <linux-btrfs@vger.kernel.org>; Fri, 02 May 2014 04:13:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOwjQU4GP5PjdPZx8HPihS7GQOA74M+DexwMWoh1FOQP0tCTcw@mail.gmail.com>
References: <CAOwjQU4GP5PjdPZx8HPihS7GQOA74M+DexwMWoh1FOQP0tCTcw@mail.gmail.com>
Date: Fri, 2 May 2014 19:13:46 +0800
Message-ID: <CAP9B-Q=GBUSx-MAwx=QQ5hMwAcCAS3GJCZ3g_u5snDkWfaq-Hg@mail.gmail.com>
Subject: Re: "csum failed" that was not detected by scrub
From: Shilong Wang <wangshilong1991@gmail.com>
To: Jaap Pieroen <jaap@pieroen.nl>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,


2014-05-02 17:42 GMT+08:00 Jaap Pieroen <jaap@pieroen.nl>:
> Hi all,
>
> I completed a full scrub:
> root@nasbak:/home/jpieroen# btrfs scrub status /home/
> scrub status for 7ca5f38e-308f-43ab-b3ea-31b3bcd11a0d
> scrub started at Wed Apr 30 08:30:19 2014 and finished after 144131 seconds
> total bytes scrubbed: 4.76TiB with 0 errors
>
> Then tried to remove a device:
> root@nasbak:/home/jpieroen# btrfs device delete /dev/sdb /home
>
> This triggered bug_on, with the following error in dmesg: csum failed
> ino 258 off 1395560448 csum 2284440321 expected csum 319628859
>
> How can there still be csum failures directly after a scrub?
> If I rerun the scrub it still won't find any errors. I know this,
> because I've had the same issue 3 times in a row. Each time running a
> scrub and still being unable to remove the device.

There is a known RAID5/6 bug, i sent a patch to address this problem.
Could you please double check if your kernel source includes the
following commit:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=3b080b2564287be91605bfd1d5ee985696e61d3c

RAID5/6 should detect checksum mismatch, it can not fix errors now.

Thanks,
Wang
>
> Kind Regards,
> Jaap
>
> --------------------------------------------------------------
> Details:
>
> root@nasbak:/home/jpieroen#   uname -a
> Linux nasbak 3.14.1-031401-generic #201404141220 SMP Mon Apr 14
> 16:21:48 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>
> root@nasbak:/home/jpieroen#   btrfs --version
> Btrfs v3.14.1
>
> root@nasbak:/home/jpieroen#   btrfs fi df /home
> Data, RAID5: total=4.57TiB, used=4.55TiB
> System, RAID1: total=32.00MiB, used=352.00KiB
> Metadata, RAID1: total=7.00GiB, used=5.59GiB
>
> root@nasbak:/home/jpieroen# btrfs fi show
> Label: 'btrfs_storage'  uuid: 7ca5f38e-308f-43ab-b3ea-31b3bcd11a0d
> Total devices 6 FS bytes used 4.56TiB
> devid    1 size 1.82TiB used 1.31TiB path /dev/sde
> devid    2 size 1.82TiB used 1.31TiB path /dev/sdf
> devid    3 size 1.82TiB used 1.31TiB path /dev/sdg
> devid    4 size 931.51GiB used 25.00GiB path /dev/sdb
> devid    6 size 2.73TiB used 994.03GiB path /dev/sdh
> devid    7 size 2.73TiB used 994.03GiB path /dev/sdi
>
> Btrfs v3.14.1
>
> jpieroen@nasbak:~$ dmesg
> [227248.656438] BTRFS info (device sdi): relocating block group
> 9735225016320 flags 129
> [227261.713860] BTRFS info (device sdi): found 9 extents
> [227264.531019] BTRFS info (device sdi): found 9 extents
> [227265.011826] BTRFS info (device sdi): relocating block group
> 76265029632 flags 129
> [227274.052249] BTRFS info (device sdi): csum failed ino 258 off
> 1395560448 csum 2284440321 expected csum 319628859
> [227274.052354] BTRFS info (device sdi): csum failed ino 258 off
> 1395564544 csum 3646299263 expected csum 319628859
> [227274.052402] BTRFS info (device sdi): csum failed ino 258 off
> 1395568640 csum 281259278 expected csum 319628859
> [227274.052449] BTRFS info (device sdi): csum failed ino 258 off
> 1395572736 csum 2594807184 expected csum 319628859
> [227274.052492] BTRFS info (device sdi): csum failed ino 258 off
> 1395576832 csum 4288971971 expected csum 319628859
> [227274.052537] BTRFS info (device sdi): csum failed ino 258 off
> 1395580928 csum 752615894 expected csum 319628859
> [227274.052581] BTRFS info (device sdi): csum failed ino 258 off
> 1395585024 csum 3828951500 expected csum 319628859
> [227274.061279] ------------[ cut here ]------------
> [227274.061354] kernel BUG at /home/apw/COD/linux/fs/btrfs/extent_io.c:2116!
> [227274.061445] invalid opcode: 0000 [#1] SMP
> [227274.061509] Modules linked in: cuse deflate
> [227274.061573] BTRFS info (device sdi): csum failed ino 258 off
> 1395560448 csum 2284440321 expected csum 319628859
> [227274.061707]  ctr twofish_generic twofish_x86_64_3way
> twofish_x86_64 twofish_common camellia_generic camellia_x86_64
> serpent_sse2_x86_64 xts serpent_generic lrw gf128mul glue_helper
> blowfish_generic blowfish_x86_64 blowfish_common cast5_generic
> cast_common ablk_helper cryptd des_generic cmac xcbc rmd160
> crypto_null af_key xfrm_algo nfsd auth_rpcgss nfs_acl nfs lockd sunrpc
> fscache dm_crypt ip6t_REJECT ppdev xt_hl ip6t_rt nf_conntrack_ipv6
> nf_defrag_ipv6 ipt_REJECT xt_comment xt_LOG kvm xt_recent microcode
> xt_multiport xt_limit xt_tcpudp psmouse serio_raw xt_addrtype k10temp
> edac_core ipt_MASQUERADE edac_mce_amd iptable_nat nf_nat_ipv4
> sp5100_tco nf_conntrack_ipv4 nf_defrag_ipv4 ftdi_sio i2c_piix4
> usbserial xt_conntrack ip6table_filter ip6_tables joydev
> nf_conntrack_netbios_ns nf_conntrack_broadcast snd_hda_codec_via
> nf_nat_ftp snd_hda_codec_hdmi nf_nat snd_hda_codec_generic
> nf_conntrack_ftp nf_conntrack snd_hda_intel iptable_filter
> ir_lirc_codec(OF) lirc_dev(OF) ip_tables snd_hda_codec
> ir_mce_kbd_decoder(OF) x_tables snd_hwdep ir_sony_decoder(OF)
> rc_tbs_nec(OF) ir_jvc_decoder(OF) snd_pcm ir_rc6_decoder(OF)
> ir_rc5_decoder(OF) saa716x_tbs_dvb(OF) tbs6982fe(POF) tbs6680fe(POF)
> ir_nec_decoder(OF) tbs6923fe(POF) tbs6985se(POF) tbs6928se(POF)
> tbs6982se(POF) tbs6991fe(POF) tbs6618fe(POF) saa716x_core(OF)
> tbs6922fe(POF) tbs6928fe(POF) tbs6991se(POF) stv090x(OF) dvb_core(OF)
> rc_core(OF) snd_timer snd soundcore asus_atk0110 parport_pc shpchp
> mac_hid lp parport btrfs xor raid6_pq pata_acpi hid_generic usbhid hid
> usb_storage radeon pata_atiixp r8169 mii i2c_algo_bit sata_sil24 ttm
> drm_kms_helper drm ahci libahci wmi
> [227274.064118] CPU: 1 PID: 15543 Comm: btrfs-endio-4 Tainted: PF
>     O 3.14.1-031401-generic #201404141220
> [227274.064246] Hardware name: System manufacturer System Product
> Name/M4A78LT-M, BIOS 0802    08/24/2010
> [227274.064368] task: ffff88030a0e31e0 ti: ffff8800a15b8000 task.ti:
> ffff8800a15b8000
> [227274.064467] RIP: 0010:[<ffffffffa0304c33>]  [<ffffffffa0304c33>]
> clean_io_failure+0x1a3/0x1b0 [btrfs]
> [227274.064623] RSP: 0018:ffff8800a15b9cd8  EFLAGS: 00010246
> [227274.064694] RAX: 0000000000000000 RBX: ffff88010b2869b8 RCX:
> 0000000000000000
> [227274.064789] RDX: ffff8802cad30f00 RSI: 00000000720071fe RDI:
> ffff88010b286884
> [227274.064883] RBP: ffff8800a15b9d28 R08: 0000000000000000 R09:
> 0000000000000000
> [227274.064977] R10: 0000000000000200 R11: 0000000000000000 R12:
> ffffea000102b080
> [227274.065071] R13: ffff880004366c00 R14: ffff88010b286800 R15:
> 00000000532ef000
> [227274.065166] FS:  00007f16670b0740(0000) GS:ffff88031fc40000(0000)
> knlGS:0000000000000000
> [227274.065271] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [227274.065348] CR2: 00007f9c5c3b0000 CR3: 00000002dd8a8000 CR4:
> 00000000000007e0
> [227274.065443] Stack:
> [227274.065471]  00000000000532ef ffff88030a14c000 0000000000000000
> ffff880004366c00
> [227274.065584]  ffff88030a95f780 ffffea000102b080 ffff8801026cc4b0
> ffff88010b2869b8
> [227274.065697]  00000000532ef000 0000000000000000 ffff8800a15b9db8
> ffffffffa0304f1b
> [227274.065809] Call Trace:
> [227274.065872]  [<ffffffffa0304f1b>]
> end_bio_extent_readpage+0x2db/0x3d0 [btrfs]
> [227274.065971]  [<ffffffff8120a013>] bio_endio+0x53/0xa0
> [227274.066042]  [<ffffffff8120a072>] bio_endio_nodec+0x12/0x20
> [227274.066137]  [<ffffffffa02dde81>] end_workqueue_fn+0x41/0x50 [btrfs]
> [227274.066243]  [<ffffffffa03157d0>] worker_loop+0xa0/0x330 [btrfs]
> [227274.066345]  [<ffffffffa0315730>] ?
> check_pending_worker_creates.isra.1+0xe0/0xe0 [btrfs]
> [227274.066455]  [<ffffffff8108ffa9>] kthread+0xc9/0xe0
> [227274.066522]  [<ffffffff8108fee0>] ? flush_kthread_worker+0xb0/0xb0
> [227274.066606]  [<ffffffff817721bc>] ret_from_fork+0x7c/0xb0
> [227274.066680]  [<ffffffff8108fee0>] ? flush_kthread_worker+0xb0/0xb0
> [227274.066761] Code: 00 00 83 f8 01 0f 8e 49 ff ff ff 49 8b 4d 18 49
> 8b 55 10 4d 89 e0 45 8b 4d 2c 48 8b 7d b8 4c 89 fe e8 72 fc ff ff e9
> 29 ff ff ff <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55
> 48 89
> [227274.067266] RIP  [<ffffffffa0304c33>] clean_io_failure+0x1a3/0x1b0 [btrfs]
> [227274.067380]  RSP <ffff8800a15b9cd8>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
