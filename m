Return-Path: <SRS0=OwOL=RT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F754C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Mar 2019 09:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D66AB218E0
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Mar 2019 09:35:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fWdOOsfn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfCPJfv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Mar 2019 05:35:51 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41341 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfCPJfu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Mar 2019 05:35:50 -0400
Received: by mail-ed1-f68.google.com with SMTP id a25so2365342edc.8
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Mar 2019 02:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=wIxBug2F5YstIDTbCvFhyaTSCMBeBKE8ZHZZY3g4rGs=;
        b=fWdOOsfnV+OWmBHALSuzEj118F620NMDjpRJHy9g+wmpvlGmn8/MyTgu5oSzG3tOjk
         I3OEmpyShhsCTrSg28h4rOKiSqO+MqXa0BcenEty01Z7YjdRH6MaLpolQuEVd6KVw0t7
         Xqnb0wi9ternWWLglbhADE+O+XuEwOdjZTbFPhsKJ6hlsTPF1f8IPOKHP2S/evC5a6o0
         IB3CsVVqTrka/Bv0Y932ExAu2wUetWy6cJecfzlf5FUncNqMtxyEtZqY1X0qfBeHHaDw
         F/y/CyCm9Yfp/+dt+4V602AAM1+aT90XFA+cv0KlvtQYYND86O8B/3Hf86xkYI0fIlQN
         o8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=wIxBug2F5YstIDTbCvFhyaTSCMBeBKE8ZHZZY3g4rGs=;
        b=QZj6C7GtRnFPadpmfhXI+jbaw3GHz/SrjF4+2x4D06bDO18ZZKnvBIC2MvvyvRGJu8
         1Hck8mMLSjrl6AGtugU7fPI4blBEzFxG3PohBZozCojjYE+d64rO5swlQF15TTqWoNzR
         CZlK58nqYCy+cl7nXYBzTlOZLmB44C9qxr2jNRRSkSKXL2201OwLshQiMuRlDUCf/DwQ
         WSIbGVG1iy0y1r+Qg+s6ZBY894NVVNc2Woj0yL/Xt85UFISr9StxZHiZA5M7ivvF5+h3
         r9tNCAMwfnCp16vREVurBZZ3zt0qOWDR7uiYE0ioqWtDyJZdBhmBoiw9nQq3J/KI1IGx
         OcfA==
X-Gm-Message-State: APjAAAWuPJCrr8fw18kyTQXkCjUEHxHDrN52K4o4KWR2bNB6UsGmGtAy
        BOcf1/RcKgTIBVueZ3Soxw+ilZuaOlXSAPtj4gfIZng9
X-Google-Smtp-Source: APXvYqxPZYWVUMfSHol2GrcWo1Voj4fo/rAdY5AQRMtnxw2vtkpMkfv91ihn76e+rjAp8wu87y+SFRRZ/AG+YQJr+uc=
X-Received: by 2002:a17:906:3507:: with SMTP id r7mr4925288eja.65.1552728948565;
 Sat, 16 Mar 2019 02:35:48 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Luis_Panadero_Guarde=C3=B1o?= <luis.panadero@gmail.com>
Date:   Sat, 16 Mar 2019 10:35:37 +0100
Message-ID: <CANWDRg9zN2KXzx7zLJFV5jixp7pmqqr5raVB-mFNObtzvxSh0Q@mail.gmail.com>
Subject: BTRFS partition over a SSD got totally broken on Ubuntu 18.10 ->
 errno=-17 Object already exists (Failed to recover log tree)
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I have a BTRFS partititon on a Toshiba TR200 SSD . Two days ago, it
got to readonly mode. Inspecting the dmesg I got this :
>
> [ 3490.935497] BTRFS info (device sdc2): disk space caching is enabled
> [ 3490.935500] BTRFS info (device sdc2): has skinny extents
> [ 3490.968534] BTRFS info (device sdc2): enabling ssd optimizations
> [ 3490.975507] ------------[ cut here ]------------
> [ 3490.975509] BTRFS: Transaction aborted (error -17)
> [ 3490.975614] WARNING: CPU: 6 PID: 22107 at /home/kernel/COD/linux/fs/bt=
rfs/extent-tree.c:3083 btrfs_run_delayed_refs+0x170/0x1c0 [btrfs]
> [ 3490.975615] Modules linked in: xfrm_user xfrm4_tunnel tunnel4 ipcomp x=
frm_ipcomp esp4 ah4 af_key l2tp_ppp l2tp_netlink l2tp_core ip6_udp_tunnel u=
dp_tunnel xfrm_algo pppox snd_hrtimer zram binfmt_misc nls_iso8859_1 snd_hd=
a_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_=
hda_codec snd_hda_core edac_mce_amd snd_hwdep snd_pcm kvm_amd ccp kvm snd_s=
eq_midi snd_seq_midi_event ir_rc6_decoder snd_rawmidi irqbypass snd_seq rc_=
rc6_mce crct10dif_pclmul crc32_pclmul ghash_clmulni_intel mceusb joydev inp=
ut_leds rc_core snd_seq_device pcbc snd_timer aesni_intel aes_x86_64 snd so=
undcore crypto_simd glue_helper mac_hid cryptd parport_serial fam15h_power =
shpchp k10temp sch_fq_codel parport_pc ppdev lp parport ip_tables x_tables =
autofs4 btrfs xor zstd_compress raid6_pq hid_generic usbhid hid
> [ 3490.975666]  amdkfd amd_iommu_v2 amdgpu chash gpu_sched i2c_algo_bit t=
tm mxm_wmi drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops r81=
69 drm ahci mii i2c_piix4 libahci wmi
> [ 3490.975684] CPU: 6 PID: 22107 Comm: mount Not tainted 4.16.2-041602-ge=
neric #201804121130
> [ 3490.975685] Hardware name: MSI MS-7974/970A-G43 PLUS (MS-7974), BIOS V=
1.1 07/04/2016
> [ 3490.975713] RIP: 0010:btrfs_run_delayed_refs+0x170/0x1c0 [btrfs]
> [ 3490.975714] RSP: 0018:ffffb5a486c0f8c0 EFLAGS: 00010282
> [ 3490.975716] RAX: 0000000000000000 RBX: ffff9f4cab66df08 RCX: 000000000=
0000006
> [ 3490.975718] RDX: 0000000000000007 RSI: 0000000000000096 RDI: ffff9f4cb=
ed964b0
> [ 3490.975719] RBP: ffffb5a486c0f910 R08: 000000000000043e R09: 000000000=
0000004
> [ 3490.975721] R10: ffff9f4ab44cfc40 R11: 0000000000000001 R12: ffff9f4ab=
44cfc40
> [ 3490.975722] R13: ffff9f4a9bb94800 R14: ffff9f4cab66df08 R15: 000000000=
0000038
> [ 3490.975725] FS:  00007f2f0355d080(0000) GS:ffff9f4cbed80000(0000) knlG=
S:0000000000000000
> [ 3490.975726] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3490.975728] CR2: 000055ffe06115c0 CR3: 000000023aab0000 CR4: 000000000=
00406e0
> [ 3490.975729] Call Trace:
> [ 3490.975762]  btrfs_commit_transaction+0x45/0x8e0 [btrfs]
> [ 3490.975795]  btrfs_recover_log_trees+0x416/0x4a0 [btrfs]
> [ 3490.975828]  ? replay_one_extent+0x7d0/0x7d0 [btrfs]
> [ 3490.975856]  open_ctree+0x1feb/0x2440 [btrfs]
> [ 3490.975882]  btrfs_mount_root+0x6d1/0x7a0 [btrfs]
> [ 3490.975906]  ? btrfs_mount_root+0x6d1/0x7a0 [btrfs]
> [ 3490.975912]  mount_fs+0x37/0x150
> [ 3490.975915]  ? mount_fs+0x37/0x150
> [ 3490.975918]  ? alloc_vfsmnt+0x1b3/0x230
> [ 3490.975921]  vfs_kern_mount.part.23+0x5d/0x110
> [ 3490.975924]  vfs_kern_mount+0x13/0x20
> [ 3490.975951]  btrfs_mount+0x182/0x950 [btrfs]
> [ 3490.975955]  ? cpumask_next+0x1b/0x20
> [ 3490.975958]  ? pcpu_alloc+0x31b/0x650
> [ 3490.975962]  mount_fs+0x37/0x150
> [ 3490.975964]  ? mount_fs+0x37/0x150
> [ 3490.975966]  ? alloc_vfsmnt+0x1b3/0x230
> [ 3490.975969]  vfs_kern_mount.part.23+0x5d/0x110
> [ 3490.975972]  do_mount+0x5ed/0xce0
> [ 3490.975976]  ? memdup_user+0x4f/0x80
> [ 3490.975979]  SyS_mount+0x98/0xe0
> [ 3490.975982]  do_syscall_64+0x73/0x130
> [ 3490.975986]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [ 3490.975988] RIP: 0033:0x7f2f02e423ca
> [ 3490.975990] RSP: 002b:00007ffc9434edd8 EFLAGS: 00000206 ORIG_RAX: 0000=
0000000000a5
> [ 3490.975992] RAX: ffffffffffffffda RBX: 00005588bc39da40 RCX: 00007f2f0=
2e423ca
> [ 3490.975994] RDX: 00005588bc3ab850 RSI: 00005588bc39dc40 RDI: 00005588b=
c39dc20
> [ 3490.975995] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007f2f0=
2e8e1b0
> [ 3490.975996] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 00005588b=
c39dc20
> [ 3490.975998] R13: 00005588bc3ab850 R14: 0000000000000000 R15: 00007f2f0=
336a8a4
> [ 3490.975999] Code: 1f 40 00 eb c4 48 8b 53 50 f0 48 0f ba aa d8 cd 00 0=
0 02 72 1b 83 f8 fb 74 34 89 c6 48 c7 c7 c0 a5 7c c0 89 45 d0 e8 40 a4 b6 e=
7 <0f> 0b 8b 45 d0 89 c1 ba 0b 0c 00 00 48 c7 c6 00 39 7c c0 48 89
> [ 3490.976045] ---[ end trace 633ae76f1f0eee99 ]---
> [ 3490.976048] BTRFS: error (device sdc2) in btrfs_run_delayed_refs:3083:=
 errno=3D-17 Object already exists
> [ 3490.976062] BTRFS: error (device sdc2) in btrfs_replay_log:2308: errno=
=3D-17 Object already exists (Failed to recover log tree)
> [ 3490.976172] BTRFS error (device sdc2): cleaner transaction attach retu=
rned -30
> [ 3491.002005] BTRFS error (device sdc2): open_ctree failed


I try to reboot to load a older kernel, thinking that was a issue of
the last kernel updater. I can't mount the partition any more.
Trying to mount the BTRFS partition from a Live dvd, gets the same error.

I try to execute btrfs check without any sucess :
>
> sudo btrfs check -p --readonly /dev/sdc2
> Checking filesystem on /dev/sdc2
> UUID: 595cf1ca-7df2-46ff-8472-a2789f0bab77
> check/main.c:3654: check_owner_ref: BUG_ON `rec->is_root` triggered, valu=
e 1
> btrfs(+0x4b7d0)[0x559daa67e7d0]
> btrfs(+0x12df8)[0x559daa645df8]
> btrfs(+0x4bd21)[0x559daa67ed21]
> btrfs(+0x4efdb)[0x559daa681fdb]
> btrfs(+0x4fbdf)[0x559daa682bdf]
> btrfs(+0x505f1)[0x559daa6835f1]
> btrfs(cmd_check+0x133f)[0x559daa686926]
> btrfs(main+0x143)[0x559daa649c87]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xe7)[0x7f5ac3a59b97]
> btrfs(_start+0x2a)[0x559daa649cca]
> 'sudo btrfs check -p --readonly=E2=80=A6' terminated by signal SIGABRT (A=
bort)
>

I think that the partition can't be recovered. However, I would like
to know why has happened this or how avoid this problem as I would
like to keep using BTRFS.

Smart values shows that the SSD it's ok but before doing a reinstall I
would try to stress it to see any signal of problems.

Info about my system and versions :

lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 18.04.1 LTS
Release:        18.04
Codename:       bionic

uname -a
Linux blackbox-linux 4.16.2-041602-generic #201804121130 SMP Thu Apr
12 11:32:17 UTC 2018 x86_64 x86_64 x86_64 GNU/L

btrfs --version
btrfs-progs v4.15.1

mount options on fstab : defaults,discard,compress=3Dlzo
