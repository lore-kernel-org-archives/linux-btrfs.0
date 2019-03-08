Return-Path: <SRS0=LIGD=RL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED87C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 17:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 503FD20851
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 17:12:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XTvBl0ej"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfCHRMP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:12:15 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35155 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbfCHRMP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Mar 2019 12:12:15 -0500
Received: by mail-lf1-f67.google.com with SMTP id h6so10554337lfc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Mar 2019 09:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=r21mDP4Zu7wmRX4z4W7OR4Gj4IbfZ6i1Nq6r5K0sKI0=;
        b=XTvBl0ejqHC1QxNzQab2zM/r8rJW7lPARaweUpl5lvDEBC2AyQtS1bcq+O4Z59u49O
         Sl8q9VPx5z63QbEZk6APPQQNnfNjeIxij3R+fm4ZMO9cQNgGL8YGtwaz8QOGZ1xnRJ/k
         nmpT8U9i+eMk5m/B1WPf0vmEeAXRIadxRePxDQB/buXnibzC/nbTLk7q42WUm3d7vYU7
         TTlNw2iXrADA2OcxMb9QLt+6R2G++5DpibMCLy6viqWLCiVA0oYVyTW8Fg+JO/+xwt6e
         pWex+kCLRR3H8w6yD/pCStUbdAAzigYSBdURspCWBApmdgrIoQP3ikt86AAn6emLbhm4
         auZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=r21mDP4Zu7wmRX4z4W7OR4Gj4IbfZ6i1Nq6r5K0sKI0=;
        b=TvsXTIHr+9k/oqcjP/sKbh/IUl0K7Cg6gbntuWsCOYK1zFzmwrrScDg0F/RxWMH/B9
         1N6jfUQgfIAVBbhvmNHL5WIZUoVDKgfpUVBlvfJMdDrrz8ow/ld34+nWaPsgxhSPCoJD
         xtDQnf2eDx8f17QD5T8K+wMRy3oF6gPWLmZ5aE5J9be0CMJtQfvuP03O7oMVie1QQ2BT
         QhGIseKzd9PGx5Dxvws2qYnmH4YywPjxxNR8RAclo/6JtG8nbs4UNVI6kJkeNFcP28EF
         PPGVEIan7iLkqnxPr8uFkhi040n9Ty7MTE0IGhEzQ+u3piE1vAivpt9k+oeMEL71djDY
         aTfQ==
X-Gm-Message-State: APjAAAW5lALyIE4eWh+BSXDfwSYC0ls75STpvDuuqzQ8i1/aW4TPyMpy
        iL+gVwKSrI3EzDSEJ4ymsidJXbIB5qgFscn/E4+/MsTa
X-Google-Smtp-Source: APXvYqxJoeQ6YQNbQr8chYT4sPFa0TbyT3LF5t+CA17/0KzWH6bpxtZ0DI5CYKZZChBlCif/xSesmeQK3YHsKChLZU8=
X-Received: by 2002:a19:520e:: with SMTP id m14mr10669962lfb.64.1552065131561;
 Fri, 08 Mar 2019 09:12:11 -0800 (PST)
MIME-Version: 1.0
References: <CAJheHN2P=pNm6cekEvdb53mQKD+t=6GP=HHbvRhW8M9hY7dphg@mail.gmail.com>
In-Reply-To: <CAJheHN2P=pNm6cekEvdb53mQKD+t=6GP=HHbvRhW8M9hY7dphg@mail.gmail.com>
From:   Tyler Richmond <t.d.richmond@gmail.com>
Date:   Fri, 8 Mar 2019 12:12:00 -0500
Message-ID: <CAJheHN3ddbgfEH6_oFET0qBb5mUu=6NW=WvM0FpoPsRV+zB4dQ@mail.gmail.com>
Subject: Re: Full balance put me in read only state
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I was getting some random hangs reading/writing to my FS, and I hadn't
done a full rebalance for a while. I took all of my services offline
and let the balance run for a few days. However, it appears to have
screwed me. Here's what my fs show looks like now:

    Total devices 6 FS bytes used 20537.65GiB
    devid    1 size 3726.02GiB used 3726.02GiB path /dev/sdf
    devid    2 size 4657.53GiB used 4221.02GiB path /dev/sdd
    devid    3 size 5589.03GiB used 4221.02GiB path /dev/sde
    devid    4 size 9314.00GiB used 4238.02GiB path /dev/sdg
    devid    5 size 9314.00GiB used 4237.05GiB path /dev/sdb
    devid    6 size 9314.00GiB used 4236.05GiB path /dev/sdc
It looks like the balance tried to put the same amount of data onto
all my drives in the RAID5 array, but it tried to overload my 4tb
drive. Right at the bottom of balance log in dmesg, we get this:

[458377.796526] BTRFS: Transaction aborted (error -28)
[458377.796627] WARNING: CPU: 5 PID: 6353 at
fs/btrfs/extent-tree.c:6831 __btrfs_free_extent.isra.77+0x272/0x920
[btrfs]
[458377.796629] Modules linked in: veth xt_nat xt_tcpudp
ipt_MASQUERADE nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo
iptable_nat nf_nat_ipv4 xt_addrtype iptable_filter bpfilter
xt_conntrack nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
br_netfilter bridge stp llc nfsv3 rpcsec_gss_krb5 nfsv4 nfs fscache
overlay nls_iso8859_1 intel_rapl x86_pkg_temp_thermal intel_powerclamp
coretemp kvm_intel cmdlinepart intel_spi_platform intel_spi spi_nor
mtd crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel
aes_x86_64 crypto_simd cryptd glue_helper intel_cstate intel_rapl_perf
joydev wmi_bmof input_leds lpc_ich mei_me mei ie31200_edac mac_hid
sch_fq_codel nfsd auth_rpcgss nfs_acl lockd lp grace parport sunrpc
ip_tables x_tables autofs4 btrfs xor zstd_compress raid6_pq libcrc32c
hid_generic usbhid hid i915 kvmgt vfio_mdev mdev vfio_iommu_type1 vfio
kvm irqbypass i2c_algo_bit drm_kms_helper syscopyarea sysfillrect
sysimgblt fb_sys_fops drm drm_panel_orientation_quirks cfbfillrect
cfbimgblt
[458377.796700]  cfbcopyarea fb ahci e1000e libahci fbdev megaraid_sas
i2c_core wmi video
[458377.796715] CPU: 5 PID: 6353 Comm: btrfs-transacti Not tainted
4.20.12-042012-generic #201902230431
[458377.796717] Hardware name: server1
[458377.796753] RIP: 0010:__btrfs_free_extent.isra.77+0x272/0x920 [btrfs]
[458377.796756] Code: 88 48 8b 40 50 f0 48 0f ba a8 18 ce 00 00 02 72
1b 41 83 fd fb 0f 84 57 3e 09 00 44 89 ee 48 c7 c7 38 84 99 c0 e8 10
9c 1a fa <0f> 0b 48 8b 7d 88 44 89 e9 ba af 1a 00 00 48 c7 c6 a0 dc 98
c0 e8
[458377.796759] RSP: 0018:ffffa03b839b3aa0 EFLAGS: 00010286
[458377.796762] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000006
[458377.796764] RDX: 0000000000000007 RSI: 0000000000000082 RDI:
ffff8b9f92b56440
[458377.796766] RBP: ffffa03b839b3b50 R08: 0000000000000001 R09:
00000000000044b5
[458377.796768] R10: 0000000000000004 R11: 0000000000000000 R12:
ffff8b9e03843770
[458377.796770] R13: 00000000ffffffe4 R14: 0000000000000000 R15:
0000000000000002
[458377.796774] FS:  0000000000000000(0000) GS:ffff8b9f92b40000(0000)
knlGS:0000000000000000
[458377.796776] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[458377.796779] CR2: 00007f0e3efa5458 CR3: 00000002a040a001 CR4:
00000000001606e0
[458377.796781] Call Trace:
[458377.796822]  btrfs_run_delayed_refs_for_head+0x450/0x950 [btrfs]
[458377.796860]  __btrfs_run_delayed_refs+0xa1/0x770 [btrfs]
[458377.796897]  btrfs_run_delayed_refs+0x73/0x190 [btrfs]
[458377.796933]  btrfs_write_dirty_block_groups+0x152/0x360 [btrfs]
[458377.796969]  ? btrfs_run_delayed_refs+0xa8/0x190 [btrfs]
[458377.797007]  commit_cowonly_roots+0x21a/0x2c0 [btrfs]
[458377.797047]  btrfs_commit_transaction+0x32f/0x840 [btrfs]
[458377.797056]  ? wait_woken+0x80/0x80
[458377.797096]  transaction_kthread+0x15c/0x190 [btrfs]
[458377.797103]  kthread+0x120/0x140
[458377.797141]  ? btrfs_cleanup_transaction+0x570/0x570 [btrfs]
[458377.797146]  ? __kthread_parkme+0x70/0x70
[458377.797153]  ret_from_fork+0x35/0x40
[458377.797157] ---[ end trace 209a46001fa5c74e ]---
[458377.797219] BTRFS: error (device sdf) in __btrfs_free_extent:6831:
errno=3D-28 No space left
[458377.797228] BTRFS: error (device sdf) in btrfs_drop_snapshot:9126:
errno=3D-28 No space left
[458377.797373] BTRFS info (device sdf): forced readonly
[458377.797504] BTRFS: error (device sdf) in merge_reloc_roots:2429:
errno=3D-28 No space left
[458377.797507] BTRFS: error (device sdf) in
btrfs_run_delayed_refs:2978: errno=3D-28 No space left
[458378.192126] BTRFS warning (device sdf): Skipping commit of aborted
transaction.
[458378.192130] BTRFS: error (device sdf) in cleanup_transaction:1849:
errno=3D-28 No space left
A reboot has restored write access... But is this how the balance is
supposed to work? I don't feel like this is the expected behavior. Is
it not going to have a negative impact on my system if that disk is
full and it's constantly shuffling data? I've been running it for a
week and while I haven't had it lock down, it becomes pretty slow to
respond during writes.



Linux server 4.20.12-042012-generic #201902230431 SMP Sat Feb 23
09:33:39 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

btrfs-progs v4.20.1
Data, RAID5: total=3D20.58TiB, used=3D20.43TiB
System, RAID1: total=3D32.00MiB, used=3D1.15MiB
Metadata, RAID1: total=3D25.00GiB, used=3D23.71GiB
GlobalReserve, single: total=3D512.00MiB, used=3D40.00KiB

Any help is appreciated!


On Fri, Mar 8, 2019 at 11:34 AM Tyler Richmond <t.d.richmond@gmail.com> wro=
te:
>
> I was getting some random hangs reading/writing to my FS, and I hadn't do=
ne a full rebalance for a while. I took all of my services offline and let =
the balance run for a few days. However, it appears to have screwed me. Her=
e's what my fs show looks like now:
>
>     Total devices 6 FS bytes used 20537.65GiB
>     devid    1 size 3726.02GiB used 3726.02GiB path /dev/sdf
>     devid    2 size 4657.53GiB used 4221.02GiB path /dev/sdd
>     devid    3 size 5589.03GiB used 4221.02GiB path /dev/sde
>     devid    4 size 9314.00GiB used 4238.02GiB path /dev/sdg
>     devid    5 size 9314.00GiB used 4237.05GiB path /dev/sdb
>     devid    6 size 9314.00GiB used 4236.05GiB path /dev/sdc
> It looks like the balance tried to put the same amount of data onto all m=
y drives in the RAID5 array, but it tried to overload my 4tb drive. Right a=
t the bottom of balance log in dmesg, we get this:
>
> [458377.796526] BTRFS: Transaction aborted (error -28)
> [458377.796627] WARNING: CPU: 5 PID: 6353 at fs/btrfs/extent-tree.c:6831 =
__btrfs_free_extent.isra.77+0x272/0x920 [btrfs]
> [458377.796629] Modules linked in: veth xt_nat xt_tcpudp ipt_MASQUERADE n=
f_conntrack_netlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_nat_ipv4 x=
t_addrtype iptable_filter bpfilter xt_conntrack nf_nat nf_conntrack nf_defr=
ag_ipv6 nf_defrag_ipv4 br_netfilter bridge stp llc nfsv3 rpcsec_gss_krb5 nf=
sv4 nfs fscache overlay nls_iso8859_1 intel_rapl x86_pkg_temp_thermal intel=
_powerclamp coretemp kvm_intel cmdlinepart intel_spi_platform intel_spi spi=
_nor mtd crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_=
x86_64 crypto_simd cryptd glue_helper intel_cstate intel_rapl_perf joydev w=
mi_bmof input_leds lpc_ich mei_me mei ie31200_edac mac_hid sch_fq_codel nfs=
d auth_rpcgss nfs_acl lockd lp grace parport sunrpc ip_tables x_tables auto=
fs4 btrfs xor zstd_compress raid6_pq libcrc32c hid_generic usbhid hid i915 =
kvmgt vfio_mdev mdev vfio_iommu_type1 vfio kvm irqbypass i2c_algo_bit drm_k=
ms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm drm_panel_orien=
tation_quirks cfbfillrect cfbimgblt
> [458377.796700]  cfbcopyarea fb ahci e1000e libahci fbdev megaraid_sas i2=
c_core wmi video
> [458377.796715] CPU: 5 PID: 6353 Comm: btrfs-transacti Not tainted 4.20.1=
2-042012-generic #201902230431
> [458377.796717] Hardware name: server1
> [458377.796753] RIP: 0010:__btrfs_free_extent.isra.77+0x272/0x920 [btrfs]
> [458377.796756] Code: 88 48 8b 40 50 f0 48 0f ba a8 18 ce 00 00 02 72 1b =
41 83 fd fb 0f 84 57 3e 09 00 44 89 ee 48 c7 c7 38 84 99 c0 e8 10 9c 1a fa =
<0f> 0b 48 8b 7d 88 44 89 e9 ba af 1a 00 00 48 c7 c6 a0 dc 98 c0 e8
> [458377.796759] RSP: 0018:ffffa03b839b3aa0 EFLAGS: 00010286
> [458377.796762] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000=
00000006
> [458377.796764] RDX: 0000000000000007 RSI: 0000000000000082 RDI: ffff8b9f=
92b56440
> [458377.796766] RBP: ffffa03b839b3b50 R08: 0000000000000001 R09: 00000000=
000044b5
> [458377.796768] R10: 0000000000000004 R11: 0000000000000000 R12: ffff8b9e=
03843770
> [458377.796770] R13: 00000000ffffffe4 R14: 0000000000000000 R15: 00000000=
00000002
> [458377.796774] FS:  0000000000000000(0000) GS:ffff8b9f92b40000(0000) knl=
GS:0000000000000000
> [458377.796776] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [458377.796779] CR2: 00007f0e3efa5458 CR3: 00000002a040a001 CR4: 00000000=
001606e0
> [458377.796781] Call Trace:
> [458377.796822]  btrfs_run_delayed_refs_for_head+0x450/0x950 [btrfs]
> [458377.796860]  __btrfs_run_delayed_refs+0xa1/0x770 [btrfs]
> [458377.796897]  btrfs_run_delayed_refs+0x73/0x190 [btrfs]
> [458377.796933]  btrfs_write_dirty_block_groups+0x152/0x360 [btrfs]
> [458377.796969]  ? btrfs_run_delayed_refs+0xa8/0x190 [btrfs]
> [458377.797007]  commit_cowonly_roots+0x21a/0x2c0 [btrfs]
> [458377.797047]  btrfs_commit_transaction+0x32f/0x840 [btrfs]
> [458377.797056]  ? wait_woken+0x80/0x80
> [458377.797096]  transaction_kthread+0x15c/0x190 [btrfs]
> [458377.797103]  kthread+0x120/0x140
> [458377.797141]  ? btrfs_cleanup_transaction+0x570/0x570 [btrfs]
> [458377.797146]  ? __kthread_parkme+0x70/0x70
> [458377.797153]  ret_from_fork+0x35/0x40
> [458377.797157] ---[ end trace 209a46001fa5c74e ]---
> [458377.797219] BTRFS: error (device sdf) in __btrfs_free_extent:6831: er=
rno=3D-28 No space left
> [458377.797228] BTRFS: error (device sdf) in btrfs_drop_snapshot:9126: er=
rno=3D-28 No space left
> [458377.797373] BTRFS info (device sdf): forced readonly
> [458377.797504] BTRFS: error (device sdf) in merge_reloc_roots:2429: errn=
o=3D-28 No space left
> [458377.797507] BTRFS: error (device sdf) in btrfs_run_delayed_refs:2978:=
 errno=3D-28 No space left
> [458378.192126] BTRFS warning (device sdf): Skipping commit of aborted tr=
ansaction.
> [458378.192130] BTRFS: error (device sdf) in cleanup_transaction:1849: er=
rno=3D-28 No space left
> A reboot has restored write access... But is this how the balance is supp=
osed to work? I don't feel like this is the expected behavior. Is it not go=
ing to have a negative impact on my system if that disk is full and it's co=
nstantly shuffling data? I've been running it for a week and while I haven'=
t had it lock down, it becomes pretty slow to respond during writes.
>
>
>
> Linux server 4.20.12-042012-generic #201902230431 SMP Sat Feb 23 09:33:39=
 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
>
> btrfs-progs v4.20.1
> Data, RAID5: total=3D20.58TiB, used=3D20.43TiB
> System, RAID1: total=3D32.00MiB, used=3D1.15MiB
> Metadata, RAID1: total=3D25.00GiB, used=3D23.71GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D40.00KiB
>
> Any help is appreciated!
