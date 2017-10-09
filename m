Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32962 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754085AbdJIQTn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Oct 2017 12:19:43 -0400
Date: Mon, 9 Oct 2017 18:17:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: prefix sysfs attribute struct names
Message-ID: <20171009161758.GH3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171008203058.28931-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171008203058.28931-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 08, 2017 at 10:30:58PM +0200, Hans van Kranenburg wrote:
> Currently struct names for sysfs are generated only based on the
> attribute names. This means that attribute names cannot be reused in
> multiple places throughout the complete btrfs sysfs hierarchy.
> 
> E.g. allocation/data/total_bytes and allocation/data/single/total_bytes
> result in the same struct name btrfs_attr_total_bytes. A workaround for
> this case was made in the past by ad hoc creating an extra macro
> wrapper, BTRFS_RAID_ATTR, that inserts some extra text in the struct
> name.
> 
> Instead of polluting sysfs.h with such kind of extra macro definitions,
> and only doing so when there are collisions, use a prefix which gets
> inserted in the struct name, so we keep everything nicely grouped
> together by default.
> 
> Current collections of attributes are:
> * (the toplevel, empty prefix)
> * allocation
> * space_info
> * raid
> * features
> 
> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> @@ -277,7 +277,8 @@ static ssize_t raid_bytes_show(struct kobject *kobj,
>  
>  	down_read(&sinfo->groups_sem);
>  	list_for_each_entry(block_group, &sinfo->block_groups[index], list) {
> -		if (&attr->attr == BTRFS_RAID_ATTR_PTR(total_bytes))
> +		if (&attr->attr == \

the \ is not needed here, only in macro defintions that must be on one
logical line

> +		    BTRFS_ATTR_PTR(raid, total_bytes))
>  			val += block_group->key.offset;
>  		else
>  			val += btrfs_block_group_used(&block_group->item);
> @@ -331,19 +332,20 @@ SPACE_INFO_ATTR(bytes_may_use);
>  SPACE_INFO_ATTR(bytes_readonly);
>  SPACE_INFO_ATTR(disk_used);
>  SPACE_INFO_ATTR(disk_total);
> -BTRFS_ATTR(total_bytes_pinned, btrfs_space_info_show_total_bytes_pinned);
> +BTRFS_ATTR(space_info, total_bytes_pinned, \

same here. will be fixed at commit time.

> +	   btrfs_space_info_show_total_bytes_pinned);
>  
