Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:23009 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751071AbdICSc4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 3 Sep 2017 14:32:56 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: speed up big btrfs volumes with ssds
Message-ID: <7318d2b7-73a0-1cc9-f9cc-e03314c19e85@profihost.ag>
Date: Sun, 3 Sep 2017 20:32:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

i'm trying to speed up big btrfs volumes.

Some facts:
- Kernel will be 4.13-rc7
- needed volume size is 60TB

Currently without any ssds i get the best speed with:
- 4x HW Raid 5 with 1GB controller memory of 4TB 3,5" devices

and using btrfs as raid 0 for data and metadata on top of those 4 raid 5.

I can live with a data loss every now and and than ;-) so a raid 0 on
top of the 4x radi5 is acceptable for me.

Currently the write speed is not as good as i would like - especially
for random 8k-16k I/O.

My current idea is to use a pcie flash card with bcache on top of each
raid 5.

Is this something which makes sense to speed up the write speed.

Greets,
Stefan
