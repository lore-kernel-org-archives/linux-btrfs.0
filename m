Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:43633 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaBICkA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Feb 2014 21:40:00 -0500
Received: by mail-qc0-f176.google.com with SMTP id e16so8459092qcx.21
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 18:39:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391874396-2273-2-git-send-email-wangshilong1991@gmail.com>
References: <1391874396-2273-1-git-send-email-wangshilong1991@gmail.com>
	<1391874396-2273-2-git-send-email-wangshilong1991@gmail.com>
Date: Sun, 9 Feb 2014 10:39:59 +0800
Message-ID: <CAP9B-QmhqpCU76tYpikxUuW+LKKzN0atTUyVTAzv7fucLmb-1A@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] Revert "Btrfs: remove transaction from btrfs send"
From: Shilong Wang <wangshilong1991@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-02-08 23:46 GMT+08:00 Wang Shilong <wangshilong1991@gmail.com>:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> This reverts commit 41ce9970a8a6a362ae8df145f7a03d789e9ef9d2.
> Previously i was thinking we can use readonly root's commit root
> safely while it is not true, readonly root may be cowed with the
> following cases.
>
> 1.snapshot send root will cow source root.
> 2.balance,device operations will also cow readonly send root
> to relocate.
>
> So i have two ideas to make us safe to use commit root.
>
> -->approach 1:
> make it protected by transaction and end transaction properly and we research
> next item from root node(see btrfs_search_slot_for_read()).
>
> -->approach 2:
> add another counter to local root structure to sync snapshot with send.
> and add a global counter to sync send with exclusive device operations.
>
> So with approach 2, send can use commit root safely, because we make sure
> send root can not be cowed during send. Unfortunately, it make codes *ugly*
> and more complex to maintain.
>
> To make snapshot and send exclusively, device operations and send operation
> exclusively with each other is a little confusing for common users.
>
> So why not drop into previous way.
>
> Cc: Josef Bacik <jbacik@fb.com>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
> Josef, if we reach agreement to adopt this approach, please revert
> Filipe's patch(Btrfs: make some tree searches in send.c more efficient)
> from btrfs-next.

Oops, this patch guarantee searching commit roots are all protected by
transaction, Filipe's
patch is ok, we need update Josef's previous patch.

Wang
