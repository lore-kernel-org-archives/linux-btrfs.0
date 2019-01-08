Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 802C4C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 21:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D4C220675
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 21:03:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PztlCaTI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbfAHVDl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 16:03:41 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33131 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbfAHVDl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 16:03:41 -0500
Received: by mail-wm1-f66.google.com with SMTP id r24so9349450wmh.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2019 13:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tHQNj2nXmzVCMQEA0C+WkR4PAWywa6usMY6abUaze5k=;
        b=PztlCaTI7IuZKm0ggKNwj5QEqaGLeyGmwxewkjWQGTJVSRw5BaaATH4TF9U8CHgpAp
         vIj7ZUJbS5EFFUq3Dc/cMvWp/e95xSAPl8WlmPKD1EU1sscWr4h5TzDxDNGamVCspTPC
         l9aOXKE/2nwNzhwuZ1gB03zQ+oZpcKILUVtYx6+lAIAxJv60tK1RkgnfT6plnNsyxEsA
         bsxROdfmVXg0VqgPqGcljLXbVzKYjZdzp2A0IdkKdCwIij17DnYL93SDeFJ5hAMS+Pd5
         cc5vA3P/wXS97xunl81IYRZtUKGt/3yD7swEXWW/P2F+KF8lZIbvsfK6fOFlOUJUUV3K
         5k/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tHQNj2nXmzVCMQEA0C+WkR4PAWywa6usMY6abUaze5k=;
        b=Ao9PujMkte/hVrNJBGTUYXLsCByN/ZL5ODZox9/9GGcNQyKLGnv3Qm2AUralWEjbM+
         u7xbH/ev5MZ5/UhfRKvTB3VN+gNwI5nMKp7I1PXKKvBye0NDix9a0GVLbkMLKdBH2ZOK
         Q+F5C670xXuYx27VXyxeJxf9DRI20BbG08otXsxFHk6d2VOo+8wz4eRvGy2sSbJIUPis
         sqkfztD1zDB0H9Sey4r19sWalKqqmh6iKuZvJQcrEDhnr/eyG08FNJ061bK5LniCgeEQ
         qouQBEznDPQCcGHhCODO+Im/5xD6Bc67GRoC4OYft3Sv+ECKK212eDpXrgev5ZKasb5n
         MH0g==
X-Gm-Message-State: AJcUukdlBzL2W20hyrUZ+vxEDOmP/AmaA4hN64GJ98PhuWSalYD6I3eJ
        l6l7kmDXQSuiSbzn5qgM+9I=
X-Google-Smtp-Source: ALg8bN4yxTkOSL2GBAWRKUiB6A0xvUO/plAUfpiJkfBu7NXfgqkJUdCVxcMWegi/Uj6ZvsV2EpI8JA==
X-Received: by 2002:a1c:f613:: with SMTP id w19mr2969144wmc.0.1546981413651;
        Tue, 08 Jan 2019 13:03:33 -0800 (PST)
Received: from exnet.gdb.it ([5.90.200.83])
        by smtp.gmail.com with ESMTPSA id g129sm10933374wmf.39.2019.01.08.13.03.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 Jan 2019 13:03:32 -0800 (PST)
From:   Giuseppe Della Bianca <giusdbg@gmail.com>
To:     Jeff Mahoney <jeffm@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can hangs.
Date:   Tue, 08 Jan 2019 22:02:45 +0100
Message-ID: <70326422.XUdVI2pWXa@exnet.gdb.it>
In-Reply-To: <1533b054-9d55-e968-74e2-b895de9e35fc@suse.com>
References: <2543962.HIiRWmuHEy@exnet.gdb.it> <2971657.kkKnYu9ILp@exnet.gdb.it> <1533b054-9d55-e968-74e2-b895de9e35fc@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In data luned=EC 7 gennaio 2019 23:40:19 CET, Jeff Mahoney ha scritto:
]zac[
> > If you want, I can send you the full log (very long).
> > From what you wrote below it seems to me that you do not need it
>=20
> Please do.  It would be good to see what the state of the extent tree is
> there.


=2D- Logs begin at Sat 2016-11-26 18:16:29 CET, end at Tue 2019-01-08 21:39=
:44=20
CET. --
gen 01 17:17:32 exnetold.gdb.it kernel: WARNING: CPU: 0 PID: 16871 at fs/
btrfs/extent-tree.c:7001 __btrfs_free_extent.isra.70+0x782/0xb10 [btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel: Modules linked in: fuse xt_CHECKSUM=
=20
ipt_MASQUERADE nf_nat_masquerade_ipv4 tun nf_conntrack_netbios_ns=20
nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6=20
xt_conntrack devlink ip_set nfnetlink ebtable_nat ebtable_broute bridge stp=
=20
llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mang=
le=20
ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4=
=20
nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_raw iptable_security=
=20
ebtable_filter ebtables ip6table_filter ip6_tables it87 hwmon_vid sunrpc=20
snd_hda_codec_analog snd_hda_codec_generic snd_hda_codec_hdmi btrfs=20
powernow_k8 amd64_edac_mod edac_mce_amd snd_hda_intel snd_hda_codec kvm_amd=
=20
xor ccp zstd_compress snd_hda_core snd_hwdep kvm snd_seq snd_seq_device ppd=
ev=20
snd_pcm raid6_pq irqbypass
gen 01 17:17:32 exnetold.gdb.it kernel:  libcrc32c k8temp snd_timer=20
zstd_decompress xxhash i2c_nforce2 snd asus_atk0110 soundcore shpchp=20
parport_pc parport ata_generic pata_acpi nouveau video mxm_wmi wmi=20
i2c_algo_bit drm_kms_helper ttm drm serio_raw sata_nv forcedeth
gen 01 17:17:32 exnetold.gdb.it kernel: CPU: 0 PID: 16871 Comm: btrfs-clean=
er=20
Not tainted 4.17.19-200.fc28.x86_64 #1
gen 01 17:17:32 exnetold.gdb.it kernel: Hardware name: System manufacturer=
=20
System Product Name/M2N, BIOS 0902    02/16/2009
gen 01 17:17:32 exnetold.gdb.it kernel: RIP: 0010:__btrfs_free_extent.isra.
70+0x782/0xb10 [btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel: RSP: 0018:ffffa63985f8fc30 EFLAGS:=
=20
00010246
gen 01 17:17:32 exnetold.gdb.it kernel: RAX: 00000000fffffffe RBX:=20
ffff8b71313f8380 RCX: 0000000000000000
gen 01 17:17:32 exnetold.gdb.it kernel: RDX: 0000000000000000 RSI:=20
0000000000000000 RDI: ffff8b711d8ef578
gen 01 17:17:32 exnetold.gdb.it kernel: RBP: 00000011cb804000 R08:=20
ffffa63985f8fba4 R09: 0000000000000018
gen 01 17:17:32 exnetold.gdb.it kernel: R10: 0000000000000835 R11:=20
0000000000000000 R12: ffff8b715f5d4000
gen 01 17:17:32 exnetold.gdb.it kernel: R13: 00000000fffffffe R14:=20
0000000000000000 R15: 00000000000005aa
gen 01 17:17:32 exnetold.gdb.it kernel: FS:  0000000000000000(0000)=20
GS:ffff8b717fa00000(0000) knlGS:0000000000000000
gen 01 17:17:32 exnetold.gdb.it kernel: CS:  0010 DS: 0000 ES: 0000 CR0:=20
0000000080050033
gen 01 17:17:32 exnetold.gdb.it kernel: CR2: 00007fdfdffffa08 CR3:=20
00000000b05b0000 CR4: 00000000000006f0
gen 01 17:17:32 exnetold.gdb.it kernel: Call Trace:
gen 01 17:17:32 exnetold.gdb.it kernel:  __btrfs_run_delayed_refs+0x216/0x1=
0b0=20
[btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel:  ? btrfs_free_tree_block+0x82/0x2c0=
=20
[btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel:  btrfs_run_delayed_refs+0x78/0x180=
=20
[btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel:  btrfs_should_end_transaction+0x3e/
0x60 [btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel:  btrfs_drop_snapshot+0x3cf/0x820=20
[btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel:  ? btree_submit_bio_start+0x20/0x20=
=20
[btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel: =20
btrfs_clean_one_deleted_snapshot+0xba/0xe0 [btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel:  cleaner_kthread+0x129/0x160 [btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel:  kthread+0x112/0x130
gen 01 17:17:32 exnetold.gdb.it kernel:  ?=20
kthread_create_worker_on_cpu+0x70/0x70
gen 01 17:17:32 exnetold.gdb.it kernel:  ret_from_fork+0x35/0x40
gen 01 17:17:32 exnetold.gdb.it kernel: Code: b8 00 00 00 48 8b 7c 24 18 e8=
 bb=20
b7 ff ff 41 89 c5 58 5a c6 44 24 24 00 45 85 ed 0f 84 97 f9 ff ff 41 83 fd =
fe=20
0f 85 63 fc ff ff <0f> 0b 48 8b 3b e8 84 ca 00 00 4d 89 f8 4c 89 f1 48 89 e=
a=20
ff b4=20
gen 01 17:17:32 exnetold.gdb.it kernel: ---[ end trace c4eefd1fdc016cea ]---
gen 01 17:17:32 exnetold.gdb.it kernel: BTRFS info (device sda3): leaf=20
62678286336 gen 6388 total ptrs 148 free space 6202 owner 2
gen 01 17:17:32 exnetold.gdb.it kernel:         item 0 key (76427296768 169=
 0)=20
itemoff 16250 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 1 key (76427313152 169=
 0)=20
itemoff 16217 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 2 key (76427329536 169=
 0)=20
itemoff 16184 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 3 key (76427345920 169=
 0)=20
itemoff 16151 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 4 key (76427362304 169=
 0)=20
itemoff 16118 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 5 key (76427378688 169=
 0)=20
itemoff 16085 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 6 key (76427395072 169=
 0)=20
itemoff 16025 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 7 key (76427411456 169=
 0)=20
itemoff 15992 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 8 key (76427427840 169=
 0)=20
itemoff 15959 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 9 key (76427444224 169=
 0)=20
itemoff 15926 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 10 key (76427460608 16=
9=20
0) itemoff 15893 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 11 key (76427476992 16=
9=20
0) itemoff 15860 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 12 key (76427493376 16=
9=20
0) itemoff 15827 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 13 key (76427509760 16=
9=20
0) itemoff 15794 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 14 key (76427526144 16=
9=20
0) itemoff 15761 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 15 key (76427542528 16=
9=20
0) itemoff 15728 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 16 key (76427558912 16=
9=20
0) itemoff 15668 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 17 key (76427591680 16=
9=20
0) itemoff 15635 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 2
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 7
gen 01 17:17:32 exnetold.gdb.it kernel:         item 18 key (76427608064 16=
9=20
0) itemoff 15602 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 2
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 7
gen 01 17:17:32 exnetold.gdb.it kernel:         item 19 key (76427624448 16=
9=20
0) itemoff 15569 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
278=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76393332736
gen 01 17:17:32 exnetold.gdb.it kernel:         item 20 key (76427640832 16=
9=20
0) itemoff 15536 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
341=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 85760114688
gen 01 17:17:32 exnetold.gdb.it kernel:         item 21 key (76427673600 16=
9=20
0) itemoff 15503 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 22 key (76427689984 16=
9=20
0) itemoff 15470 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76600279040
gen 01 17:17:32 exnetold.gdb.it kernel:         item 23 key (76427706368 16=
9=20
0) itemoff 15437 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76553961472
gen 01 17:17:32 exnetold.gdb.it kernel:         item 24 key (76427722752 16=
9=20
0) itemoff 15404 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 25 key (76427739136 16=
9=20
0) itemoff 15371 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 26 key (76427755520 16=
9=20
0) itemoff 15338 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 27 key (76427771904 16=
9=20
0) itemoff 15305 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 28 key (76427788288 16=
9=20
0) itemoff 15272 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 29 key (76427804672 16=
9=20
0) itemoff 15239 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 30 key (76427821056 16=
9=20
0) itemoff 15206 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 31 key (76427837440 16=
9=20
0) itemoff 15146 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 32 key (76427853824 16=
9=20
0) itemoff 15113 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 33 key (76427870208 16=
9=20
0) itemoff 15080 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 34 key (76427886592 16=
9=20
0) itemoff 15020 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 35 key (76427902976 16=
9=20
0) itemoff 14987 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 2
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 7
gen 01 17:17:32 exnetold.gdb.it kernel:         item 36 key (76427919360 16=
9=20
0) itemoff 14954 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76600279040
gen 01 17:17:32 exnetold.gdb.it kernel:         item 37 key (76427935744 16=
9=20
0) itemoff 14921 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76601622528
gen 01 17:17:32 exnetold.gdb.it kernel:         item 38 key (76427952128 16=
9=20
0) itemoff 14888 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 39 key (76427968512 16=
9=20
0) itemoff 14783 itemsize 105
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 9 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 85582036992
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 81998725120
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#4: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#5: shared block=
=20
backref parent 76366790656
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#6: shared block=
=20
backref parent 71382368256
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#7: shared block=
=20
backref parent 71219494912
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#8: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 40 key (76427984896 16=
9=20
0) itemoff 14750 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 41 key (76428001280 16=
9=20
0) itemoff 14717 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 42 key (76428017664 16=
9=20
0) itemoff 14684 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 43 key (76428034048 16=
9=20
0) itemoff 14651 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 44 key (76428050432 16=
9=20
0) itemoff 14618 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:         item 45 key (76428066816 16=
9=20
0) itemoff 14558 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 46 key (76428083200 16=
9=20
0) itemoff 14525 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 2
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 7
gen 01 17:17:32 exnetold.gdb.it kernel:         item 47 key (76428099584 16=
9=20
0) itemoff 14465 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 48 key (76428115968 16=
9=20
0) itemoff 14405 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 49 key (76428132352 16=
9=20
0) itemoff 14345 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 50 key (76428148736 16=
9=20
0) itemoff 14285 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 51 key (76428165120 16=
9=20
0) itemoff 14225 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 52 key (76428181504 16=
9=20
0) itemoff 14165 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 53 key (76428197888 16=
9=20
0) itemoff 14105 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 54 key (76428214272 16=
9=20
0) itemoff 14045 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 55 key (76428230656 16=
9=20
0) itemoff 13985 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 56 key (76428247040 16=
9=20
0) itemoff 13925 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 57 key (76428263424 16=
9=20
0) itemoff 13865 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 58 key (76428279808 16=
9=20
0) itemoff 13805 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 59 key (76428296192 16=
9=20
0) itemoff 13745 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 60 key (76428312576 16=
9=20
0) itemoff 13685 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 61 key (76428328960 16=
9=20
0) itemoff 13625 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 62 key (76428345344 16=
9=20
0) itemoff 13565 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 63 key (76428361728 16=
9=20
0) itemoff 13505 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 64 key (76428378112 16=
9=20
0) itemoff 13445 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel:         item 65 key (76428394496 16=
9=20
0) itemoff 13412 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 2
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 7
gen 01 17:17:32 exnetold.gdb.it kernel:         item 66 key (76428410880 16=
9=20
0) itemoff 13370 itemsize 42
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 2 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76606570496
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 42349903872
gen 01 17:17:32 exnetold.gdb.it kernel:         item 67 key (76428427264 16=
9=20
0) itemoff 13337 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 2=
214=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 361455812608
gen 01 17:17:32 exnetold.gdb.it kernel:         item 68 key (76428443648 16=
9=20
0) itemoff 13295 itemsize 42
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 2 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76606570496
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 42349903872
gen 01 17:17:32 exnetold.gdb.it kernel:         item 69 key (76428460032 16=
9=20
0) itemoff 13244 itemsize 51
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 3 gen 6=
278=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76498026496
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76467716096
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 66441887744
gen 01 17:17:32 exnetold.gdb.it kernel:         item 70 key (76428476416 16=
9=20
0) itemoff 13211 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 2
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 2
gen 01 17:17:32 exnetold.gdb.it kernel:         item 71 key (76428492800 16=
9=20
0) itemoff 13178 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
341=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 85760114688
gen 01 17:17:32 exnetold.gdb.it kernel:         item 72 key (76428509184 16=
9=20
0) itemoff 13127 itemsize 51
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 3 gen 6=
278=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76498026496
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76467716096
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 66441887744
gen 01 17:17:32 exnetold.gdb.it kernel:         item 73 key (76428525568 16=
9=20
0) itemoff 13094 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
341=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 85760114688
gen 01 17:17:32 exnetold.gdb.it kernel:         item 74 key (76428541952 16=
9=20
0) itemoff 13043 itemsize 51
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 3 gen 6=
278=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76498026496
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76467716096
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 66441887744
gen 01 17:17:32 exnetold.gdb.it kernel:         item 75 key (76428558336 16=
9=20
0) itemoff 13010 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
341=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 85760114688
gen 01 17:17:32 exnetold.gdb.it kernel:         item 76 key (76428574720 16=
9=20
0) itemoff 12977 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
357=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 91123597312
gen 01 17:17:32 exnetold.gdb.it kernel:         item 77 key (76428591104 16=
9=20
0) itemoff 12944 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 2
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 2
gen 01 17:17:32 exnetold.gdb.it kernel:         item 78 key (76428607488 16=
9=20
0) itemoff 12911 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
357=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 91123597312
gen 01 17:17:32 exnetold.gdb.it kernel:         item 79 key (76428623872 16=
9=20
1) itemoff 12869 itemsize 42
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 2 gen 6=
357=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 1451
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: tree block=20
backref root 1446
gen 01 17:17:32 exnetold.gdb.it kernel:         item 80 key (76428640256 16=
9=20
0) itemoff 12836 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
303=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76545802240
gen 01 17:17:32 exnetold.gdb.it kernel:         item 81 key (76428656640 16=
9=20
0) itemoff 12803 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
357=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76428623872
gen 01 17:17:32 exnetold.gdb.it kernel:         item 82 key (76428705792 16=
9=20
0) itemoff 12770 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
341=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 85760114688
gen 01 17:17:32 exnetold.gdb.it kernel:         item 83 key (76428722176 16=
9=20
0) itemoff 12737 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
384=20
flags 2
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 2
gen 01 17:17:32 exnetold.gdb.it kernel:         item 84 key (76428738560 16=
9=20
0) itemoff 12704 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
384=20
flags 2
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 2
gen 01 17:17:32 exnetold.gdb.it kernel:         item 85 key (76428754944 16=
9=20
0) itemoff 12671 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
278=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76427132928
gen 01 17:17:32 exnetold.gdb.it kernel:         item 86 key (76428771328 16=
9=20
0) itemoff 12647 itemsize 24
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 2=
542=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:         item 87 key (76428771328 18=
2=20
128379305984) itemoff 12647 itemsize 0
gen 01 17:17:32 exnetold.gdb.it kernel:                 shared block backref
gen 01 17:17:32 exnetold.gdb.it kernel:         item 88 key (76428787712 16=
9=20
0) itemoff 12614 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 2
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 7
gen 01 17:17:32 exnetold.gdb.it kernel:         item 89 key (76428804096 16=
9=20
0) itemoff 12581 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:         item 90 key (76428820480 16=
9=20
0) itemoff 12521 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 91 key (76428836864 16=
9=20
0) itemoff 12461 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 92 key (76428853248 16=
9=20
0) itemoff 12428 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:         item 93 key (76428869632 16=
9=20
0) itemoff 12395 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:         item 94 key (76428886016 16=
9=20
0) itemoff 12335 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 95 key (76428902400 16=
9=20
0) itemoff 12275 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 96 key (76428918784 16=
9=20
0) itemoff 12215 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 97 key (76428935168 16=
9=20
0) itemoff 12182 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:         item 98 key (76428951552 16=
9=20
0) itemoff 12122 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 99 key (76428967936 16=
9=20
0) itemoff 12062 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 100 key (76428984320 1=
69=20
0) itemoff 12002 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 101 key (76429000704 1=
69=20
0) itemoff 11942 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 102 key (76429017088 1=
69=20
0) itemoff 11909 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:         item 103 key (76429033472 1=
69=20
0) itemoff 11876 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:         item 104 key (76429049856 1=
69=20
0) itemoff 11816 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 105 key (76429066240 1=
69=20
0) itemoff 11756 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 106 key (76429082624 1=
69=20
0) itemoff 11696 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 107 key (76429099008 1=
69=20
0) itemoff 11636 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 108 key (76429115392 1=
69=20
0) itemoff 11576 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 109 key (76429131776 1=
69=20
0) itemoff 11516 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 110 key (76429148160 1=
69=20
0) itemoff 11483 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:         item 111 key (76429164544 1=
69=20
0) itemoff 11423 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 112 key (76429180928 1=
69=20
0) itemoff 11363 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 113 key (76429197312 1=
69=20
0) itemoff 11303 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 114 key (76429213696 1=
69=20
0) itemoff 11270 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:         item 115 key (76429230080 1=
69=20
0) itemoff 11210 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 116 key (76429246464 1=
69=20
0) itemoff 11177 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:         item 117 key (76429262848 1=
69=20
0) itemoff 11117 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 118 key (76429279232 1=
69=20
0) itemoff 11057 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 119 key (76429295616 1=
69=20
0) itemoff 11024 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 2=
214=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 361455812608
gen 01 17:17:32 exnetold.gdb.it kernel:         item 120 key (76429312000 1=
69=20
0) itemoff 10964 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 121 key (76429328384 1=
69=20
0) itemoff 10931 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:         item 122 key (76429344768 1=
69=20
0) itemoff 10898 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 2=
214=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 361455812608
gen 01 17:17:32 exnetold.gdb.it kernel:         item 123 key (76429361152 1=
69=20
0) itemoff 10847 itemsize 51
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 3 gen 6=
278=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76498255872
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76427132928
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 66441969664
gen 01 17:17:32 exnetold.gdb.it kernel:         item 124 key (76429377536 1=
69=20
0) itemoff 10814 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
384=20
flags 2
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 2
gen 01 17:17:32 exnetold.gdb.it kernel:         item 125 key (76429393920 1=
69=20
0) itemoff 10763 itemsize 51
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 3 gen 6=
278=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76498026496
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76467716096
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 66441887744
gen 01 17:17:32 exnetold.gdb.it kernel:         item 126 key (76429410304 1=
69=20
0) itemoff 10712 itemsize 51
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 3 gen 6=
278=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76498026496
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76467716096
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 66441887744
gen 01 17:17:32 exnetold.gdb.it kernel:         item 127 key (76429426688 1=
69=20
0) itemoff 10661 itemsize 51
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 3 gen 6=
278=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76498026496
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76467716096
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 66441887744
gen 01 17:17:32 exnetold.gdb.it kernel:         item 128 key (76429443072 1=
69=20
0) itemoff 10628 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
256=20
flags 2
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 2
gen 01 17:17:32 exnetold.gdb.it kernel:         item 129 key (76429459456 1=
69=20
0) itemoff 10595 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
278=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76427132928
gen 01 17:17:32 exnetold.gdb.it kernel:         item 130 key (76429475840 1=
69=20
0) itemoff 10553 itemsize 42
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 2 gen 6=
278=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76427132928
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 66441969664
gen 01 17:17:32 exnetold.gdb.it kernel:         item 131 key (76429492224 1=
69=20
0) itemoff 10520 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
384=20
flags 2
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 2
gen 01 17:17:32 exnetold.gdb.it kernel:         item 132 key (76429508608 1=
69=20
0) itemoff 10478 itemsize 42
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 2 gen 6=
277=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81665769472
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 66383904768
gen 01 17:17:32 exnetold.gdb.it kernel:         item 133 key (76429524992 1=
69=20
0) itemoff 10445 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
341=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 85760114688
gen 01 17:17:32 exnetold.gdb.it kernel:         item 134 key (76429541376 1=
69=20
0) itemoff 10394 itemsize 51
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 3 gen 6=
278=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81814142976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 66339717120
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 62659117056
gen 01 17:17:32 exnetold.gdb.it kernel:         item 135 key (76429557760 1=
69=20
0) itemoff 10361 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
341=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 85760114688
gen 01 17:17:32 exnetold.gdb.it kernel:         item 136 key (76429574144 1=
69=20
0) itemoff 10328 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
384=20
flags 2
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 2
gen 01 17:17:32 exnetold.gdb.it kernel:         item 137 key (76429590528 1=
69=20
0) itemoff 10295 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
384=20
flags 2
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 2
gen 01 17:17:32 exnetold.gdb.it kernel:         item 138 key (76429606912 1=
69=20
0) itemoff 10262 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
341=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 85760114688
gen 01 17:17:32 exnetold.gdb.it kernel:         item 139 key (76429623296 1=
69=20
0) itemoff 10229 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
303=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76425297920
gen 01 17:17:32 exnetold.gdb.it kernel:         item 140 key (76429639680 1=
69=20
0) itemoff 10169 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
258=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76644990976
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76605489152
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76590530560
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 71136968704
gen 01 17:17:32 exnetold.gdb.it kernel:         item 141 key (76429656064 1=
69=20
0) itemoff 10136 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
303=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76425297920
gen 01 17:17:32 exnetold.gdb.it kernel:         item 142 key (76429672448 1=
69=20
0) itemoff 10103 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
303=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76425297920
gen 01 17:17:32 exnetold.gdb.it kernel:         item 143 key (76429688832 1=
69=20
0) itemoff 10070 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
303=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76425297920
gen 01 17:17:32 exnetold.gdb.it kernel:         item 144 key (76429705216 1=
69=20
0) itemoff 10037 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
303=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 76425297920
gen 01 17:17:32 exnetold.gdb.it kernel:         item 145 key (76429721600 1=
69=20
1) itemoff 10004 itemsize 33
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 1 gen 6=
303=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: tree block=20
backref root 1434
gen 01 17:17:32 exnetold.gdb.it kernel:         item 146 key (76429737984 1=
69=20
0) itemoff 9962 itemsize 42
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 2 gen 6=
277=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81665769472
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 66383904768
gen 01 17:17:32 exnetold.gdb.it kernel:         item 147 key (76429754368 1=
69=20
0) itemoff 9902 itemsize 60
gen 01 17:17:32 exnetold.gdb.it kernel:                 extent refs 4 gen 6=
256=20
flags 258
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#0: shared block=
=20
backref parent 81731174400
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#1: shared block=
=20
backref parent 76512641024
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#2: shared block=
=20
backref parent 76450250752
gen 01 17:17:32 exnetold.gdb.it kernel:                 ref#3: shared block=
=20
backref parent 66397339648
gen 01 17:17:32 exnetold.gdb.it kernel: BTRFS error (device sda3): unable t=
o=20
find ref byte nr 76428623872 parent 0 root 1450  owner 1 offset 0
gen 01 17:17:32 exnetold.gdb.it kernel: ------------[ cut here ]------------
gen 01 17:17:32 exnetold.gdb.it kernel: BTRFS: Transaction aborted (error -=
2)
gen 01 17:17:32 exnetold.gdb.it kernel: WARNING: CPU: 0 PID: 16871 at fs/
btrfs/extent-tree.c:7007 __btrfs_free_extent.isra.70+0x7e2/0xb10 [btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel: Modules linked in: fuse xt_CHECKSUM=
=20
ipt_MASQUERADE nf_nat_masquerade_ipv4 tun nf_conntrack_netbios_ns=20
nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6=20
xt_conntrack devlink ip_set nfnetlink ebtable_nat ebtable_broute bridge stp=
=20
llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mang=
le=20
ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4=
=20
nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_raw iptable_security=
=20
ebtable_filter ebtables ip6table_filter ip6_tables it87 hwmon_vid sunrpc=20
snd_hda_codec_analog snd_hda_codec_generic snd_hda_codec_hdmi btrfs=20
powernow_k8 amd64_edac_mod edac_mce_amd snd_hda_intel snd_hda_codec kvm_amd=
=20
xor ccp zstd_compress snd_hda_core snd_hwdep kvm snd_seq snd_seq_device ppd=
ev=20
snd_pcm raid6_pq irqbypass
gen 01 17:17:32 exnetold.gdb.it kernel:  libcrc32c k8temp snd_timer=20
zstd_decompress xxhash i2c_nforce2 snd asus_atk0110 soundcore shpchp=20
parport_pc parport ata_generic pata_acpi nouveau video mxm_wmi wmi=20
i2c_algo_bit drm_kms_helper ttm drm serio_raw sata_nv forcedeth
gen 01 17:17:32 exnetold.gdb.it kernel: CPU: 0 PID: 16871 Comm: btrfs-clean=
er=20
Tainted: G        W         4.17.19-200.fc28.x86_64 #1
gen 01 17:17:32 exnetold.gdb.it kernel: Hardware name: System manufacturer=
=20
System Product Name/M2N, BIOS 0902    02/16/2009
gen 01 17:17:32 exnetold.gdb.it kernel: RIP: 0010:__btrfs_free_extent.isra.
70+0x7e2/0xb10 [btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel: RSP: 0018:ffffa63985f8fc30 EFLAGS:=
=20
00010286
gen 01 17:17:32 exnetold.gdb.it kernel: RAX: 0000000000000000 RBX:=20
ffff8b71313f8380 RCX: 0000000000000006
gen 01 17:17:32 exnetold.gdb.it kernel: RDX: 0000000000000007 RSI:=20
0000000000000086 RDI: ffff8b717fa16930
gen 01 17:17:32 exnetold.gdb.it kernel: RBP: 00000011cb804000 R08:=20
0000000000000038 R09: 000000000000059a
gen 01 17:17:32 exnetold.gdb.it kernel: R10: 0000000000000000 R11:=20
0000000000000001 R12: ffff8b715f5d4000
gen 01 17:17:32 exnetold.gdb.it kernel: R13: 00000000fffffffe R14:=20
0000000000000000 R15: 00000000000005aa
gen 01 17:17:32 exnetold.gdb.it kernel: FS:  0000000000000000(0000)=20
GS:ffff8b717fa00000(0000) knlGS:0000000000000000
gen 01 17:17:32 exnetold.gdb.it kernel: CS:  0010 DS: 0000 ES: 0000 CR0:=20
0000000080050033
gen 01 17:17:32 exnetold.gdb.it kernel: CR2: 00007fdfdffffa08 CR3:=20
00000000b05b0000 CR4: 00000000000006f0
gen 01 17:17:32 exnetold.gdb.it kernel: Call Trace:
gen 01 17:17:32 exnetold.gdb.it kernel:  __btrfs_run_delayed_refs+0x216/0x1=
0b0=20
[btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel:  ? btrfs_free_tree_block+0x82/0x2c0=
=20
[btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel:  btrfs_run_delayed_refs+0x78/0x180=
=20
[btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel:  btrfs_should_end_transaction+0x3e/
0x60 [btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel:  btrfs_drop_snapshot+0x3cf/0x820=20
[btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel:  ? btree_submit_bio_start+0x20/0x20=
=20
[btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel: =20
btrfs_clean_one_deleted_snapshot+0xba/0xe0 [btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel:  cleaner_kthread+0x129/0x160 [btrfs]
gen 01 17:17:32 exnetold.gdb.it kernel:  kthread+0x112/0x130
gen 01 17:17:32 exnetold.gdb.it kernel:  ?=20
kthread_create_worker_on_cpu+0x70/0x70
gen 01 17:17:32 exnetold.gdb.it kernel:  ret_from_fork+0x35/0x40
gen 01 17:17:32 exnetold.gdb.it kernel: Code: 10 48 8b 40 50 f0 48 0f ba a8=
 30=20
23 00 00 02 0f 92 c0 41 59 84 c0 0f 85 cc a4 09 00 44 89 ee 48 c7 c7 98 9e =
75=20
c0 e8 58 33 a0 e7 <0f> 0b e9 b6 a4 09 00 48 89 df e8 bf 0c ff ff 49 8b 74 2=
4=20
28 4d=20
gen 01 17:17:32 exnetold.gdb.it kernel: ---[ end trace c4eefd1fdc016ceb ]---
gen 01 17:17:32 exnetold.gdb.it kernel: BTRFS: error (device sda3) in=20
__btrfs_free_extent:7007: errno=3D-2 No such entry
gen 01 17:17:32 exnetold.gdb.it kernel: BTRFS info (device sda3): forced=20
readonly
gen 01 17:17:33 exnetold.gdb.it kernel: BTRFS: error (device sda3) in=20
btrfs_run_delayed_refs:3076: errno=3D-2 No such entry


]zac[
> >> It also means that the subvolume is never going to disappear during th=
is
> >> mount and 'btrfs subvol sync' will wait forever.
> >=20
> > ]zac[
> >=20
> > In my opinion this is bad.
>=20
> Agreed.  I was describing what the situation is, not how it should be.

Ok, sorry ( :) ).

]zac[
> It's something that needs fixing.  The question is how to go about that.
>  My first take on it is to have that loop also check whether the file
]zac[

I don't know how btrfs works inside.
I just suppose that somewhere in the code an error state is not handled=20
correctly (which can be a file or the whole filesystem not accessible).


Gdb


