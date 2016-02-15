Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbcBOQxU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 11:53:20 -0500
Date: Mon, 15 Feb 2016 17:53:16 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/13] btrfs: make use of
 btrfs_find_device_by_user_input()
Message-ID: <20160215165316.GN4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
 <1455328900-1476-10-git-send-email-anand.jain@oracle.com>
 <20160215164746.GM4374@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160215164746.GM4374@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 15, 2016 at 05:47:46PM +0100, David Sterba wrote:
> > +	struct btrfs_super_block *disk_super = NULL;
> 
> disk_super is NULL here and unchanged until ...
> 

> > +		if (!disk_super) {
> 
> ... here, so this will always take this branch
> 
> > +			ret = btrfs_get_bdev_and_sb(device_path,
> > +					FMODE_WRITE | FMODE_EXCL,
> > +					root->fs_info->bdev_holder, 0,
> > +					&bdev, &bh);
> > +			if (ret) {
> > +				/*
> > +				 * It could be a failed device ok for clear_super
> > +				 * to fail. So return success
> > +				 */
> > +				ret = 0;
> > +				goto out;
> > +			}
> > +
> > +			disk_super = (struct btrfs_super_block *)bh->b_data;
> > +		}
> 
> The patch looks otherwise good so I'm curious if this is a leftover or
> I'm missing some logic behind that.

Never mind, the code gets removed anyway. Bisectability is not broken.
