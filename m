Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:38409 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585AbbLHKHD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 05:07:03 -0500
Received: from localhost
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 8 Dec 2015 15:37:00 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 288BD1258059
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Dec 2015 15:37:22 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay05.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tB8A6wVr62587080
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Dec 2015 15:36:58 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tB8A6waO009492
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Dec 2015 15:36:58 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Introduce new mount option to disable tree log replay
Date: Tue, 08 Dec 2015 15:36:57 +0530
Message-ID: <2728328.xh2dYaTluQ@localhost.localdomain>
In-Reply-To: <1449555033-25075-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1449555033-25075-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 08 Dec 2015 14:10:33 Qu Wenruo wrote:
> Introduce a new mount option "nologreplay" to co-operate with "ro" mount
> option to get real readonly mount, like "norecovery" in ext* and xfs.
> 
> Since the new parse_options() need to check new flags at remount time,
> so add a new parameter for parse_options().
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v2:
>   Make RO check mandatory for btrfs_parse_options().
>   Add btrfs_show_options() support for nologreplay.
> 
>   Document for btrfs-mount(5) will follow after the patch being merged.
> ---
>  Documentation/filesystems/btrfs.txt |  7 +++++++
>  fs/btrfs/ctree.h                    |  4 +++-
>  fs/btrfs/disk-io.c                  |  7 ++++---
>  fs/btrfs/super.c                    | 29 +++++++++++++++++++++++++----
>  4 files changed, 39 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/filesystems/btrfs.txt
> b/Documentation/filesystems/btrfs.txt index c772b47..7ad5b93 100644
> --- a/Documentation/filesystems/btrfs.txt
> +++ b/Documentation/filesystems/btrfs.txt
> @@ -168,6 +168,13 @@ Options with (*) are default options and will not show
> in the mount options. notreelog
>  	Enable/disable the tree logging used for fsync and O_SYNC writes.
> 
> +  nologreplay
> +	Disable the log tree replay at mount time to prevent devices get
> +	modified. Must be use with 'ro' mount option.
> +	A filesystem mounted with the 'nologreplay' option cannot
> +	transition to a read-write mount via remount,rw - the filesystem
> +	must be unmounted and remounted if read-write access is desired.
> +

May be the following is slightly better ...

Disable the log tree replay at mount time to prevent filesystem from getting
modified. Must be used with 'ro' mount option.  A filesystem mounted with the
'nologreplay' option cannot transition to a read-write mount via remount,rw -
the filesystem must be unmounted and mounted back again if read-write access
is desired.

Aside from above, everything else looks good to me.

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan

