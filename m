Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47348 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751301AbeDYJsP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 05:48:15 -0400
Date: Wed, 25 Apr 2018 11:45:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: kill btrfs_raid_type_names[]
Message-ID: <20180425094540.GM21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180425094413.2255-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180425094413.2255-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 25, 2018 at 05:44:13PM +0800, Anand Jain wrote:
> Add a new member struct btrfs_raid_attr::raid_name so that
> btrfs_raid_array[] can maintain the name of the raid type,
> and so we can kill btrfs_raid_type_names[].
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
> v1->v2:
>  add space after =. Such as..
>    +               .raid_name      = "raid10",
>                                     ^
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -342,6 +342,7 @@ struct btrfs_raid_attr {
>  	int tolerated_failures; /* max tolerated fail devs */
>  	int devs_increment;	/* ndevs has to be a multiple of this */
>  	int ncopies;		/* how many copies to data has */
> +	char *raid_name;	/* name of the raid */

There was another comment under v1:

	const char raid_name[8]
