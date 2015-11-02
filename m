Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20458 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750788AbbKBBec (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Nov 2015 20:34:32 -0500
Subject: Re: Regression in: [PATCH 4/4] btrfs: qgroup: account shared subtree
 during snapshot delete
To: Stefan Priebe <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <mfasheh@suse.de>
References: <56367AE8.9030509@profihost.ag>
CC: <jbacik@fb.com>, Chris Mason <clm@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5636BDA0.4020200@cn.fujitsu.com>
Date: Mon, 2 Nov 2015 09:34:24 +0800
MIME-Version: 1.0
In-Reply-To: <56367AE8.9030509@profihost.ag>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Stefan Priebe wrote on 2015/11/01 21:49 +0100:
> Hi,
>
> this one: http://www.spinics.net/lists/linux-btrfs/msg47377.html
>
> adds a regression to my test systems with very large disks (30tb and 50tb).
>
> btrfs balance is super slow afterwards while heavily making use of cp
> --reflink=always on big files (200gb - 500gb).
>
> Sorry didn't know how to correctly reply to that "old" message.
>
> Greets,
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks for the testing.

Are you using qgroup or just doing normal balance with qgroup disabled?

For the latter case, that's should be optimized to skip the dirty extent 
insert in qgroup disabled case.

For qgroup enabled case, I'm afraid that's the design.
As relocation will drop a subtree to relocate, and to ensure qgroup 
consistent, we must walk down all the tree blocks and mark them dirty 
for later qgroup accounting.

But there should be some hope left for optimization.
For example, if all subtree blocks are already relocated, we can skip 
the tree down walk routine.

Anyway, for your case of huge files, as tree level grows rapidly, any 
workload involving tree iteration will be very time consuming.
Like snapshot deletion and relocation.

BTW, thanks for you regression report, I also found another problem of 
the patch.
I'll reply to the author to improve the patchset.

Thanks,
Qu
