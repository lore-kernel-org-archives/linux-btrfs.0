Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42651 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752861AbaK0C7A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 21:59:00 -0500
Message-ID: <547693D9.3040904@cn.fujitsu.com>
Date: Thu, 27 Nov 2014 11:00:41 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 10/11] Btrfs: fix possible deadlock caused by pending
 I/O in plug list
In-Reply-To: <547680EC.7030705@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1417007091-11885-1-git-send-email-miaox@cn.fujitsu.com>
 <1417007091-11885-11-git-send-email-miaox@cn.fujitsu.com>
 <1417014143.2258.0@mail.thefacebook.com>
 <547680EC.7030705@cn.fujitsu.com>

On Thu, 27 Nov 2014 09:39:56 +0800, Miao Xie wrote:
> On Wed, 26 Nov 2014 10:02:23 -0500, Chris Mason wrote:
>> On Wed, Nov 26, 2014 at 8:04 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>>> The increase/decrease of bio counter is on the I/O path, so we should
>>> use io_schedule() instead of schedule(), or the deadlock might be
>>> triggered by the pending I/O in the plug list. io_schedule() can help
>>> us because it will flush all the pending I/O before the task is going
>>> to sleep.
>>
>> Can you please describe this deadlock in more detail?  schedule() also triggers
>> a flush of the plug list, and if that's no longer sufficient we can run into other
>> problems (especially with preemption on).
> 
> Sorry for my miss. I forgot to check the current implementation of schedule(), which flushes the plug list unconditionally. Please ignore this patch.

I have updated my raid56-scrub-replace branch, please re-pull the branch.

  https://github.com/miaoxie/linux-btrfs.git raid56-scrub-replace

Thanks
Miao

> 
> Thanks
> Miao
> 
>>
>> -chris
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

