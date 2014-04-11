Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57477 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbaDKGLj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 02:11:39 -0400
Date: Thu, 10 Apr 2014 23:11:38 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: Add explain on btrfs-zero-log.
Message-ID: <20140411061138.GE7322@merlins.org>
References: <1397184233-18535-1-git-send-email-quwenruo@cn.fujitsu.com> <1397184233-18535-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1397184233-18535-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 11, 2014 at 10:43:53AM +0800, Qu Wenruo wrote:
> Add more explain on btrfs-zero-log about when to use it.
> 
> Cc: Marc MERLIN <marc@merlins.org>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: Marc MERLIN <marc@merlins.org>

Looks good, thank you.

Marc

> ---
>  Documentation/btrfs-zero-log.txt | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/Documentation/btrfs-zero-log.txt b/Documentation/btrfs-zero-log.txt
> index e3041fa..a8e4dd3 100644
> --- a/Documentation/btrfs-zero-log.txt
> +++ b/Documentation/btrfs-zero-log.txt
> @@ -17,6 +17,24 @@ allow you to mount the filesystem again.
>  The common case where this happens has been fixed a long time ago,
>  so it is unlikely that you will see this particular problem.
>  
> +One can determine whether 'btrfs-zero-log' is needed according to the kernel
> +backtrace:
> +----
> +? replay_one_dir_item+0xb5/0xb5 [btrfs]
> +? walk_log_tree+0x9c/0x19d [btrfs]
> +? btrfs_read_fs_root_no_radix+0x169/0x1a1 [btrfs]
> +? btrfs_recover_log_trees+0x195/0x29c [btrfs]
> +? replay_one_dir_item+0xb5/0xb5 [btrfs]
> +? btree_read_extent_buffer_pages+0x76/0xbc [btrfs]
> +? open_ctree+0xff6/0x132c [btrfs]
> +----
> +
> +If the errors are like above, then 'btrfs-zero-log' should be used to clear
> +the log and the filesystem may be mounted normally again.
> +
> +NOTE: If you use btrfs as the root filesystem, you may want to include
> +'btrfs-zero-log' into initramdisk if the log problems hits you often.
> +
>  EXIT STATUS
>  -----------
>  'btrfs-zero-log' will return 0 if no error happened.
> -- 
> 1.9.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
