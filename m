Return-Path: <SRS0=H1hn=QQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A717C282C4
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 19:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 683B120844
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 19:43:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dMeC2xUt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfBITnQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 Feb 2019 14:43:16 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45680 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbfBITnP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2019 14:43:15 -0500
Received: by mail-ot1-f66.google.com with SMTP id 32so11398474ota.12
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Feb 2019 11:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=kLWnKJctSaZ/FDGu9ZnM00Shi5wfTFqQNK9hpFAcIew=;
        b=dMeC2xUtBs4+hsTGSXhho2pkVufqni3NJ1YUr+H7ydGb1QSYGV7W4jcMYLLqAuTnMM
         pHMdzvCf77Vgbgv/us9GGdxId/3RClApwWoE+GmoQSRPmERtPJVUHS4SbqoyJBhQFW11
         f/paGh0X9MK44IjzjkfA95V/Rwq9F8+yZvb6xF26AX3WGmsHZnagtQGLrA9LOJM0m36r
         vW+gRgmPLd++RUvRbWt7btbKpR4y6pMsa7RHjD+IGWKD/Duc9GwVfYVOU0LxgxyDnuc+
         HAkKpcZU2NyE5kHh4k4TvTIoOM6pdHrBiePvJMlD+9bIukl6w3f8LlaLYTIH1pH6NC05
         6ntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=kLWnKJctSaZ/FDGu9ZnM00Shi5wfTFqQNK9hpFAcIew=;
        b=pC0e6oa2BOvAG/nt9icpbWsftbJoUbYFavjzdBQmgDSxtu7h581g57jyErt2RmdSb7
         GMgXay4FhMhexKLt+XJjV5yXaSlxOKTEcJtcpBsHgAIvJfpqElwD0aNkDdCGURJ6/b32
         UMhXhfceAaQhonQgu6EKyP8gQrTbfZXipCnLlK69VEqSe2X5vxegk86qdXzmrpB8JCqx
         GzPcSMtRO8SoDZosJ804D+di91qRm3tj0gqvS7vvk2VE+X19DGwgY0Va0TJROmAzYL27
         thPTURA9JgXY+WU6oBuLsERMDiG/bSuYvEg983CC8rWN8odyvMYEbHwRG6WInAuVIml4
         SzVA==
X-Gm-Message-State: AHQUAuaRbOcK3X6W41er5YhJeCtSENkAl8Xl77zaJINThij+rJ7SYI+0
        bECllNKDKvd3yHa0oUdP+GE/r1L+5xHFDeXcRv1cOvFA
X-Google-Smtp-Source: AHgI3IbaMUVj3zEzYRt8DT3RHsHlsHL54ZlNYmoug6kXGmqGpj6mIy6i1c7f8Q71sLvNd9MC/dn7dQ6ktl3Rw1NKNSo=
X-Received: by 2002:a9d:aa9:: with SMTP id 38mr20799484otq.255.1549741394564;
 Sat, 09 Feb 2019 11:43:14 -0800 (PST)
MIME-Version: 1.0
From:   Rosen Penev <rosenp@gmail.com>
Date:   Sat, 9 Feb 2019 11:43:03 -0800
Message-ID: <CAKxU2N-Voa2XTo3SS6S0r85zzgaWsAAkU3=L82z=0WCdOfyfzA@mail.gmail.com>
Subject: Filesystem corruption under big endian MIPS
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I'm getting this error every time I mount and use my drive

[63046.831194] sd 0:0:0:0: [sda] 1953525167 512-byte logical blocks:
(1.00 TB/932 GiB)
[63047.049574] sd 0:0:0:0: [sda] Write Protect is off
[63047.054515] sd 0:0:0:0: [sda] Mode Sense: 4f 00 00 00
[63047.060695] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[63047.104844] sd 0:0:0:0: [sda] Attached SCSI disk
[63047.143149] BTRFS info (device sda): disk space caching is enabled
[63047.149467] BTRFS info (device sda): has skinny extents
[63047.307663] BTRFS info (device sda): checking UUID tree
[63077.308608] BTRFS error (device sda): tree block 20971520 owner 3
already locked by pid=5693, extent tree corruption detected
[63077.320308] ------------[ cut here ]------------
[63077.325291] WARNING: CPU: 0 PID: 5693 at fs/btrfs/volumes.c:2792
btrfs_remove_chunk+0x4c8/0xa6c [btrfs]
[63077.334888] BTRFS: Transaction aborted (error -135)
[63077.339842] Modules linked in: ath9k ath9k_common pppoe ppp_async
iptable_nat ipt_MASQUERADE ath9k_hw ath10k_pci ath10k_core ath
xt_state xt_nat xt_conntrack xt_REDIRECT xt_FLOWOFFLOAD pppox
ppp_generic nf_nat_ipv4 nf_nat nf_flow_table_hw nf_flow_table
nf_conntrack_rtcache nf_conntrack mac80211 ipt_REJECT cfg80211 xt_time
xt_tcpudp xt_multiport xt_mark xt_mac xt_limit xt_comment xt_TCPMSS
xt_LOG wireguard slhc nf_reject_ipv4 nf_log_ipv4 nf_defrag_ipv6
nf_defrag_ipv4 lzo iptable_mangle iptable_filter ip_tables crc_ccitt
compat ledtrig_usbport ip6t_REJECT nf_reject_ipv6 nf_log_ipv6
nf_log_common ip6table_mangle ip6table_filter ip6_tables x_tables
msdos ip6_udp_tunnel udp_tunnel sit tunnel4 ip_tunnel vfat fat cifs
nls_utf8 nls_iso8859_1 nls_cp437 sha256_generic md5 md4 hmac ecb
des_generic crypto_acompress
[63077.412357]  usb_storage ehci_platform sd_mod scsi_mod ehci_hcd
gpio_button_hotplug f2fs ext4 jbd2 mbcache btrfs zstd_decompress
zstd_compress zlib_inflate zlib_deflate xxhash xor raid6_pq
lzo_decompress lzo_compress libcrc32c usbcore nls_base usb_common
crc16 aead crypto_null crc32c_generic cryptomgr crc32_generic
crypto_hash
[63077.442011] CPU: 0 PID: 5693 Comm: btrfs-cleaner Not tainted 4.19.19 #0
[63077.448832] Stack : 00000000 86848688 87f9e0a0 800b1758 00000000
00000000 00000000 9c5b991a
[63077.457325]         8052f41c 8689bce4 80560000 8055ba27 804fefe8
00000001 8689bc88 9c5b991a
[63077.465880]         00000000 00000000 806e0000 00006460 00000000
00000000 00000008 00000000
[63077.474390]         00000135 a2000000 00000134 00000000 80560000
00000000 872ec7c0 872746b4
[63077.482950]         00000009 00000ae8 00000000 86848688 00000002
80298f44 00000000 806b0000
[63077.491460]         ...
[63077.493943] Call Trace:
[63077.496481] [<8006b1e8>] show_stack+0x68/0x128
[63077.501021] [<80081d34>] __warn+0xe4/0x118
[63077.505177] [<80081da8>] warn_slowpath_fmt+0x40/0x64
[63077.510407] [<872746b4>] btrfs_remove_chunk+0x4c8/0xa6c [btrfs]
[63077.516632] [<87228720>] btrfs_delete_unused_bgs+0x420/0x430 [btrfs]
[63077.523421] [<87232020>] btree_get_extent+0xac4/0x22ec [btrfs]
[63077.529693] [<87231f30>] btree_get_extent+0x9d4/0x22ec [btrfs]
[63077.535757] ---[ end trace c60950f6e49f8b83 ]---
[63077.540484] BTRFS: error (device sda) in btrfs_remove_chunk:2792:
errno=-135 unknown
[63077.548465] BTRFS info (device sda): forced readonly

After the panic, the drive becomes unmountable, even on little endian machines.

[62211.705357] BTRFS: device label Archive devid 1 transid 49152 /dev/sdg
[62211.720858] BTRFS info (device sdg): disk space caching is enabled
[62211.733227] BTRFS info (device sdg): has skinny extents
[62212.262099] BTRFS error (device sdg): parent transid verify failed
on 998424576 wanted 49152 found 49153
[62212.292076] BTRFS error (device sdg): parent transid verify failed
on 998424576 wanted 49152 found 49153
[62212.310992] BTRFS error (device sdg): failed to read block groups: -5
[62212.452527] BTRFS error (device sdg): open_ctree failed

I restored using btrfs check --init-extent-tree but same issue happens.
