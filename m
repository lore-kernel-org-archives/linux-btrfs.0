Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49691 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727127AbeIQS0f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Sep 2018 14:26:35 -0400
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MC7em-1gAeXx15s0-008qJg for
 <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2018 14:59:21 +0200
From: Stefan K <shadow_7@gmx.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs problems
Date: Mon, 17 Sep 2018 14:59:20 +0200
Message-ID: <2160568.XIGApFCfXs@t460-skr>
In-Reply-To: <405d08b1-9f22-1038-67c3-c055477029d4@gmx.com>
References: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com> <CAMrg+aTtyOSOnZMj+4q13f7pv9wMydFgTDZ5KLbQSRz8HHcbKw@mail.gmail.com> <405d08b1-9f22-1038-67c3-c055477029d4@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> If your primary concern is to make the fs as stable as possible, then
> keep snapshots to a minimal amount, avoid any functionality you won't
> use, like qgroup, routinely balance, RAID5/6.
> 
> And keep the necessary btrfs specific operations to minimal, like
> subvolume/snapshot (and don't keep too many snapshots, say over 20),
> shrink, send/receive.

hehe, that sound like "hey use btrfs, its cool, but please - don't use any btrfs specific feature" ;)

best
Stefan
