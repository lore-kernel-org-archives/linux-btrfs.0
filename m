Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:38849 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbeHTQu2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 12:50:28 -0400
Subject: Re: [PATCH 2/2] btrfstune: Rename change_header_uuid to
 change_buffer_header_uuid
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1534771685-4924-1-git-send-email-nborisov@suse.com>
 <1534771685-4924-3-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <55ec64a2-d2ec-d12f-387d-98b40eb78884@gmx.com>
Date: Mon, 20 Aug 2018 21:34:37 +0800
MIME-Version: 1.0
In-Reply-To: <1534771685-4924-3-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/8/20 下午9:28, Nikolay Borisov wrote:
> Rename the function so its name falls in line with the rest of btrfs
> nomenclature. So when we change the uuid of the header it's in fact
> of the buffer header.

We have setget functions like btrfs_header_nritems() or
btrfs_header_bytenr(), IMHO both ways make sense.

Although I have no objection against current modification.

> Also remove the root argument since it's used
> solely to take a reference to fs_info which can be done via the
> mandatory eb argument. No functional changes.>
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  btrfstune.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/btrfstune.c b/btrfstune.c
> index 723317a00f3a..3745a00c46ae 100644
> --- a/btrfstune.c
> +++ b/btrfstune.c
> @@ -91,9 +91,9 @@ static int set_super_incompat_flags(struct btrfs_root *root, u64 flags)
>  	return ret;
>  }
>  
> -static int change_header_uuid(struct btrfs_root *root, struct extent_buffer *eb)
> +static int change_buffer_header_uuid(struct extent_buffer *eb)
>  {
> -	struct btrfs_fs_info *fs_info = root->fs_info;
> +	struct btrfs_fs_info *fs_info = eb->fs_info;
>  	int same_fsid = 1;
>  	int same_chunk_tree_uuid = 1;
>  	int ret;
> @@ -157,7 +157,7 @@ static int change_extents_uuid(struct btrfs_fs_info *fs_info)
>  			ret = PTR_ERR(eb);
>  			goto out;
>  		}
> -		ret = change_header_uuid(root, eb);
> +		ret = change_buffer_header_uuid(eb);
>  		free_extent_buffer(eb);
>  		if (ret < 0) {
>  			error("failed to change uuid of tree block: %llu",
> 
