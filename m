Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42955 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751744AbaBJPlc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 10:41:32 -0500
Message-ID: <52F8F316.8070105@fb.com>
Date: Mon, 10 Feb 2014 10:41:10 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>, <linux-btrfs@vger.kernel.org>
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [RFC PATCH 2/2] Revert "Btrfs: remove transaction from btrfs
 send"
References: <1391874396-2273-1-git-send-email-wangshilong1991@gmail.com> <1391874396-2273-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1391874396-2273-2-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/08/2014 10:46 AM, Wang Shilong wrote:
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

I agree, I'll leave Filipe's patch alone but I'll drop my search commit 
root patch since we don't need it any more.  Do you want me to take this 
or do you want to resubmit without the rfc?  Thanks,

Josef
