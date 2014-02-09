Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:46867 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaBIOU6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Feb 2014 09:20:58 -0500
Received: by mail-qc0-f169.google.com with SMTP id w7so9053866qcr.28
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Feb 2014 06:20:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5D2ExCFFPeTFW7YzwfvxVW0f_4mTQDZi4SQHAfszmniQ@mail.gmail.com>
References: <1391874396-2273-1-git-send-email-wangshilong1991@gmail.com>
	<1391874396-2273-2-git-send-email-wangshilong1991@gmail.com>
	<CAP9B-QmhqpCU76tYpikxUuW+LKKzN0atTUyVTAzv7fucLmb-1A@mail.gmail.com>
	<CAL3q7H5D2ExCFFPeTFW7YzwfvxVW0f_4mTQDZi4SQHAfszmniQ@mail.gmail.com>
Date: Sun, 9 Feb 2014 22:20:57 +0800
Message-ID: <CAP9B-QngGOW-iDzj08QQRxANNYnMO8XcJ302NOWUnt=jXEsi3g@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] Revert "Btrfs: remove transaction from btrfs send"
From: Shilong Wang <wangshilong1991@gmail.com>
To: Filipe Manana <fdmanana@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>, Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-02-09 21:52 GMT+08:00 Filipe David Manana <fdmanana@gmail.com>:
> On Sun, Feb 9, 2014 at 2:39 AM, Shilong Wang <wangshilong1991@gmail.com> wrote:
>> 2014-02-08 23:46 GMT+08:00 Wang Shilong <wangshilong1991@gmail.com>:
>>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>
>>> This reverts commit 41ce9970a8a6a362ae8df145f7a03d789e9ef9d2.
>>> Previously i was thinking we can use readonly root's commit root
>>> safely while it is not true, readonly root may be cowed with the
>>> following cases.
>>>
>>> 1.snapshot send root will cow source root.
>>> 2.balance,device operations will also cow readonly send root
>>> to relocate.
>>>
>>> So i have two ideas to make us safe to use commit root.
>>>
>>> -->approach 1:
>>> make it protected by transaction and end transaction properly and we research
>>> next item from root node(see btrfs_search_slot_for_read()).
>>>
>>> -->approach 2:
>>> add another counter to local root structure to sync snapshot with send.
>>> and add a global counter to sync send with exclusive device operations.
>>>
>>> So with approach 2, send can use commit root safely, because we make sure
>>> send root can not be cowed during send. Unfortunately, it make codes *ugly*
>>> and more complex to maintain.
>>>
>>> To make snapshot and send exclusively, device operations and send operation
>>> exclusively with each other is a little confusing for common users.
>>>
>>> So why not drop into previous way.
>>>
>>> Cc: Josef Bacik <jbacik@fb.com>
>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>> ---
>>> Josef, if we reach agreement to adopt this approach, please revert
>>> Filipe's patch(Btrfs: make some tree searches in send.c more efficient)
>>> from btrfs-next.
>>
>> Oops, this patch guarantee searching commit roots are all protected by
>> transaction, Filipe's
>> patch is ok, we need update Josef's previous patch.
>
> Hi Shilong,
>
> I am confused. Can you explain why that optimization patch is a
> problem, either with or without your patch or any other patch
> currently flying around?
>
> Either before or after the optimization, we search through the commit
> root and after a key search we process a key while holding the leaf's
> extent buffer. Both approaches call btrfs_next_leaf too (either
> directly or via btrfs_search_slot_for_read).

Sorry my miss, your patch did not have problem, you did not notice
my following thread comments for this patch, we need update josef's previous
patch not yours. ^_^

Thanks,
Wang
>
> Thanks
>
>>
>> Wang
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
