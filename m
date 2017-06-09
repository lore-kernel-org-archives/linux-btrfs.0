Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58935 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751649AbdFITul (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Jun 2017 15:50:41 -0400
Subject: Re: [PULL] Btrfs fixes for 4.12
To: David Sterba <dsterba@suse.com>
References: <cover.1496682964.git.dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <d4620eb4-1a53-12c8-f43c-1d8c13acd100@fb.com>
Date: Fri, 9 Jun 2017 15:50:30 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1496682964.git.dsterba@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/05/2017 01:47 PM, David Sterba wrote:
> Hi,
>
> please pull the following assorted fixes to 4.12. Thanks.
>
>
> The following changes since commit 9bcaaea7418d09691f1ffab5c49aacafe3eef9d0:
>
>   btrfs: fix the gfp_mask for the reada_zones radix tree (2017-05-04 16:56:11 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.12
>
> for you to fetch changes up to 2eec59665d545ce443184b9c7a32a65b4dde6d4c:
>
>   Btrfs: clear EXTENT_DEFRAG bits in finish_ordered_io (2017-06-01 17:00:11 +0200)
>
> ----------------------------------------------------------------
> Colin Ian King (1):
>       btrfs: fix incorrect error return ret being passed to mapping_set_error
>
> David Sterba (1):
>       btrfs: use correct types for page indices in btrfs_page_exists_in_range
>
> Jan Kara (1):
>       btrfs: Make flush bios explicitely sync
>
> Jeff Mahoney (2):
>       btrfs: fix memory leak in update_space_info failure path
>       btrfs: fix race with relocation recovery and fs_root setup
>
> Liu Bo (2):
>       Btrfs: skip commit transaction if we don't have enough pinned bytes

Thanks Dave, I've been bashing on these along with Omar's enospc fix for 
the last few days.

Omar mentioned that until we fix the pinned bytes counter we should 
leave out this commit from Liu Bo, so I've rebased it out for now.

-chris
