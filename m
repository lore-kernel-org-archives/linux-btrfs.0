Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:42981 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1PE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 10:04:58 -0500
Received: by mail-pa0-f48.google.com with SMTP id kx10so464390pab.35
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jan 2014 07:04:57 -0800 (PST)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v2] Btrfs: do not use extent commit root for sending
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <52E7C09D.4020808@fb.com>
Date: Tue, 28 Jan 2014 23:04:59 +0800
Cc: <linux-btrfs@vger.kernel.org>
Message-Id: <E11CE2B5-DBA8-470F-9929-2C2E6FBCDB59@gmail.com>
References: <1389716803-2415-1-git-send-email-wangshilong1991@gmail.com> <52E7C09D.4020808@fb.com>
To: Josef Bacik <jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

> 
> On 01/14/2014 11:26 AM, Wang Shilong wrote:
>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> 
>> Now we have kicked off transaction from btrfs send, it is not safe
>> that we use extent commit root to search.
>> 
>> I happended to catch this problem when running sending and snapshot
>> in my desktop.
> 
> I'm confused about this, we are searching a read only snapshot, why isn't looking at the commit root ok?  Thanks,

I sent a patch to remove transaction outsize before.

http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=integration&id=e0cbfccf3d518f1fb6f8e10932a67d75df2a4380

Previously, we can search extent commit root, it is because we are protected by join and end transaction, since this patch, we can not.

A further  question is now we still have to join transaction actually, only the transaction protection range is smaller,  but we may encounter
extent root's lock contention. I don't know which approach is better, the url's patch have been pushed into chris's integration branch before
i realized it would caused other problems.

Maybe a better a approach is to join and end transaction outsize of find_extent_clone(), and then we still can use extent commit
root for sending.^_^

Thanks,
Wang
> 
> Josef

