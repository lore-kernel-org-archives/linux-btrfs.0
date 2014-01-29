Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55826 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbaA2TBJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 14:01:09 -0500
Message-ID: <52E94FEA.5060404@fb.com>
Date: Wed, 29 Jan 2014 14:00:58 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>, <linux-btrfs@vger.kernel.org>
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: convert to add transaction protection for btrfs
 send
References: <1391009539-2326-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1391009539-2326-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/29/2014 10:32 AM, Wang Shilong wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> I sent a patch to kick off transaction from btrfs send, however it gets
> a regression that btrfs send try to search extent commit root without
> transaction protection.
>
> To fix this regression, we have two ideas:
>
>   1. don't use extent commit root for sending.
>
>   2. add transaction protection to use extent commit root safely.
>
> Both approaches need transaction actually, however, the first approach
> will add extent tree lock contention, so we'd better adopt the second
> approach.
>
> Luckily, now we only need transaction protection when iterating
> extent root, the protection's *range* is smaller than before.
So what is the problem exactly?  How does it show up and what are you 
doing to make it happen?  I'd really like to kill the transaction taking 
completely in the send path so I'd like to know what is going wrong so 
we can either take the extent commit semaphore and be satisfied that is 
ok or come up with a different solution.  Thanks,

Josef
