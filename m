Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:13225 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752367AbcIVGl4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 02:41:56 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: deadlock with btrfs heavy i/o and kswapd
Message-ID: <281582c9-1307-612e-77e6-9d768337ea3e@profihost.ag>
Date: Thu, 22 Sep 2016 08:41:52 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

i always encounter btrfs deadlocks / hung tasks, when i have a lot of
cached mem and i'm doing heavy rsync --inplace operations in my system
from btrfs zlib compressed disk A to btrfs zlib compressed disk B.

The last output i see in this case is kswapd0 running for a long time at
100% cpu. Then the whole system get's stuck. I cannot connect to ssh
anymore but the kernel still prints hung tasks every few minutes.

May be relevant the system has NO swap.

vm.vfs_cache_pressure = 100
vm.swappiness = 50

Greets,
Stefan
