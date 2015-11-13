Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37225 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbbKMKTi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 05:19:38 -0500
Message-ID: <5645B906.8030402@oracle.com>
Date: Fri, 13 Nov 2015 18:18:46 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/15] btrfs: Hot spare and Auto replace
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com> <5643F62D.6050703@cn.fujitsu.com>
In-Reply-To: <5643F62D.6050703@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Thanks for the comments.

> Let's take the following example:
>
> 1) 2 RAID1 + 1 spare
>     (A + B) + C
>
> 2) 3 RAID1
>     (A + B + C)

> At least in normal operation case, case 1) makes device C useless, and

  Yes.

> For case 2), we can just relocate and recover the bad chunks in B.
> It it should only need to copy 6G data.

  Case 2 is Wrong in the context of spare.

  Unless space usage is limited to 1/3 of total space.
  But when you do that, case 1 drawback will equally apply
  to case 2 as well.


 > It it should only need to copy 6G data.

   Its true as long as you don't replace the failed B
   and bring the configuration to its original. However
   when you do that,  Data  moved will be more than case 1.
   So this is not fully correct.

Thanks, Anand
