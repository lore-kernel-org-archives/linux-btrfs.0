From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v1 3/6] scrub: print paths of corrupted files
Date: Sat, 18 Jun 2011 13:26:29 +0200
Message-ID: <4DFC8B65.3010003@jan-o-sch.net>
References: <cover.1307991539.git.list.btrfs@jan-o-sch.net> <4dff2bfbba0f059cf91185c290d0c78bf9f6648d.1307991539.git.list.btrfs@jan-o-sch.net> <20110616212614.GC12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110616212614.GC12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Lots of quotation removed. All removed comments accepted.

On 16.06.2011 23:26, David Sterba wrote:
> On Mon, Jun 13, 2011 at 09:10:36PM +0200, Jan Schmidt wrote:
>> +struct scrub_warning {
>> +	struct btrfs_path	*path;
>> +	u64			extent_item_size;
>> +	char			*scratch_buf;
>> +	char			*msg_buf;
>> +	const char		*errstr;
>> +	u64			sector;
> 
> better named 'physical', like in scrub_bio

As I save a sector there and not a physical address, I still prefer
"sector". But as a compromise, I'll change the type to sector_t instead.

>> +static void scrub_print_warning(const char *errstr, struct scrub_bio *sbio,
>> +				int ix)
> 
> please rename 'ix' to eg 'idx', more readable

I'd like to stay consistent with the rest of the file, using ix at
similar opportunities. And besides: I like ix more than idx :-)

>> +{
>> +	struct btrfs_device *dev = sbio->sdev->dev;
>> +	struct btrfs_fs_info *fs_info = dev->dev_root->fs_info;
>> +	struct btrfs_path *path;
>> +	struct btrfs_key found_key;
>> +	struct extent_buffer *eb;
>> +	struct btrfs_extent_item *ei;
>> +	struct scrub_warning swarn;
>> +	u32 item_size;
>> +	int ret;
>> +	u64 ref_root;
> 
> i'm not able to understand what a u64 value describing a root means, seeing it
> here or in the printk message. it's returned as 
> 
> 	*dest_root = btrfs_extent_inline_ref_offset(eb, eiref);
> 
> can you please explain it to me?

Have a look at the BTRFS_*_TREE_OBJECTID #defines in ctree.h.
btrfs-debug-tree prints them as
                tree block backref root 2

>> +	u64 ref_level;
> 
> int is enough, as noted elsewhere
> 
>> +	unsigned long ptr = 0;
>> +	static const int bufsize = 4096;
> 
> drop static, this would allocate a memory cell to hold the value 4096, while
> without it, it's just a named constant and this will make the compiler happy
> 
>> +	loff_t extent_item_offset;
> 
> loff_t is a signed long long, do you really need it?

Seems I don't. I was looking around how I came to use loff_t in the
first place, but couldn't find a good reason. I'm replacing it with u64,
which makes more sense anyway, since the loff_t parameter I'm passing
around is the result of a subtraction of two u64s.

>> +
>> +	path = btrfs_alloc_path();
>> +
>> +	swarn.scratch_buf = kmalloc(bufsize, GFP_NOFS);
>> +	swarn.msg_buf = kmalloc(bufsize, GFP_NOFS);
>> +	swarn.sector = (sbio->physical + ix * PAGE_SIZE) >> 9;
>> +	swarn.logical = sbio->logical + ix * PAGE_SIZE;
>> +	swarn.errstr = errstr;
>> +	swarn.dev = dev;
>> +	swarn.msg_bufsize = bufsize;
>> +	swarn.scratch_bufsize = bufsize;
>> +
>> +	if (!path || !swarn.scratch_buf || !swarn.msg_buf)
>> +		goto out;
>> +
>> +	ret = data_extent_from_logical(fs_info->extent_root,
>> +					swarn.logical, path, &found_key);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	extent_item_offset = swarn.logical - found_key.objectid;
>> +	swarn.extent_item_size = found_key.offset;
>> +
>> +	eb = path->nodes[0];
>> +	ei = btrfs_item_ptr(eb, path->slots[0], struct btrfs_extent_item);
>> +	item_size = btrfs_item_size_nr(eb, path->slots[0]);
>> +
>> +	btrfs_release_path(path);
> 
> is it safe to release the path here? it's used in the else branch below

Yes, and it's even required, since iterate_extent_inodes() wants a
clean, usable path for itself. To make that more clear, I'll move the
call to btrfs_release_path inside the else block.

>> +
>> +	if (ret) {
>> +		ret = tree_backref_for_extent(&ptr, eb, ei, item_size,
>> +						&ref_root, &ref_level);
>> +		printk(KERN_WARNING "%s at logical %llu on dev %s, "
>> +			"sector %llu: metadata %s (level %llu) in tree %llu\n",
>> +			errstr, swarn.logical, dev->name, swarn.sector,
>> +			ref_level ? "node" : "leaf", ret < 0 ? -1 : ref_level,
>> +			ret < 0 ? -1 : ref_root);
>> +	} else {
>> +		swarn.path = path;
>> +		iterate_extent_inodes(eb, ei, extent_item_offset, item_size,
>> +					scrub_print_warning_inode, &swarn);
>> +	}
>> +
>> +out:
>> +	btrfs_free_path(path);
>> +	kfree(swarn.scratch_buf);
>> +	kfree(swarn.msg_buf);
>> +}
>> +
>>  /*
>>   * scrub_recheck_error gets called when either verification of the page
>>   * failed or the bio failed to read, e.g. with EIO. In the latter case,
>> @@ -218,6 +347,11 @@ static int scrub_recheck_error(struct scrub_bio *sbio, int ix)
>>  			if (scrub_fixup_check(sbio, ix) == 0)
>>  				return 0;
>>  		}
>> +		if (printk_ratelimit())
> 
> please don't use printk_ratelimit; as a simple printk_ratelimited is not
> applicable here, we have to use __ratelimit: (include/linux/printk.h)
> 
> static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
> 	DEFAULT_RATELIMIT_BURST);
> 
> if (__ratelimit(&_rs))

Modified as you suggested, I only included linux/ratelimit.h instead.

Thanks!
Jan
