Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbaHSPhD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 11:37:03 -0400
Date: Tue, 19 Aug 2014 17:37:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 8/8] btrfs: rename total_bytes to avoid confusion
Message-ID: <20140819153702.GZ1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1407911066-5363-1-git-send-email-anand.jain@oracle.com>
 <1407911066-5363-8-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1407911066-5363-8-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 13, 2014 at 02:24:26PM +0800, Anand Jain wrote:
> we are assigning number_devices to the total_bytes,
> that's very confusing for a moment
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index bf99e82..c0c360a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2253,7 +2253,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>  	struct list_head *devices;
>  	struct super_block *sb = root->fs_info->sb;
>  	struct rcu_string *name;
> -	u64 total_bytes;
> +	u64 ret_sz;

A 'tmp' would do, but whatever
