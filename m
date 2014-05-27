Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14114 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752802AbaE0QMF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 12:12:05 -0400
Message-ID: <5384B904.3070809@fb.com>
Date: Tue, 27 May 2014 12:10:44 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3] btrfs: allocate raid type kobjects dynamically
References: <5383EBE0.2000906@suse.com>
In-Reply-To: <5383EBE0.2000906@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/26/2014 09:35 PM, Jeff Mahoney wrote:
> We are currently allocating space_info objects in an array when we
> allocate space_info. When a user does something like:
> 
> # btrfs balance start -mconvert=raid1 -dconvert=raid1 /mnt
> # btrfs balance start -mconvert=single -dconvert=single /mnt -f
> # btrfs balance start -mconvert=raid1 -dconvert=raid1 /
> 
> We can end up with memory corruption since the kobject hasn't
> been reinitialized properly and the name pointer was left set.
> 
> The rationale behind allocating them statically was to avoid
> creating a separate kobject container that just contained the
> raid type. It used the index in the array to determine the index.
> 
> Ultimately, though, this wastes more memory than it saves in all
> but the most complex scenarios and introduces kobject lifetime
> questions.
> 
> This patch allocates the kobjects dynamically instead. Note that
> we also remove the kobject_get/put of the parent kobject since
> kobject_add and kobject_del do that internally.

Thanks Jeff, one small thing below:

> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8352,17 +8351,26 @@ static void __link_block_group(struct bt
>  	up_write(&space_info->groups_sem);
>  
>  	if (first) {
> -		struct kobject *kobj = &space_info->block_group_kobjs[index];
> +		struct raid_kobject *rkobj;
>  		int ret;
>  
> -		kobject_get(&space_info->kobj); /* put in release */
> -		ret = kobject_add(kobj, &space_info->kobj, "%s",
> -				  get_raid_name(index));
> +		rkobj = kzalloc(sizeof(*rkobj), GFP_KERNEL);
                                               ^^^^^^^^^^^^

GFP_NOFS?  We've got a transaction running here.

-chris
