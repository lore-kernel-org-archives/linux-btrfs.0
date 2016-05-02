Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37329 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbcEBQWM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 12:22:12 -0400
Received: by mail-ig0-f178.google.com with SMTP id s8so78260331ign.0
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 09:22:11 -0700 (PDT)
Subject: Re: [PATCH v3 3/3] block: avoid to call .bi_end_io() recursively
To: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@fb.com>,
        linux-kernel@vger.kernel.org
References: <1461805789-3632-1-git-send-email-ming.lei@canonical.com>
 <1461805789-3632-3-git-send-email-ming.lei@canonical.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-btrfs@vger.kernel.org,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Alan Cox <alan@linux.intel.com>,
        Neil Brown <neilb@suse.de>, Liu Bo <bo.li.liu@oracle.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <57277EB0.5060408@kernel.dk>
Date: Mon, 2 May 2016 10:22:08 -0600
MIME-Version: 1.0
In-Reply-To: <1461805789-3632-3-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/27/2016 07:09 PM, Ming Lei wrote:
> There were reports about heavy stack use by recursive calling
> .bi_end_io()([1][2][3]). For example, more than 16K stack is
> consumed in a single bio complete path[3], and in [2] stack
> overflow can be triggered if 20 nested dm-crypt is used.
>
> Also patches[1] [2] [3] were posted for addressing the issue,
> but never be merged. And the idea in these patches is basically
> similar, all serializes the recursive calling of .bi_end_io() by
> percpu list.
>
> This patch still takes the same idea, but uses bio_list to
> implement it, which turns out more simple and the code becomes
> more readable meantime.
>
> One corner case which wasn't covered before is that
> bi_endio() may be scheduled to run in process context(such
> as btrfs), and this patch just bypasses the optimizing for
> that case because one new context should have enough stack space,
> and this approach isn't capable of optimizing it too because
> there isn't easy way to get a per-task linked list head.
>
> xfstests(-g auto) is run with this patch and no regression is
> found on ext4, xfs and btrfs.

I don't like this at all, it's going about fixing this the completely 
wrong way. For the fast path, single device, we don't have an issue. Yet 
this patch slows down that part unnecessarily.

Fix this for the fat dm/md stacks, and don't add unwarranted fat in the 
normal fast path. The dm/md stacks won't notice a bit of extra overhead, 
whereas the core path is pretty well optimized.

-- 
Jens Axboe

