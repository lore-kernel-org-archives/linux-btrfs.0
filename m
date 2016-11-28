Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47312 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933335AbcK1UH3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 15:07:29 -0500
Date: Mon, 28 Nov 2016 12:07:01 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2 1/2] Btrfs: add more valid checks for superblock
Message-ID: <20161128200658.GA5005@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1464980715-6442-1-git-send-email-bo.li.liu@oracle.com>
 <20161125165019.GZ12522@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161125165019.GZ12522@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 25, 2016 at 05:50:19PM +0100, David Sterba wrote:
> On Fri, Jun 03, 2016 at 12:05:14PM -0700, Liu Bo wrote:
> > @@ -6648,6 +6648,7 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
> >  	struct btrfs_key found_key;
> >  	int ret;
> >  	int slot;
> > +	u64 total_dev = 0;
> >  
> >  	root = root->fs_info->chunk_root;
> >  
> > @@ -6689,6 +6690,7 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
> >  			ret = read_one_dev(root, leaf, dev_item);
> >  			if (ret)
> >  				goto error;
> > +			total_dev++;
> >  		} else if (found_key.type == BTRFS_CHUNK_ITEM_KEY) {
> >  			struct btrfs_chunk *chunk;
> >  			chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
> > @@ -6698,6 +6700,28 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
> >  		}
> >  		path->slots[0]++;
> >  	}
> > +
> > +	/*
> > +	 * After loading chunk tree, we've got all device information,
> > +	 * do another round of validation check.
> > +	 */
> > +	if (total_dev != root->fs_info->fs_devices->total_devices) {
> > +		btrfs_err(root->fs_info,
> > +	   "super_num_devices(%llu) mismatch with num_devices(%llu) found here",
> > +			  btrfs_super_num_devices(root->fs_info->super_copy),
> > +			  total_dev);
> > +		ret = -EINVAL;
> 
> Turns out this check is too strict in combination with an intermediate
> state and a bug in device deletion.
> 
> We've had several reports where a filesystem becomes unmountable due to
> the above check, where the wrong value is just stored in the superblock
> and is fixable by simply setting it to the right value. The right value
> is number of dev items found in the dev tree, which is exactly the
> total_dev that we read here.
> 
> The intermediate state can be caused by removing the device item in
> btrfs_rm_device (see comment before btrfs_rm_dev_item call). This
> apparently happens, when the device deletion is not finished, ie. the
> superblock is not overwritten with a new copy.

I see.

Looks like currently it does commit_transaction in btrfs_rm_devi_item() while it
doesn't in btrfs_add_device, so it turns out that the logics in adding a device
and removing a device are a little bit different,

btrfs_rm_device                              btrfs_init_new_devices
  ...                                          ...
  ->btrfs_rm_dev_item                          ->btrfs_start_transaction()
    ->btrfs_start_transaction                  ->mutex_lock(&device_list_mutex)
    ->#rm dev item in chunk tree               ->list_add
    ->btrfs_commit_transaction                 ->btrfs_set_super_num_device
  ->mutex_lock(&device_list_mutex)             ->mutex_unlock(&device_list_mutex)
  ->list_del()                                 ->btrfs_add_device
  ->btrfs_set_super_num_device                 ->btrfs_commit_transaction()
  ->mutext_unlock(&device_list_mutex)


Not sure why we made it different around commit_transaction, but seems that we
can avoid the situation described above by changing how we play with transaction
in rm_device.

> 
> So: do you agree to make it just a warning, and fixup the superblock
> num_devices here? A userspace fix is also possible, but when this
> happens and the filesystem is not mountable, a fix from outside of the
> filesystem might be hard.

I'm OK with setting up a warning.

Thanks,

-liubo

> 
> > +		goto error;
> > +	}
> > +	if (btrfs_super_total_bytes(root->fs_info->super_copy) <
> > +	    root->fs_info->fs_devices->total_rw_bytes) {
> > +		btrfs_err(root->fs_info,
> > +	"super_total_bytes(%llu) mismatch with fs_devices total_rw_bytes(%llu)",
> > +			  btrfs_super_total_bytes(root->fs_info->super_copy),
> > +			  root->fs_info->fs_devices->total_rw_bytes);
> > +		ret = -EINVAL;
> > +		goto error;
> > +	}
> >  	ret = 0;
> >  error:
> >  	unlock_chunks(root);
