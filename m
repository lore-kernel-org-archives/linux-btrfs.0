Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60376 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753072AbdHNMR2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 08:17:28 -0400
Received: from [10.10.11.239] ([80.171.87.178]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LbyUS-1dHp7i3FlU-00jLVi for
 <linux-btrfs@vger.kernel.org>; Mon, 14 Aug 2017 14:17:26 +0200
To: linux-btrfs@vger.kernel.org
From: Hallo32 <Hallo32@gmx.net>
Subject: btrfs-progs-v4.12: cross compiling
Message-ID: <e8d480c6-758e-0e7d-a024-e9d12d7bf852@gmx.net>
Date: Mon, 14 Aug 2017 14:17:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello at all,

I'm new at this list. If the mail is not in line with your standards 
please inform me.

Since versions 4.12 btrfs-progs is complicated to cross compile for 
other systems.
The problem is, that this version includes mktables, which needs to be 
compiled for the host system and executed there for the creation of 
tables.c.

Are there any changes planed for the next version of btrfs-progs to make 
the cross compiling as simple as in the past? A included tables.c for 
example?

Best regards
