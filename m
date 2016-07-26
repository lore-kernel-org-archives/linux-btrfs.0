Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1747 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753438AbcGZBV6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jul 2016 21:21:58 -0400
Subject: Re: [PATCH RFC] btrfs: send: Disable clone detection
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@gmail.com>
References: <20160725071959.28107-1-quwenruo@cn.fujitsu.com>
 <20160725153705.GC30795@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <91c25e15-7041-9229-a744-7b15f129e949@cn.fujitsu.com>
Date: Tue, 26 Jul 2016 09:21:49 +0800
MIME-Version: 1.0
In-Reply-To: <20160725153705.GC30795@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 07/25/2016 11:37 PM, David Sterba wrote:
> On Mon, Jul 25, 2016 at 03:19:59PM +0800, Qu Wenruo wrote:
>> This patch will disable clone detection of send.
>
> Making that unconditional is not the right way. We do have the send
> operation flags in place so if you really think there's a need for
> disabling the clones, let's add a flag for that (BTRFS_SEND_FLAG_*).
>

The problem is, we don't know if it will cause problem  until it happens.
So the flag like BTRFS_SEND_FLAG_DISABLE_CLONE won't really help, unless 
it becomes the default flag.

Anyway, the RFC patch is not meant to be merged, but only to get idea 
and advice to how to really fix the problem.

I think Filipe will have some good idea after he understand the real 
problem behind the bug, since he is much more experienced than me in 
send code.

Thanks,
Qu


