From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 07/12 v3] Btrfs: add checksum check for log
Date: Tue, 21 Jun 2011 09:49:01 -0400
Message-ID: <4E00A14D.5070102@redhat.com>
References: <1308646193-7086-1-git-send-email-liubo2009@cn.fujitsu.com> <1308646193-7086-8-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org, dave@jikos.cz, chris.mason@oracle.com
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1308646193-7086-8-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/2011 04:49 AM, Liu Bo wrote:
> If a inode is a BTRFS_INODE_NODATASUM one, it need not to look for csum items
> any more.
>
> Signed-off-by: Liu Bo<liubo2009@cn.fujitsu.com>
> ---
>   fs/btrfs/tree-log.c |   13 ++++++++-----
>   1 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 6193e27..1eca1d4 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2672,7 +2672,8 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
>   			       struct inode *inode,
>   			       struct btrfs_path *dst_path,
>   			       struct extent_buffer *src,
> -			       int start_slot, int nr, int inode_only)
> +			       int start_slot, int nr, int inode_only,
> +			       int csum)

Don't add another parameter, we're already passing in the inode, just 
check for nodatasum in copy_items instead of making all the callers do 
it.  Thanks,

Josef
