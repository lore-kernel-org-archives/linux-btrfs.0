Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:59553 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754830AbcJNG3N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 02:29:13 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: btrfs and numa - needing drop_caches to keep speed up
Message-ID: <818cbe6c-fe7a-7542-3bc8-76b205c9b80b@profihost.ag>
Date: Fri, 14 Oct 2016 08:28:30 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

while running the same workload on two machines (single xeon and a dual
xeon) both with 64GB RAM.

I need to run echo 3 >/proc/sys/vm/drop_caches every 15-30 minutes to
keep the speed as good as on the non numa system. I'm not sure whether
this is related to numa.

Is there any sysctl parameter to tune?

Tested with vanilla v4.8.1

Greets,
Stefan
