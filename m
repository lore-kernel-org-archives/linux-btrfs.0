Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD64C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 06:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7426920841
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 06:36:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="Xfjagv7T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7426920841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbeJKOB4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 10:01:56 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42151 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbeJKOB4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 10:01:56 -0400
Received: by mail-lj1-f194.google.com with SMTP id y71-v6so7143525lje.9
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Oct 2018 23:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=vbs+yaWX8YxsaYps6jS8YfhMkmN8lWuF53uOqxg+j+0=;
        b=Xfjagv7TtcxJLF2TkajMy8IHBtxLPTVNINtfLzZRZblZN/Ul7iyf4BSfShCxodqqyg
         w3LJOFVXc2rTqNvl+vsEN/XL8Y2DSdEiKeKwbl2aXaReHiPcOwcIq/IxFUMFp+1jbg4Y
         2lhsSBYB8X88roQRs/4kVevn75UzzBRJbu5bdSHhA6RcBj3f9LhNQ9snLYPXS3P3RS4F
         OJzBrCXB7QOnPJrdhMuXQh0jkILqsUDVJFSQ2YKvOzwHuwb93Nj6477+bAumyobs/4ka
         NFsmI/s5W0ZPvz6S/8CGyW3VUMt66JEBqV6Hu6jXIjukOiZCARxpZpTP51mXymLIjJak
         T8tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=vbs+yaWX8YxsaYps6jS8YfhMkmN8lWuF53uOqxg+j+0=;
        b=BaNvQ6TIZ1PP2lDwuRlC80M0DnP0WASwOwsPtcqYYP0ybN75fVmQbA0CCqeInIFixR
         sDf85+wvN1DnfetmxFP4KQcPkE4nuC3Pfhwa1vNiVf1bmmAVYPUI+O19V65ltXuEudAJ
         AlSVrWKRxWlLceLy6rTvw3GQ3O0j3nlwjHyH8kvQzf2IoNFsDqLLgMrO8eLbSq9kAza0
         TGg4bbbPyJqT56dxIiQDbfwiOPSPr6svrxI68JPW19ArPmNPajENaaf15LgTfzL12rvs
         5h7ztDVgn8HEdDXdYD6PLTwg8LtF6TB7BikR5qGDw0ZA7IIeswjXU8UW70zZRZB+A6c9
         3dDA==
X-Gm-Message-State: ABuFfohlCi48spAJQkafw6Wu5nxS4ULddQfbvzZ3PlCbW/V/+427LlZw
        6OdVMmCmgQ+ZP1RRluXIsoHFyBZY6kPL8PhdkDHQ+PCT7z0=
X-Google-Smtp-Source: ACcGV60LXHmTsl3GoM4zETog2bEnRObGS/f0hJF2E+sG5XvRZwaUQDMDrB2VNjtN7pbh/iEwhKSWs5UWeuVKqXPk8Cg=
X-Received: by 2002:a2e:4408:: with SMTP id r8-v6mr248050lja.21.1539239764946;
 Wed, 10 Oct 2018 23:36:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Wed, 10 Oct 2018 23:36:04
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 11 Oct 2018 00:36:04 -0600
X-Google-Sender-Auth: pATg5Lnba63Yx0KT7DoUg2o98jc
Message-ID: <CAJCQCtTG3Vt=sZT-LiBNg1Upu+9=j4nkxXkvm19XOmQXh7vh6g@mail.gmail.com>
Subject: fail to read only scrub, WARNING: at fs/btrfs/transaction.c:1847 cleanup_transaction
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs-progs 4.17.1
kernel 4.18.12

I've got another Samsung SDHC card that's gone read only, and any
writes cause it to hang. So I've use blockdev --setro on all the
partitions and block device to make sure nothing can write to it, and
then mount with

# mount -o ro,nologreplay /dev/mmcblk0p3 /mnt/sd

There is a log tree entry in the super. Next I want to do a scrub to
see if there are any corruptions detected. I'm curious if any
corruptions have happened in transactions near the time the device
failed and went read only.

# btrfs scrub start -Bdr /mnt/sd

And that results in a warning and call trace. Seems like a bug.

[97696.976887] mmc0: new ultra high speed SDR104 SDHC card at address 59b4
[97696.980825] mmcblk0: mmc0:59b4 EB2MW 29.8 GiB
[97696.996102]  mmcblk0: p1 p2 p3
[100363.736000] r8169 0000:03:00.0: invalid large VPD tag 7f at offset 0
[103726.761878] BTRFS info (device mmcblk0p3): disabling log replay at
mount time
[103726.764476] BTRFS info (device mmcblk0p3): using free space tree
[103726.767036] BTRFS info (device mmcblk0p3): has skinny extents
[103726.811136] BTRFS info (device mmcblk0p3): enabling ssd optimizations
[103780.058008] BTRFS warning (device mmcblk0p3): Skipping commit of
aborted transaction.
[103780.065633] ------------[ cut here ]------------
[103780.070470] BTRFS: Transaction aborted (error -28)
[103780.070631] WARNING: CPU: 0 PID: 6670 at
fs/btrfs/transaction.c:1847 cleanup_transaction+0x8a/0xd0 [btrfs]
[103780.075561] Modules linked in: mmc_block veth xt_nat
ipt_MASQUERADE xt_addrtype br_netfilter bridge stp llc ccm
nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter
ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_nat ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat iptable_mangle iptable_raw
iptable_security nf_conntrack ip_set nfnetlink ebtable_filter ebtables
ip6table_filter ip6_tables sunrpc vfat fat arc4 intel_rapl iwlmvm
intel_powerclamp coretemp mac80211 kvm_intel kvm snd_hda_codec_hdmi
irqbypass btusb snd_hda_codec_realtek iwlwifi crct10dif_pclmul
snd_hda_codec_generic btrtl btbcm crc32_pclmul ghash_clmulni_intel
btintel bluetooth iTCO_wdt iTCO_vendor_support
[103780.097996]  intel_cstate cfg80211 snd_hda_intel snd_hda_codec
ecdh_generic intel_xhci_usb_role_switch roles rfkill ir_rc6_decoder
snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm rc_rc6_mce
mei_txe mei ite_cir snd_timer snd rc_core pcc_cpufreq soundcore
intel_int0002_vgpio i2c_i801 lpc_ich dm_crypt btrfs libcrc32c xor
zstd_decompress zstd_compress xxhash raid6_pq i915 i2c_algo_bit
crc32c_intel drm_kms_helper sdhci_pci drm cqhci r8169 sdhci mii
mmc_core video pwm_lpss_platform pwm_lpss lz4 lz4_compress
[103780.117383] CPU: 0 PID: 6670 Comm: btrfs-transacti Not tainted
4.18.12-300.fc29.x86_64 #1
[103780.123984] Hardware name:  /NUC5PPYB, BIOS
PYBSWCEL.86A.0074.2018.0709.1332 07/09/2018
[103780.130401] RIP: 0010:cleanup_transaction+0x8a/0xd0 [btrfs]
[103780.136079] Code: 83 f8 01 77 63 f0 48 0f ba ab 08 23 00 00 02 72
1b 41 83 fc fb 0f 84 45 30 08 00 44 89 e6 48 c7 c7 70 6f 6c c0 e8 60
1f a8 ec <0f> 0b 44 89 e1 ba 37 07 00 00 4d 8d 65 28 48 89 ef 48 c7 c6
70 b0
[103780.142943] RSP: 0018:ffffb45401483dd0 EFLAGS: 00010286
[103780.150032] RAX: 0000000000000000 RBX: ffff90d8f4724000 RCX:
0000000000000006
[103780.157155] RDX: 0000000000000007 RSI: 0000000000000086 RDI:
ffff90d93fc16930
[103780.164218] RBP: ffff90d928f99750 R08: 0000000000000038 R09:
0000000000000007
[103780.171238] R10: 0000000000000000 R11: 0000000000000001 R12:
00000000ffffffe4
[103780.178171] R13: ffff90d8c44ce600 R14: 00000000ffffffe4 R15:
ffff90d8f4725df8
[103780.185134] FS:  0000000000000000(0000) GS:ffff90d93fc00000(0000)
knlGS:0000000000000000
[103780.192265] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[103780.199458] CR2: 000055764829c720 CR3: 000000017420a000 CR4:
00000000001006f0
[103780.206756] Call Trace:
[103780.214090]  ? finish_wait+0x80/0x80
[103780.221519]  btrfs_commit_transaction+0x86d/0x8b0 [btrfs]
[103780.228946]  ? join_transaction+0x22/0x3e0 [btrfs]
[103780.236448]  ? start_transaction+0x9c/0x3e0 [btrfs]
[103780.243856]  transaction_kthread+0x155/0x170 [btrfs]
[103780.251166]  ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[103780.258368]  kthread+0x112/0x130
[103780.265481]  ? kthread_create_worker_on_cpu+0x70/0x70
[103780.272535]  ret_from_fork+0x35/0x40
[103780.279436] ---[ end trace 7470f1b607c73b6c ]---
[103780.285841] BTRFS warning (device mmcblk0p3):
cleanup_transaction:1847: Aborting unused transaction(No space left).
[103780.289891] BTRFS info (device mmcblk0p3): delayed_refs has NO entry


-- 
Chris Murphy
