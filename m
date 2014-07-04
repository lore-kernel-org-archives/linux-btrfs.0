Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41890 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750839AbaGDEQu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 00:16:50 -0400
Message-ID: <53B62B22.3060404@cn.fujitsu.com>
Date: Fri, 4 Jul 2014 12:18:42 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, Chris Mason <clm@fb.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix wrong uevent target
References: <1404291834-11113-1-git-send-email-miaox@cn.fujitsu.com> <53B539CE.7070201@cn.fujitsu.com> <53B56211.4060403@fb.com> <53B5939B.2050808@oracle.com>
In-Reply-To: <53B5939B.2050808@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 4 Jul 2014 01:32:11 +0800, Anand Jain wrote:
> Chris,
> 
>   This fix is theoretically correct but my guess that this would
>   solve problem as reported by Qu Wenruo was wrong [1].
>   Patch is good to integrate.
> 
> Thanks, Anand
> 
> [1] Re: [PATCH RFC] btrfs: Add ctime/mtime update for btrfs device add/remove.

I have merged this patch(just change the changelog) and other important bug fix patches
into my tree to make it easier to be merged into Chris's for-linus branch. The URL is

  https://github.com/miaoxie/linux-btrfs.git for-3.16-rcX

But because there are some old patches in the current for-linus branch, if someone want to
merge my branch to for-linus, he/she must reset for-linus branch to

  commit 2aa06a35d06a34b3109bdbf1d653de1695dc8f12
  Author: Eric Sandeen <sandeen@redhat.com>
  Date:   Fri Jun 27 16:50:31 2014 -0500

    btrfs: fix nossd and ssd_spread mount option regression

then can pull my branch and merge it into for-linus branch directly.

Thanks
Miao

> On 03/07/2014 22:00, Chris Mason wrote:
>> On 07/03/2014 07:09 AM, Miao Xie wrote:
>>> CC Anand Jain
>>>
>>> Sorry, please ignore this patch.
>>> Anand wrote the same patch several days ago, so this bug fix belongs to Anand
>>> though he NACKed his patch at that time.
>>
>> It certainly looks right, but Anand had mentioned that he had a few
>> questions on testing.  I've pulled it out for now, but I'll take Anand's
>> version when you're both happy.
>>
>> -chris
> 

