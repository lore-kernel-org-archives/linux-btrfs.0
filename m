Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39592 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753299AbaKZPCb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 10:02:31 -0500
Date: Wed, 26 Nov 2014 10:02:23 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH v3 10/11] Btrfs: fix possible deadlock caused by pending
 I/O in plug list
To: Miao Xie <miaox@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1417014143.2258.0@mail.thefacebook.com>
In-Reply-To: <1417007091-11885-11-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1417007091-11885-1-git-send-email-miaox@cn.fujitsu.com>
 <1417007091-11885-11-git-send-email-miaox@cn.fujitsu.com>

On Wed, Nov 26, 2014 at 8:04 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> The increase/decrease of bio counter is on the I/O path, so we should
> use io_schedule() instead of schedule(), or the deadlock might be
> triggered by the pending I/O in the plug list. io_schedule() can help
> us because it will flush all the pending I/O before the task is going
> to sleep.

Can you please describe this deadlock in more detail?  schedule() also 
triggers a flush of the plug list, and if that's no longer sufficient 
we can run into other problems (especially with preemption on).

-chris

