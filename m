Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:62107 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728071AbeGSIhA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 04:37:00 -0400
Subject: Re: [PATCH] btrfs: tree-checker: Add DATA_RELOC tree to essential
 non-empty tree list
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180719070514.10740-1-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <5cfc7b6f-cfab-a851-3053-117388a2a6f0@cn.fujitsu.com>
Date: Thu, 19 Jul 2018 16:01:30 +0800
MIME-Version: 1.0
In-Reply-To: <20180719070514.10740-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/19/2018 03:05 PM, Qu Wenruo wrote:
> DATA RELOC tree should also never be empty.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=200407
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
> It's possible just fold this fix into commit "btrfs: tree-checker: Detect
> invalid empty essential tree".
> 
> And for the test image, it can already be rejected by misc-next branch
> by the enhanced dev-extent checker.
> ---
>   fs/btrfs/tree-checker.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 4c82a628df85..db835635372f 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -504,7 +504,8 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
>   		    owner == BTRFS_CHUNK_TREE_OBJECTID ||
>   		    owner == BTRFS_EXTENT_TREE_OBJECTID ||
>   		    owner == BTRFS_DEV_TREE_OBJECTID ||
> -		    owner == BTRFS_FS_TREE_OBJECTID) {
> +		    owner == BTRFS_FS_TREE_OBJECTID ||
> +		    owner == BTRFS_DATA_RELOC_TREE_OBJECTID) {
>   			generic_err(fs_info, leaf, 0,
>   			"invalid root, root %llu must never be empty",
>   				    owner);
> 


