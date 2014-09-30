Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60920 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaI3Ojh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 10:39:37 -0400
Received: by mail-pa0-f48.google.com with SMTP id eu11so1923066pac.7
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Sep 2014 07:39:37 -0700 (PDT)
From: naota@elisp.net
To: bo.li.liu@oracle.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs: initial reference count of extent buffer is correct?
References: <87y4ud2l7q.fsf@elisp.net>
	<20140825061604.GE22848@localhost.localdomain>
Date: Tue, 30 Sep 2014 23:39:31 +0900
In-Reply-To: <20140825061604.GE22848@localhost.localdomain> (Liu Bo's message
	of "Mon, 25 Aug 2014 14:16:05 +0800")
Message-ID: <878ul15g0s.fsf@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Liu

Thank you for your explanation, and I'm sorry for this long silence.

Liu Bo <bo.li.liu@oracle.com> writes:

> You may think of it twice, commit 53ee1bccf99cd5b474fe1aa857b7dd176e3a1407 
> is to fix a bug of assigning a free block to two different extent buffers, ie.
> two different extent buffers' share the same eb->start, so it's not just bumping
> a reference cnt.
>
> Right now we want to be consistent with the kernel side, decreasing eb->refs=0
> means it'd be freed, so droping free_some_buffer() can be a good choice.

Now I understand the reason why @refs = 1 initially.

I'll post a patch to drop free_some_buffer() after this.

> And for caching extent buffer, we've increased eb->refs by 1 to keep it in the
> cache rbtree.
>
> thanks,
> -liubo

Regards,
Naohiro
