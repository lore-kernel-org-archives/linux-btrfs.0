Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55872 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755191AbeDTOoK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 10:44:10 -0400
Subject: Re: [PATCH 3/3] btrfs: Do super block verification before writing it
 to disk
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180419093816.888-1-wqu@suse.com>
 <20180419093816.888-3-wqu@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <403905d9-5d5b-008a-1c03-cab9a6388a77@oracle.com>
Date: Fri, 20 Apr 2018 22:46:19 +0800
MIME-Version: 1.0
In-Reply-To: <20180419093816.888-3-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





> @@ -3563,6 +3565,12 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
>   	sb = fs_info->super_for_commit;
>   	dev_item = &sb->dev_item;
>   
> +	if (btrfs_check_super_valid(fs_info, sb, -1)) {
> +		btrfs_err(fs_info,
> +		"superblock corruption detected before transaction commitment");
> +		return -EUCLEAN;
> +	}
> +
>   	mutex_lock(&fs_info->fs_devices->device_list_mutex);
>   	head = &fs_info->fs_devices->devices;
>   	max_errors = btrfs_super_num_devices(fs_info->super_copy) - 1;

  With patch 1/3 (incompat feature checks) now this set as a
  whole address my concern that I explained earlier. I am ok with
  this approach.

Thanks, Anand
