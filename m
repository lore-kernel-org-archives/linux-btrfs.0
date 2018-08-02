Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46884 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728797AbeHBOMh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 10:12:37 -0400
Date: Thu, 2 Aug 2018 14:21:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 4/4] btrfs: add helper btrfs_num_devices() to deduce
 num_devices
Message-ID: <20180802122136.GM3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180726065334.30594-5-anand.jain@oracle.com>
 <20180802100934.12468-1-anand.jain@oracle.com>
 <b1c8c566-5850-da69-b756-5036dca33975@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b1c8c566-5850-da69-b756-5036dca33975@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 02, 2018 at 01:11:40PM +0300, Nikolay Borisov wrote:
> 
> 
> On  2.08.2018 13:09, Anand Jain wrote:
> > When the replace is running the fs_devices::num_devices also includes
> > the replace device, however in some operations like device delete and
> > balance it needs the actual num_devices without the repalce devices, so
> > now the function btrfs_num_devices() just provides that.
> > 
> > And here is a scenario how balance and repalce items could co-exist.
> > Consider balance is started and paused, now start the replace
> > followed by a power-recycle of the system. During following mount,
> > the open_ctree() first restarts the balance so it must check for the
> > replace device otherwise our num_devices calculation will be wrong.
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > ---
> > v2->v3: update changelog with not so obvious balance and repalce
> > co-existance secnario
> > v1->v2: add comments
> > 
> >  fs/btrfs/volumes.c | 32 ++++++++++++++++++--------------
> >  1 file changed, 18 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index fe74fefc75f7..8844904f9009 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -1854,6 +1854,21 @@ void btrfs_assign_next_active_device(struct btrfs_device *device,
> >  		fs_info->fs_devices->latest_bdev = next_device->bdev;
> >  }
> >  
> > +/* Returns btrfs_fs_devices::num_devices excluding replace device if any */
> > +static inline u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)

This does not need to be static inline, it's not in a header.

> > +{
> > +	u64 num_devices = fs_info->fs_devices->num_devices;
> > +
> > +	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
> > +	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
> > +		BUG_ON(num_devices < 1);
> > +		num_devices--;
> > +	}
> > +	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
> > +
> > +	return num_devices;
> > +}
> > +
> >  int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
> >  		u64 devid)
> >  {
> > @@ -1865,13 +1880,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
> >  
> >  	mutex_lock(&uuid_mutex);
> >  
> > -	num_devices = fs_devices->num_devices;
> > -	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
> > -	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
> > -		BUG_ON(num_devices < 1);
> > -		num_devices--;
> > -	}
> > -	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
> > +	num_devices = btrfs_num_devices(fs_info);
> 
> How about lifting the BUG_ON from btrfs_num_devices into a check in this
> function, so if num_devices < 1 then we just exit with -EINVAL or some
> such. We should be aiming at eliminating BUG_ONs.

Right, in both cases it's possible to return with an error instead of
the BUG_ON.
