Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59229 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbcELRhH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 13:37:07 -0400
Subject: Re: [PATCH 1/2] Btrfs: fix race between fsync and direct IO writes
 for prealloc extents
To: <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>
References: <1462802509-1974-1-git-send-email-fdmanana@kernel.org>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <1fe5a1ca-f0ce-6443-23cd-2b82d9c94bea@fb.com>
Date: Thu, 12 May 2016 10:36:47 -0700
MIME-Version: 1.0
In-Reply-To: <1462802509-1974-1-git-send-email-fdmanana@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/09/2016 07:01 AM, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> When we do a direct IO write against a preallocated extent (fallocate)
> that does not go beyond the i_size of the inode, we do the write operation
> without holding the inode's i_mutex (an optimization that landed in
> commit 38851cc19adb ("Btrfs: implement unlocked dio write")). This allows
> for a very tiny time window where a race can happen with a concurrent
> fsync using the fast code path, as the direct IO write path creates first
> a new extent map (no longer flagged as a prealloc extent) and then it
> creates the ordered extent, while the fast fsync path first collects
> ordered extents and then it collects extent maps. This allows for the
> possibility of the fast fsync path to collect the new extent map without
> collecting the new ordered extent, and therefore logging an extent item
> based on the extent map without waiting for the ordered extent to be
> created and complete. This can result in a situation where after a log
> replay we end up with an extent not marked anymore as prealloc but it was
> only partially written (or not written at all), exposing random, stale or
> garbage data corresponding to the unwritten pages and without any
> checksums in the csum tree covering the extent's range.
>
> This is an extension of what was done in commit de0ee0edb21f ("Btrfs: fix
> race between fsync and lockless direct IO writes").
>
> So fix this by creating first the ordered extent and then the extent
> map, so that this way if the fast fsync patch collects the new extent
> map it also collects the corresponding ordered extent.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
