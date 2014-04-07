Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2675 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbaDGPud (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Apr 2014 11:50:33 -0400
Message-ID: <5342C944.2020000@fb.com>
Date: Mon, 7 Apr 2014 11:50:28 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: ylet ylet <levin.front@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: <clm@fb.com>
Subject: Re: Is this a race bug when releasing eb?
References: <CAAcaxmWqrLUwbvmsyE+3zLLP1jSVZXGASRvN-D-BLaJp4WnpLQ@mail.gmail.com>
In-Reply-To: <CAAcaxmWqrLUwbvmsyE+3zLLP1jSVZXGASRvN-D-BLaJp4WnpLQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/07/2014 11:45 AM, ylet ylet wrote:
> Assuming thread 1 (may be VFS want to release the page) wants to
> release a CLEAN page and thus the eb attaching the page.
> and thread 2 wants to access the eb and cow the eb.
>
> Thread 1
>                 Thread 2
>
> btree_releasepage
>
> try_release_extent_buffer
>
> release_extent_buffer
> ->if (atomic_dec_and_test(&eb->refs)) {
> ->spin_unlock(&eb->refs_lock);
>   -------switch to thread 2 here------
>
>                 read_block_for_search
>
>                  btrfs_find_tree_block
>
>       radix_tree_lookup && atomic_inc_not_zero
>

atomic_inc_not_zero would return 0 here because we've dropped the last 
buffer for this, that is how we protect against this problem.  How 
reliably are you able to reproduce this bug?  Cause I'd love to find it 
if you can reproduce reliably.  Thanks,

Josef
