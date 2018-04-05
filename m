Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44247 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751179AbeDEOak (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Apr 2018 10:30:40 -0400
Date: Thu, 5 Apr 2018 16:28:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/16] btrfs: move volume_mutex to callers of
 btrfs_rm_device
Message-ID: <20180405142810.GD2635@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1522780026.git.dsterba@suse.com>
 <004920f0f641ebffa974129fe8f4b0d6a9ee9f34.1522780026.git.dsterba@suse.com>
 <7dc04550-5325-76ef-0636-87eb84831359@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7dc04550-5325-76ef-0636-87eb84831359@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 05, 2018 at 05:41:57PM +0800, Anand Jain wrote:
> 
> > @@ -2716,6 +2718,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
> >   		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
> >   		goto out_drop_write;
> >   	}
> > +	mutex_lock(&fs_info->volume_mutex);
> >   
> >   	vol_args = memdup_user(arg, sizeof(*vol_args));
> >   	if (IS_ERR(vol_args)) { > @@ -2730,6 +2733,7 @@ static long btrfs_ioctl_rm_dev(struct file 
> *file, void __user *arg)
> >   		btrfs_info(fs_info, "disk deleted %s", vol_args->name);
> >   	kfree(vol_args);
> >   out:
> > +	mutex_unlock(&fs_info->volume_mutex);
> >   	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
> >   out_drop_write:
> >   	mnt_drop_write_file(file);
> 
>   Why not memdup_user() be outside of volume_mutex?

The point of the patch is to put the mutex_lock right next to the
exclusive operation bit setting. It's not optimal regarding the size of
critical section and normally the memdup should be outside.
