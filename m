Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62221 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753409AbaK0BiR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 20:38:17 -0500
Message-ID: <547680EC.7030705@cn.fujitsu.com>
Date: Thu, 27 Nov 2014 09:39:56 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 10/11] Btrfs: fix possible deadlock caused by pending
 I/O in plug list
In-Reply-To: <1417014143.2258.0@mail.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1417007091-11885-1-git-send-email-miaox@cn.fujitsu.com>
 <1417007091-11885-11-git-send-email-miaox@cn.fujitsu.com>
 <1417014143.2258.0@mail.thefacebook.com>

On Wed, 26 Nov 2014 10:02:23 -0500, Chris Mason wrote:
> On Wed, Nov 26, 2014 at 8:04 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>> The increase/decrease of bio counter is on the I/O path, so we should
>> use io_schedule() instead of schedule(), or the deadlock might be
>> triggered by the pending I/O in the plug list. io_schedule() can help
>> us because it will flush all the pending I/O before the task is going
>> to sleep.
> 
> Can you please describe this deadlock in more detail?  schedule() also triggers
> a flush of the plug list, and if that's no longer sufficient we can run into other
> problems (especially with preemption on).

Sorry for my miss. I forgot to check the current implementation of schedule(), which flushes the plug list unconditionally. Please ignore this patch.

Thanks
Miao

> 
> -chris
> 
> 

