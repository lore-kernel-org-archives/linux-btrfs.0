Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31022 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab3BGFJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2013 00:09:33 -0500
Message-ID: <51133737.1020105@cn.fujitsu.com>
Date: Thu, 07 Feb 2013 13:10:15 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Arne Jansen <lists@die-jansens.de>
CC: Alex Lyakas <alex.btrfs@zadarastorage.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>, Arne Jansen <sensille@gmx.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Lev Vainblat <lev@zadarastorage.com>
Subject: Re: Leaking btrfs_qgroup_inherit on snapshot creation?
References: <CAOcd+r2V_Na-hn10GnV04MqjM=CcdrXTQrWSbKbp6S=mxKaTew@mail.gmail.com> <5112491F.3080100@die-jansens.de>
In-Reply-To: <5112491F.3080100@die-jansens.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On wed, 06 Feb 2013 13:14:23 +0100, Arne Jansen wrote:
> Hi Alex,
> 
> On 02/06/13 12:18, Alex Lyakas wrote:
>> Hi Jan, Arne,
>> I see this code in create_snapshot:
>>
>> 	if (inherit) {
>> 		pending_snapshot->inherit = *inherit;
>> 		*inherit = NULL;	/* take responsibility to free it */
>> 	}
>>
>> So, first thing I think it should be:
>> if (*inherit)
>> because in btrfs_ioctl_snap_create_v2() we have:
>> struct btrfs_qgroup_inherit *inherit = NULL;
>> ...
>> btrfs_ioctl_snap_create_transid(..., &inherit)
>>
>> so the current check is very unlikely to be NULL.
> 
> But in btrfs_ioctl_snap_create it is called with NULL, so *inherit would
> dereference a NULL pointer.
> 
>>
>> Second, I don't see anybody freeing pending_snapshot->inherit. I guess
>> it should be freed after callin btrfs_qgroup_inherit() and also in
>> btrfs_destroy_pending_snapshots().
> 
> You're right. In our original version (6f72c7e20dbaea5) it was still
> there, in transaction.c. It has been removed in 6fa9700e734:
> 
> commit 6fa9700e734275de2acbcb0e99414bd7ddfc60f1
> Author: Miao Xie <miaox@cn.fujitsu.com>
> Date:   Thu Sep 6 04:00:32 2012 -0600
> 
>     Btrfs: fix error path in create_pending_snapshot()
> 
>     This patch fixes the following problem:
>     - If we failed to deal with the delayed dir items, we should abort
> transaction,
>       just as its comment said. Fix it.
>     - If root reference or root back reference insertion failed, we should
>       abort transaction. Fix it.
>     - Fix the double free problem of pending->inherit.
>     - Do not restore the trans->rsv if we doesn't change it.
>     - make the error path more clearly.
> 
>     Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> 
> Miao, can you please explain where you see a double free?

Sorry, I misread the code，I didn't notice that the pointer had been assigned
to NULL.

But I think we can make the code more readable and be easy to maintain, we can
free the memory in the caller(btrfs_ioctl_snap_create_v2()) since we are sure
the snapshot creation is done after btrfs_ioctl_snap_create_transid() completes.

Thanks
Miao

