Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41719 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbcGSClu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 22:41:50 -0400
Date: Mon, 18 Jul 2016 19:41:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH] vfs: allow FILE_EXTENT_SAME (dedupe_file_range) on a
 file opened ro
Message-ID: <20160719024129.GE2494@birch.djwong.org>
References: <1468793618-10496-1-git-send-email-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468793618-10496-1-git-send-email-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 18, 2016 at 12:13:38AM +0200, Adam Borowski wrote:
> Instead of checking the mode of the file descriptor, let's check whether it
> could have been opened rw.  This allows fixing intermittent exec failures
> when deduping a live system: anyone trying to exec a file currently being
> deduped gets ETXTBSY.
> 
> Issuing this ioctl on a ro file was already allowed for root/cap.
> 
> Tested on btrfs and not-yet-merged xfs, as only them implement this ioctl.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>

Could you please send an xfstest to test this aspect of the dedupe ioctl?

--D

> ---
>  fs/read_write.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 933b53a..df59dc6 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1723,7 +1723,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
>  
>  		if (info->reserved) {
>  			info->status = -EINVAL;
> -		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE))) {
> +		} else if (!(is_admin || !inode_permission(dst, MAY_WRITE))) {
>  			info->status = -EINVAL;
>  		} else if (file->f_path.mnt != dst_file->f_path.mnt) {
>  			info->status = -EXDEV;
> -- 
> 2.8.1
> 
