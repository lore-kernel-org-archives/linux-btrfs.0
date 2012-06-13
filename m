Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab2FMNO2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 09:14:28 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5DDESdG012724
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 09:14:28 -0400
Date: Wed, 13 Jun 2012 09:14:27 -0400
From: Josef Bacik <josef@redhat.com>
To: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: use rcu to protect device->name V2
Message-ID: <20120613131426.GA2186@localhost.localdomain>
References: <1339530642-13862-1-git-send-email-josef@redhat.com>
 <20120612223526.GJ32402@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120612223526.GJ32402@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 13, 2012 at 12:35:26AM +0200, David Sterba wrote:
> On Tue, Jun 12, 2012 at 03:50:41PM -0400, Josef Bacik wrote:
> > +++ b/fs/btrfs/check-integrity.c
> > @@ -93,6 +93,7 @@
> >  #include "print-tree.h"
> >  #include "locking.h"
> >  #include "check-integrity.h"
> > +#include "rcu-string.h"
> >  
> >  #define BTRFSIC_BLOCK_HASHTABLE_SIZE 0x10000
> >  #define BTRFSIC_BLOCK_LINK_HASHTABLE_SIZE 0x10000
> > @@ -843,13 +844,14 @@ static int btrfsic_process_superblock_dev_mirror(
> >  		superblock_tmp->never_written = 0;
> >  		superblock_tmp->mirror_num = 1 + superblock_mirror_num;
> >  		if (state->print_mask & BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE)
> > -			printk(KERN_INFO "New initial S-block (bdev %p, %s)"
> > -			       " @%llu (%s/%llu/%d)\n",
> > -			       superblock_bdev, device->name,
> > -			       (unsigned long long)dev_bytenr,
> > -			       dev_state->name,
> > -			       (unsigned long long)dev_bytenr,
> > -			       superblock_mirror_num);
> > +			printk_in_rcu(KERN_INFO "New initial S-block (bdev %p,"
> 
> can you please add the 'btrfs: ' prefixes?
> 

No, I'm not changing the output of print statements in this patch, I'll leave
that up to the Strato guys.

> > +				     " %s) @%llu (%s/%llu/%d)\n",
> > +				     superblock_bdev,
> > +				     rcu_str_deref(device->name),
> > +				     (unsigned long long)dev_bytenr,
> > +				     dev_state->name,
> > +				     (unsigned long long)dev_bytenr,
> > +				     superblock_mirror_num);
> >  		list_add(&superblock_tmp->all_blocks_node,
> >  			 &state->all_blocks_list);
> >  		btrfsic_block_hashtable_add(superblock_tmp,
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index e39a3b9..7d658f2 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -44,6 +44,7 @@
> >  #include "free-space-cache.h"
> >  #include "inode-map.h"
> >  #include "check-integrity.h"
> > +#include "rcu-string.h"
> >  
> >  static struct extent_io_ops btree_extent_io_ops;
> >  static void end_workqueue_fn(struct btrfs_work *work);
> > @@ -2575,8 +2576,9 @@ static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
> >  		struct btrfs_device *device = (struct btrfs_device *)
> >  			bh->b_private;
> >  
> > -		printk_ratelimited(KERN_WARNING "lost page write due to "
> > -				   "I/O error on %s\n", device->name);
> > +		printk_in_rcu(KERN_WARNING "lost page write due to "
> 
> here
> 
> > +					  "I/O error on %s\n",
> > +					  rcu_str_deref(device->name));
> >  		/* note, we dont' set_buffer_write_io_error because we have
> >  		 * our own ways of dealing with the IO errors
> >  		 */
> > diff --git a/fs/btrfs/rcu-string.h b/fs/btrfs/rcu-string.h
> > new file mode 100644
> > index 0000000..2fbb56b
> > --- /dev/null
> > +++ b/fs/btrfs/rcu-string.h
> > @@ -0,0 +1,56 @@
> > +/*
> > + * Copyright (C) 2012 Red Hat.  All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public
> > + * License v2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> > + * General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public
> > + * License along with this program; if not, write to the
> > + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> > + * Boston, MA 021110-1307, USA.
> > + */
> > +
> > +struct rcu_string {
> > +	struct rcu_head rcu;
> > +	char str[0];
> > +};
> > +
> > +static inline struct rcu_string *rcu_string_strdup(const char *src, gfp_t mask)
> > +{
> > +	size_t len = strlen(src);
> > +	struct rcu_string *ret = kzalloc(sizeof(struct rcu_string) +
> > +					 (len * sizeof(char)), mask);
> 
> len + 1 ? or is the devname not null-terminated?

Oh hey strlen doesn't include the null how about that.  I will fix, thanks.

> 
> > +	if (!ret)
> > +		return ret;
> > +	strncpy(ret->str, src, len);
> > +	return ret;
> > +}
> > +
> > +static inline void rcu_string_free(struct rcu_string *str)
> > +{
> > +	if (str)
> > +		kfree_rcu(str, rcu);
> > +}
> > +
> > +#define printk_in_rcu(fmt, ...) do {	\
> > +	rcu_read_lock();		\
> > +	printk(fmt, ##__VA_ARGS__);	\
> 
> drop the ##
> see http://gcc.gnu.org/onlinedocs/cpp/Variadic-Macros.html
> 
>   #define eprintf(...) fprintf (stderr, __VA_ARGS__)
> 

Well everybody else in the kernel does it that way, but if this works I'll
change it.

> > +	rcu_read_unlock();		\
> > +} while (0)
> > +
> > +#define printk_ratelimited_in_rcu(fmt, ...) do {	\
> > +	rcu_read_lock();				\
> > +	printk_ratelimited(fmt, ##__VA_ARGS__);		\
> 
> here as well
> 
> > +	rcu_read_unlock();				\
> > +} while (0)
> > +
> > +#define rcu_str_deref(rcu_str) ({				\
> > +	struct rcu_string *__str = rcu_dereference(rcu_str);	\
> > +	__str->str;						\
> > +})
> 
> the printk_in_rcu looks ok to me. I thought about one more tweak (before
> I read your updated patch): add a format to print a rcu_string, like
> %pS, so the printk does the deref, but explicit deref is more visible at
> the callsite.
> 
> BTW, did I already say that this printk & rcu_string should be generic?
> :)

Yeah I'm not fighting for 3 months to get somebody to take this generically.  If
later on somebody wants to use it they can do the hard work to get it moved
somewhere for everybody to use, but I've got other things to fix.

> 
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 7782020..acf814b 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -415,6 +418,7 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
> >  	struct btrfs_fs_devices *fs_devices;
> >  	struct btrfs_device *device;
> >  	struct btrfs_device *orig_dev;
> > +	struct rcu_string *name;
> 
> this could be moved to the enclosing { ... } block
> 
> >  
> >  	fs_devices = kzalloc(sizeof(*fs_devices), GFP_NOFS);
> >  	if (!fs_devices)
> > @@ -434,11 +438,16 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
> 
> ... here
> 
> >  		if (!device)
> >  			goto error;
> >  
> > -		device->name = kstrdup(orig_dev->name, GFP_NOFS);
> > -		if (!device->name) {
> > +		/*
> > +		 * This is ok to do without rcu read locked because we hold the
> > +		 * uuid mutex so nothing we touch in here is going to disappear.
> > +		 */
> > +		name = rcu_string_strdup(orig_dev->name->str, GFP_NOFS);
> > +		if (!name) {
> >  			kfree(device);
> >  			goto error;
> >  		}
> > +		rcu_assign_pointer(device->name, name);
> >  
> >  		device->devid = orig_dev->devid;
> >  		device->work.func = pending_bios_fn;
> > @@ -491,7 +500,7 @@ again:
> >  		}
> >  		list_del_init(&device->dev_list);
> >  		fs_devices->num_devices--;
> > -		kfree(device->name);
> > +		rcu_string_free(device->name);
> >  		kfree(device);
> >  	}
> >  
> > @@ -516,7 +525,7 @@ static void __free_device(struct work_struct *work)
> >  	if (device->bdev)
> >  		blkdev_put(device->bdev, device->mode);
> >  
> > -	kfree(device->name);
> > +	rcu_string_free(device->name);
> >  	kfree(device);
> >  }
> >  
> > @@ -533,6 +542,7 @@ static void free_device(struct rcu_head *head)
> >  static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
> >  {
> >  	struct btrfs_device *device;
> > +	struct rcu_string *name;
> 
> and this one too, I saw a declaration block in the nested { } block, it
> won't be alone there
> 
> >  
> >  	if (--fs_devices->opened > 0)
> >  		return 0;
> > @@ -555,8 +565,11 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
> >  		new_device = kmalloc(sizeof(*new_device), GFP_NOFS);
> >  		BUG_ON(!new_device); /* -ENOMEM */
> >  		memcpy(new_device, device, sizeof(*new_device));
> > -		new_device->name = kstrdup(device->name, GFP_NOFS);
> > -		BUG_ON(device->name && !new_device->name); /* -ENOMEM */
> > +
> > +		/* Safe because we are under uuid_mutex */
> > +		name = rcu_string_strdup(device->name->str, GFP_NOFS);
> > +		BUG_ON(device->name && !name); /* -ENOMEM */
> > +		rcu_assign_pointer(new_device->name, name);
> >  		new_device->bdev = NULL;
> >  		new_device->writeable = 0;
> >  		new_device->in_fs_metadata = 0;
> > @@ -621,9 +634,9 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
> >  		if (!device->name)
> >  			continue;
> >  
> > -		bdev = blkdev_get_by_path(device->name, flags, holder);
> > +		bdev = blkdev_get_by_path(device->name->str, flags, holder);
> >  		if (IS_ERR(bdev)) {
> > -			printk(KERN_INFO "open %s failed\n", device->name);
> > +			printk(KERN_INFO "open %s failed\n", device->name->str);
> >  			goto error;
> >  		}
> >  		filemap_write_and_wait(bdev->bd_inode->i_mapping);
> > @@ -4694,8 +4716,11 @@ int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info)
> >  		key.offset = device->devid;
> >  		ret = btrfs_search_slot(NULL, dev_root, &key, path, 0, 0);
> >  		if (ret) {
> > -			printk(KERN_WARNING "btrfs: no dev_stats entry found for device %s (devid %llu) (OK on first mount after mkfs)\n",
> > -			       device->name, (unsigned long long)device->devid);
> > +			printk_in_rcu(KERN_WARNING "btrfs: no dev_stats entry "
> > +				      "found for device %s (devid %llu) (OK on"
> > +				      " first mount after mkfs)\n",
> 
> breaking printk strings hurts when grepping for a message
> 
> > +				      rcu_str_deref(device->name),
> > +				      (unsigned long long)device->devid);
> >  			__btrfs_reset_dev_stats(device);
> >  			device->dev_stats_valid = 1;
> >  			btrfs_release_path(path);
> > @@ -4747,8 +4772,9 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
> >  	BUG_ON(!path);
> >  	ret = btrfs_search_slot(trans, dev_root, &key, path, -1, 1);
> >  	if (ret < 0) {
> > -		printk(KERN_WARNING "btrfs: error %d while searching for dev_stats item for device %s!\n",
> > -		       ret, device->name);
> > +		printk_in_rcu(KERN_WARNING "btrfs: error %d while searching "
> > +			      "for dev_stats item for device %s!\n", ret,
> 
> and here as well
> 
> > +			      rcu_str_deref(device->name));
> >  		goto out;
> >  	}
> >  
> > @@ -4757,8 +4783,9 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
> >  		/* need to delete old one and insert a new one */
> >  		ret = btrfs_del_item(trans, dev_root, path);
> >  		if (ret != 0) {
> > -			printk(KERN_WARNING "btrfs: delete too small dev_stats item for device %s failed %d!\n",
> > -			       device->name, ret);
> > +			printk_in_rcu(KERN_WARNING "btrfs: delete too small "
> > +				      "dev_stats item for device %s failed %d!\n",
> 
> here
> 
> > +				      rcu_str_deref(device->name), ret);
> >  			goto out;
> >  		}
> >  		ret = 1;
> > @@ -4770,8 +4797,9 @@ static int update_dev_stat_item(struct btrfs_trans_handle *trans,
> >  		ret = btrfs_insert_empty_item(trans, dev_root, path,
> >  					      &key, sizeof(*ptr));
> >  		if (ret < 0) {
> > -			printk(KERN_WARNING "btrfs: insert dev_stats item for device %s failed %d!\n",
> > -			       device->name, ret);
> > +			printk_in_rcu(KERN_WARNING "btrfs: insert dev_stats "
> > +				      "item for device %s failed %d!\n",
> 
> here
> 
> > +				      rcu_str_deref(device->name), ret);
> >  			goto out;
> >  		}
> >  	}
> 
> mostly minor things, but please fix them.
> 

I'm breaking them for the 80 char limit, it happens for all long messages, we're
all used to it.  I'll fix up the other things.  Thanks,

Josef
