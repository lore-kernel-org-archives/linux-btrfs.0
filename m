Return-Path: <SRS0=NsLk=QI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29813C282D8
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Feb 2019 10:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB9FE20870
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Feb 2019 10:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbfBAK2G (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Feb 2019 05:28:06 -0500
Received: from mout.gmx.net ([212.227.15.18]:36283 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726450AbfBAK2F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Feb 2019 05:28:05 -0500
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0M1nbu-1hA3qQ1zek-00tgoU for
 <linux-btrfs@vger.kernel.org>; Fri, 01 Feb 2019 11:28:04 +0100
From:   Stefan K <shadow_7@gmx.net>
To:     linux-btrfs@vger.kernel.org
Subject: btrfs as / filesystem in RAID1
Date:   Fri, 01 Feb 2019 11:28:03 +0100
Message-ID: <33679024.u47WPbL97D@t460-skr>
User-Agent: KMail/5.2.3 (Linux/4.9.0-8-amd64; KDE/5.28.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:B/gKx8ahB8fiXaUCi3FGgqSEI5ucNzJUrUYHrqFaEC+fJoNCnUv
 BkCFASVsrPfm58srEP5Foc6LvgrtzMyICFWC9oapEpfYW+IukDUMQFHFxEoqO3HpSXgnNOY
 qLy5nA3f05Cl6JO5R4t3eX3st3bSb+S0qERTv/po1/TSPGVUguH0oNYmLEF/N1M3qGuH8bD
 7Tx4tMDk38aY4cPITXnnQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8lnvDjHFCjg=:3F8KWnx3vpktDk5aN2Z61l
 0HelL0Wspt56Jl6ChqeuuJ5BUzX2uSpBswMgtr3Kd/WmBMOD8PgAc8jF/Wwlonwbw8wKfApzh
 jt6398silKIDkbZqzOJVzok3Mis/zEzos+Yk4B812cYU7Z739LbzXF7ih0bw4+mOo8YPJK6xi
 fh1aBXXdEjK9YC+tfxl0cOGhxHrEJf4nQKF3Z0GbzyAF02v4DvdncVc9V3xoVFBRoLHFyzlQ5
 U9eEGrxHeNUIr/0wRY0txs8zpJKq16QNDSMf+sJNxDd+kIFAYfohQh8LgRMYDOZtwS3J48mPB
 Eb9xxMfYEhwE7YOP9HfZaPtq+IBrbdlRPbCdyitdUmPZcpYD+XYtyP2oH3Ld9DSx2ipFc1aAC
 MZOChXEtnlxotS++OIeKUWonjer5YMQc/UbxkfcxZbynGVs0aj0w4ABuBEzGRqRhmrzisB/dy
 MDht0vdRQaii38xPeBmhyExjDea/4f865CBcHc5otIrPUR9um7A3+1DXzpSl10UnyL45fYEc2
 P9Hi9RoFw73q4cqZXQc7vZ8WS0/QnFFj77sh83QH2BUGt1s7Jhk+ticOK659ty3ZssBozjnfq
 HJIgnFRp4tdwmAPIou8vavctELKvEcK+l5Pjfo/+VSpSdzslLDHnFyXvxNqSggvv3XBbv9Hz9
 YyWhBrOA3cdehfNUE+Lfhzuc6Pa2NiZPG2Beg4ypFqPAZGZ5MlXRdL8Vn8tbUgdob5PF0ynGO
 Ckwio6+MvcRaZ28nlGibhIvJnghecQmt0ahuQ2sUUEpKV9xmGpjmpRvKyfcvvgF6bFrBhCqhA
 OAYPaRp4VDYvQ/fyg24m+Oh6dlOtcd7OkokRn+P0CWdFyRVaMXEx2BL6rs4AyEnGxSfKwtz1Z
 ZJwCu3vBdM36whCKiHCw2aw/Tpk9uydjU3Ni1KL94Ohs2aqcgbG5dYLdhwhK9eH71Gzm/ORM0
 0hNLjK+MHQA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I've installed my Debian Stretch to have / on btrfs with raid1 on 2 SSDs. Today I want test if it works, it works fine until the server is running and the SSD get broken and I can change this, but it looks like that it does not work if the SSD fails until restart. I got the error, that one of the Disks can't be read and I got a initramfs prompt, I expected that it still runs like mdraid and said something is missing.

My question is, is it possible to configure btrfs/fstab/grub that it still boot? (that is what I expected from a RAID1)

best regards
Stefan
