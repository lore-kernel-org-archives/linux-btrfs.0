Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63418 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751628AbcELQaT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 12:30:19 -0400
Subject: Re: [PATCH] fstests: test creating a symlink and then fsync its
 parent directory
To: <fdmanana@kernel.org>, <fstests@vger.kernel.org>
References: <1461558383-32254-1-git-send-email-fdmanana@kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <44801ab1-ebe0-418a-0979-a90c2c6167d3@fb.com>
Date: Thu, 12 May 2016 09:30:01 -0700
MIME-Version: 1.0
In-Reply-To: <1461558383-32254-1-git-send-email-fdmanana@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/24/2016 09:26 PM, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> Test creating a symlink, fsync its parent directory, power fail and mount
> again the filesystem. After these steps the symlink should exist and its
> content must match what we specified when we created it (must not be
> empty or point to something else).
>
> This is motivated by an issue in btrfs where after the log replay happens
> we get empty symlinks, which not only does not make much sense from a
> user's point of view, it's also not valid to have empty links in linux
> (wgich is explicitly forbidden by the symlink(2) system call).
>
> The issue in btrfs is fixed by the following patch for the linux kernel:
>
>   "Btrfs: fix empty symlink after creating symlink and fsync parent dir"
>
> Tested against ext3, ext4, xfs, f2fs, reiserfs and nilfs2.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

