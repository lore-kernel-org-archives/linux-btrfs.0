Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53466 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709AbbJFNyP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Oct 2015 09:54:15 -0400
Date: Tue, 6 Oct 2015 09:54:03 -0400
From: Chris Mason <clm@fb.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] btrfs: Fix lost-data-profile caused by auto
 removing bg
Message-ID: <20151006135403.GY25218@ret.masoncoding.com>
References: <cover.1443889301.git.zhaolei@cn.fujitsu.com>
 <a2ff95d73e0ccec4703c1f4d0b9af4c1a19fe4e2.1443889301.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <a2ff95d73e0ccec4703c1f4d0b9af4c1a19fe4e2.1443889301.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

On Sun, Oct 04, 2015 at 12:28:39AM +0800, Zhao Lei wrote:
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 79a5bd9..c05b975 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10010,8 +10010,18 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
>  		block_group = list_first_entry(&fs_info->unused_bgs,
>  					       struct btrfs_block_group_cache,
>  					       bg_list);
> -		space_info = block_group->space_info;
>  		list_del_init(&block_group->bg_list);
> +
> +		space_info = block_group->space_info;
> +
> +		down_read(&space_info->groups_sem);

Thanks for reworking this, are there other patches that I'm missing that
are meant to go in before this one?

The down_read() this patch adds is inside a spinlock().

-chris

