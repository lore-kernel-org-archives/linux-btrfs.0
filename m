Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50990 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbbLCSSV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 13:18:21 -0500
Subject: Re: [RFC PATCH] btrfs: flush_space: treat return value of
 do_chunk_alloc properly
To: Alex Lyakas <alex@zadarastorage.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAOcd+r3DHGSu5017ha+m1E9bv2YD4v-LCMBxYywNA9BaLK-DQg@mail.gmail.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <56608769.30700@fb.com>
Date: Thu, 3 Dec 2015 13:18:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAOcd+r3DHGSu5017ha+m1E9bv2YD4v-LCMBxYywNA9BaLK-DQg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/03/2015 11:51 AM, Alex Lyakas wrote:
> do_chunk_alloc returns 1 when it succeeds to allocate a new chunk.
> But flush_space will not convert this to 0, and will also return 1.
> As a result, reserve_metadata_bytes will think that flush_space failed,
> and may potentially return this value "1" to the caller (depends how
> reserve_metadata_bytes was called). The caller will also treat this as an error.
> For example, btrfs_block_rsv_refill does:
>
> int ret = -ENOSPC;
> ...
> ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
> if (!ret) {
>          block_rsv_add_bytes(block_rsv, num_bytes, 0);
>          return 0;
> }
>
> return ret;
>
> So it will return -ENOSPC.

Huh nice catch.  Can you add your signed off by, and you can add my

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

