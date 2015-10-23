Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbbJWJtr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Oct 2015 05:49:47 -0400
Date: Fri, 23 Oct 2015 11:48:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: fix uninitialized copy of
 btrfs_fs_devices list
Message-ID: <20151023094825.GL13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1445486019-1173-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445486019-1173-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 22, 2015 at 11:53:39AM +0800, Anand Jain wrote:
> Noticed that at print_one_uuid() some of the members of btrfs_fs_devices
> contained some junk values. It took a while to dig this further, and found
> that we make a local copy of the btrfs_fs_devices list at
> search_umounted_fs_uuids() and wasn't initialized properly.
> 
> Fixed using using zalloc instead of malloc.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  cmds-filesystem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 3663734..4d3a9a4 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -685,7 +685,7 @@ static int search_umounted_fs_uuids(struct list_head *all_uuids,
>  		if (is_seen_fsid(cur_fs->fsid))
>  			continue;
>  
> -		fs_copy = malloc(sizeof(*fs_copy));
> +		fs_copy = kzalloc(sizeof(*fs_copy), GFP_NOFS);

This is in purely userspace code, we can use malloc/calloc/free, I'll
update it and apply.
