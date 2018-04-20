Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43573 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754591AbeDTMBx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 08:01:53 -0400
Date: Fri, 20 Apr 2018 13:59:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 13/16] btrfs: move and comment read-only check in
 btrfs_cancel_balance
Message-ID: <20180420115920.GN21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1524146555.git.dsterba@suse.com>
 <d1db2691059cb458d2b44cae473b1cf2ea73ed78.1524146556.git.dsterba@suse.com>
 <189a5404-4bf9-5907-40d2-ad670b5889d1@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <189a5404-4bf9-5907-40d2-ad670b5889d1@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 20, 2018 at 05:13:02PM +0800, Anand Jain wrote:
> 
> 
> On 04/20/2018 12:33 AM, David Sterba wrote:
> > Balance cannot be started on a read-only filesystem and will have to
> > finish/exit before eg. going to read-only via remount.
> 
>   It can be paused as well.
>     btrfs balance pause /btrfs && mount -o remount,ro /dev/sdb /btrfs
> 
> 
> > @@ -4053,15 +4053,20 @@ int btrfs_pause_balance(struct btrfs_fs_info *fs_info)
> >   
> >   int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
> >   {
> > -	if (sb_rdonly(fs_info->sb))
> > -		return -EROFS;
> > -
> >   	mutex_lock(&fs_info->balance_mutex);
> >   	if (!fs_info->balance_ctl) {
> >   		mutex_unlock(&fs_info->balance_mutex);
> >   		return -ENOTCONN;
> >   	}
> >   
> > +	/*
> > +	 * A paused balance with the item stored on disk can be resumed at
> > +	 * mount time if the mount is read-write. Otherwise it's still paused
> > +	 * and we must not allow cancelling as it deletes the item.
> > +	 */
> > +	if (sb_rdonly(fs_info->sb))
> > +		return -EROFS;
> > +
> 
>    mutex_unlock(&fs_info->balance_mutex); ?

Ah, of course. Fixed, thanks.
