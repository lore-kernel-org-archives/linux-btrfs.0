Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23661 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3AYC5w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 21:57:52 -0500
Message-ID: <5101F64A.5050706@oracle.com>
Date: Fri, 25 Jan 2013 11:04:42 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Gene Czarcinski <gene@czarc.net>
CC: linux-btrfs@vger.kernel.org, Danny Kukawka <danny.kukawka@bisect.de>
Subject: Re: [PATCH] Btrfs-progs: Fix minor problems with btrfslabel.c
References: <1359042738-14522-1-git-send-email-gene@czarc.net>
In-Reply-To: <1359042738-14522-1-git-send-email-gene@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Thanks. comments below.

On 01/24/2013 11:52 PM, Gene Czarcinski wrote:
> Fixed indentation, replace spaces with tabs.
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
>
> Rebased, also fixed compiler warnings
> Signed-off-by: Gene Czarcinski <gene@czarc.net>
> ---
>   btrfslabel.c | 57 +++++++++++++++++++++++++++++----------------------------
>   1 file changed, 29 insertions(+), 28 deletions(-)
>
> diff --git a/btrfslabel.c b/btrfslabel.c
> index 88a5196..bea1f89 100644
> --- a/btrfslabel.c
> +++ b/btrfslabel.c
> @@ -48,42 +48,43 @@
>
>   static int change_label_unmounted(char *dev, char *nLabel)
>   {
> -       struct btrfs_root *root;
> -       struct btrfs_trans_handle *trans;
> -
> -       /* Open the super_block at the default location
> -        * and as read-write.
> -        */
> -       root = open_ctree(dev, 0, 1);
> -       if (!root) /* errors are printed by open_ctree() */
> -         return;
> -
> -       trans = btrfs_start_transaction(root, 1);
> -       strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
> -       root->fs_info->super_copy.label[BTRFS_LABEL_SIZE-1] = 0;
> -       btrfs_commit_transaction(trans, root);
> -
> -       /* Now we close it since we are done. */
> -       close_ctree(root);
> +	struct btrfs_root *root;
> +	struct btrfs_trans_handle *trans;
> +
> +	/* Open the super_block at the default location
> +	 * and as read-write.
> +	 */
> +	root = open_ctree(dev, 0, 1);
> +	if (!root) /* errors are printed by open_ctree() */
> +	  return -1;
> +
> +	trans = btrfs_start_transaction(root, 1);
> +	strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
> +	root->fs_info->super_copy.label[BTRFS_LABEL_SIZE-1] = 0;
> +	btrfs_commit_transaction(trans, root);
> +
> +	/* Now we close it since we are done. */
> +	close_ctree(root);
> +	return 0;
>   }
>
>   int get_label_unmounted(char *dev)
>   {
> -       struct btrfs_root *root;
> +	struct btrfs_root *root;
>
> -       /* Open the super_block at the default location
> -        * and as read-only.
> -        */
> -       root = open_ctree(dev, 0, 0);
> +	/* Open the super_block at the default location
> +	 * and as read-only.
> +	 */
> +	root = open_ctree(dev, 0, 0);
>
> -       if(!root)
> -         return -1;
> +	if(!root)
> +	  return -1;

  minor: since you are here, should you add a space after if

> -       fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
> +	fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
>
> -       /* Now we close it since we are done. */
> -       close_ctree(root);
> -       return 0;
> +	/* Now we close it since we are done. */
> +	close_ctree(root);
> +	return 0;
>   }
>
>   int get_label(char *btrfs_dev)
>
