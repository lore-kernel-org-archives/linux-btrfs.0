Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25590 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751675AbcELRg6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 13:36:58 -0400
Subject: Re: [PATCH] Btrfs: add semaphore to synchronize direct IO writes with
 fsync
To: <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>
References: <1463073972-8225-1-git-send-email-fdmanana@kernel.org>
CC: Filipe Manana <fdmanana@suse.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <3d087d8d-9e8e-ad55-8b7e-b95af09a206e@fb.com>
Date: Thu, 12 May 2016 10:36:03 -0700
MIME-Version: 1.0
In-Reply-To: <1463073972-8225-1-git-send-email-fdmanana@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/12/2016 10:26 AM, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> Due to the optimization of lockless direct IO writes (the inode's i_mutex
> is not held) introduced in commit 38851cc19adb ("Btrfs: implement unlocked
> dio write"), we started having races between such writes with concurrent
> fsync operations that use the fast fsync path. These races were addressed
> in the patches titled "Btrfs: fix race between fsync and lockless direct
> IO writes" and "Btrfs: fix race between fsync and direct IO writes for
> prealloc extents". The races happened because the direct IO path, like
> every other write path, does create extent maps followed by the
> corresponding ordered extents while the fast fsync path collected first
> ordered extents and then it collected extent maps. This made it possible
> to log file extent items (based on the collected extent maps) without
> waiting for the corresponding ordered extents to complete (get their IO
> done). The two fixes mentioned before added a solution that consists of
> making the direct IO path create first the ordered extents and then the
> extent maps, while the fsync path attempts to collect any new ordered
> extents once it collects the extent maps. This was simple and did not
> require adding any synchonization primitive to any data structure (struct
> btrfs_inode for example) but it makes things more fragile for future
> development endeavours and adds an exceptional approach compared to the
> other write paths.
>
> This change adds a read-write semaphore to the btrfs inode structure and
> makes the direct IO path create the extent maps and the ordered extents
> while holding read access on that semaphore, while the fast fsync path
> collects extent maps and ordered extents while holding write access on
> that semaphore. The logic for direct IO write path is encapsulated in a
> new helper function that is used both for cow and nocow direct IO writes.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks Filipe,

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
