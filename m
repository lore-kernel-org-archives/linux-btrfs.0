Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbbJANlp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 09:41:45 -0400
Date: Thu, 1 Oct 2015 15:40:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: Re: [PATCH 16/23] Btrfs: device path change must be logged
Message-ID: <20151001134043.GD5885@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
 <1439548388-29686-17-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439548388-29686-17-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 14, 2015 at 06:33:01PM +0800, Anand Jain wrote:
> >From the issue diagnosable point of view, log if the device path is
> changed.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index ebf37a9..dcb10fa 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -595,6 +595,10 @@ static noinline int device_list_add(const char *path,

>  			return -EEXIST;
>  		}
>  
> +		printk_in_rcu(KERN_INFO \
> +			"BTRFS: device fsid %pU devid %llu old path %s new path %s\n",
> +			disk_super->fsid, devid, rcu_str_deref(device->name), path);

I don't think that the message should be put into device_list_add. Its
only callsite in btrfs_scan_one_device prints some device info messages
so it would be better to extend and use the return value if possible.
