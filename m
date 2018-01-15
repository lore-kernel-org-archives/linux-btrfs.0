Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:37317 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933019AbeAOJzp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 04:55:45 -0500
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: big volumes only work reliable with ssd_spread
Message-ID: <344ef7c2-404a-2f79-198c-9de8c5e31629@profihost.ag>
Date: Mon, 15 Jan 2018 10:55:42 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

since around two or three years i'm using btrfs for incremental VM backups.

some data:
- volume size 60TB
- around 2000 subvolumes
- each differential backup stacks on top of a subvolume
- compress-force=zstd
- space_cache=v2
- no quote / qgroup

this works fine since Kernel 4.14 except that i need ssd_spread as an
option. If i do not use ssd_spread i always end up with very slow
performance and a single kworker process using 100% CPU after some days.

With ssd_spread those boxes run fine since around 6 month. Is this
something expected? I haven't found any hint regarding such an impact.

Thanks!

Greets,
Stefan
