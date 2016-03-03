Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18974 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750908AbcCCGc7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 01:32:59 -0500
Subject: Re: [PATCH] Btrfs: fix loading of orphan roots leading to BUG_ON
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
References: <1456933778-7944-1-git-send-email-fdmanana@kernel.org>
 <pan$91701$3af360aa$c931211b$9c451328@cox.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56D7D925.8070004@cn.fujitsu.com>
Date: Thu, 3 Mar 2016 14:26:45 +0800
MIME-Version: 1.0
In-Reply-To: <pan$91701$3af360aa$c931211b$9c451328@cox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Duncan wrote on 2016/03/03 04:31 +0000:
> fdmanana posted on Wed, 02 Mar 2016 15:49:38 +0000 as excerpted:
>
>> When looking for orphan roots during mount we can end up hitting a
>> BUG_ON() (at root-item.c:btrfs_find_orphan_roots()) if a log tree is
>> replayed and qgroups are enabled.
>
> This should hit 4.6, right?  Will it hit 4.5 before release?
>
> Because I wasn't sure of current quota functionality status, but this bug
> obviously resets the counter on my ongoing "two kernel cycles with no
> known quota bugs before you try to use quotas" recommendation.

IMHO, btrfs quota is *functionally* stable.
Which means, its main function, quota accounting is stable, under almost 
all operation.

There will be some hidden corner like this one, which is not easy to 
spot during rework.
(Although it seems the regression is not caused by qgroup rework though)

>
> Meanwhile, what /is/ current quota feature status?  Other than this bug,
> is it now considered known bug free, or is more quota reworking and/or
> bug fixing known to be needed for 4.6 and beyond?

AFAIK, no planed rework for qgroup, and the most recent large qgroup 
modification is by Mark Fasheh, allowing btrfs subvolume remove to 
update qgroup accouting correctly, at Nov 2015.

>
> IOW, given that two release cycles no known bugs counter, are we
> realistically looking at that being 4.8, or are we now looking at 4.9 or
> beyond for reasonable quota stability?
>
Never heard the 2 release cycles principle, but seems to be not flex enough.
 From this point of view, every time Filipe(just an example, as he finds 
the most of bugs and corner case), some part or even the whole btrfs is 
not stable for 4 months.

Thanks,
Qu


