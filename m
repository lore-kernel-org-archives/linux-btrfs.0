Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:40832 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750902AbdEBG3l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 02:29:41 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: runtime btrfsck
Message-ID: <9267c96a-72a7-0726-d058-4b2589d7e73e@profihost.ag>
Date: Tue, 2 May 2017 08:29:38 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

i wanted to check an fs cause it has bad key ordering.

But btrfscheck is now running since 7 days. Current output:
# btrfsck -p --repair /dev/mapper/crypt_md0
enabling repair mode
Checking filesystem on /dev/mapper/crypt_md0
UUID: 37b15dd8-b2e1-4585-98d0-cc0fa2a5a7c9
bad key ordering 39 40
checking extents [O]

FS is a 12TB BTRFS Raid 0 over 3 mdadm Raid 5 devices. How long should
btrfsck run and is there any way to speed it up? btrfs tools is 4.8.5

Thanks!

Greets,
Stefan
