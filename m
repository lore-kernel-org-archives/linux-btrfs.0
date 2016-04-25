Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbcDYPP0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 11:15:26 -0400
Date: Mon, 25 Apr 2016 17:15:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, yauhen.kharuzhy@zavadatar.com
Subject: Re: [PATCH] btrfs: cleanup assigning next active device with a check
Message-ID: <20160425151514.GC29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1460978752-27375-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460978752-27375-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 18, 2016 at 07:25:52PM +0800, Anand Jain wrote:
> Creates helper fucntion as needed by the device delete
> and replace operations. Also now it checks if the next
> device being assigned is an active device.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1684,10 +1684,40 @@ out:
>  	return ret;
>  }
>  
> +struct btrfs_device *btrfs_find_next_active_device(struct btrfs_fs_devices *fs_devs,
> +					struct btrfs_device *device)

> +
> +void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
> +		struct btrfs_device *device, struct btrfs_device *this_dev)

Please add comments what the functions do so that one does not need to
read the whole function to figure it out.
