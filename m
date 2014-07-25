Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64607 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756598AbaGYBTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 21:19:13 -0400
Message-ID: <53D1B08A.2000403@cn.fujitsu.com>
Date: Fri, 25 Jul 2014 09:19:06 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs: Call mount_subtree() even 'subvolid=' mount
 option is given.
References: <1405483631-23037-1-git-send-email-quwenruo@cn.fujitsu.com> <1405483631-23037-2-git-send-email-quwenruo@cn.fujitsu.com> <20140724124818.GX1553@twin.jikos.cz>
In-Reply-To: <20140724124818.GX1553@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for your comment.

I'm very sorry that this patch takes your time to review, but later 
patch(show_path one) should replace this patch.
As mentioned in that thread, this patch is not completly working.
And in fact, show_path() patch is the v2 version of this patch, but due 
to change of patch name, I didn't add the v2
tag.

Thanks,
Qu

-------- Original Message --------
Subject: Re: [PATCH 1/2] btrfs: Call mount_subtree() even 'subvolid=' 
mount option is given.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年07月24日 20:48
> On Wed, Jul 16, 2014 at 12:07:10PM +0800, Qu Wenruo wrote:
>> btrfs uses differnet routine to handle 'subvolid=' and 'subvol=' mount
>> option.
>> Given 'subvol=' mount option, btrfs will mount btrfs first and then call
>> mount_subtree() to mount a subtree of btrfs, making vfs handle the path
>> searching.
>> This is good since vfs layer know extactly that a subtree mount is done
>> and findmnt(8) knows which subtree is mounted.
>>
>> However when using 'subvolid=' mount option, btrfs will do all the
>> internal subvolume objectid searching and checking, making VFS unaware
>> about which subtree is mounted, as result, findmnt(8) can't showing any
>> useful subtree mount info for end users.
>>
>> This patch will use the root backref to reverse search the subvolume
>> path for a given subvolid, making findmnt(8) works again.
>>
>> Reported-by: Stefan G.Weichinger <lists@xunil.at>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Ack for unifying the way subvol= and subvolid= are handled, but I don't
> like some aspects of the implementation.
>
> The kmalloc/krealloc makes it really complicated and is not imho
> necessary. The mount options length is limited to PAGE_SIZE in the vfs
> code. Do the same here, allocate a page, filter the options, do the
> necessary processing and just check for overflows.
>
> You can drop u64_to_strlen.
>
>> +#define CLEAR_SUBVOL		1
>> +#define CLEAR_SUBVOLID		2
> Though they're internal and local to the file, please add BTRFS_ prefix
> at least.
>
>>   /*
>> - * This will strip out the subvol=%s argument for an argument string and add
>> - * subvolid=0 to make sure we get the actual tree root for path walking to the
>> - * subvol we want.
>> + * This will strip out the subvol=%s or subvolid=%s argument for an argumen
>> + * string and add subvolid=0 to make sure we get the actual tree root for path
>> + * walking to the subvol we want.
>>    */
>> -static char *setup_root_args(char *args)
>> +static char *setup_root_args(char *args, int flags, u64 subvol_objectid)
>>   {
>> -	unsigned len = strlen(args) + 2 + 1;
>> -	char *src, *dst, *buf;
>> +	unsigned len;
>> +	char *src = NULL, *dst, *buf, *comma;
> Please use the recommended style and put each on a separate line. I'm
> not sure if you'll need all of them for the implementation witouth the
> kmallocs, the comment applies generally.
>
>> +	char *subvol_string = "subvolid=";
>> +	int option_len = 0;
>> +
>> +	if (!args) {
>> +		/* Case 1, not args, all default mounting
>> +		 * just return 'subvolid=<FS_ROOT>' */
> Not the preferred style of comments.
>
>> +		len = strlen(subvol_string) +
>> +		      u64_to_strlen(subvol_objectid) + 1;
>> +		dst = kmalloc(len, GFP_NOFS);
>> +		if (!dst)
>> +			return NULL;
>> +		sprintf(dst, "%s%llu", subvol_string, subvol_objectid);
>> +		return dst;
>> +	}
>>   
>> -	/*
>> -	 * We need the same args as before, but with this substitution:
>> -	 * s!subvol=[^,]+!subvolid=0!
>> -	 *
>> -	 * Since the replacement string is up to 2 bytes longer than the
>> -	 * original, allocate strlen(args) + 2 + 1 bytes.
>> -	 */
>> +	switch (flags) {
>> +	case CLEAR_SUBVOL:
>> +		src = strstr(args, "subvol=");
>> +		break;
>> +	case CLEAR_SUBVOLID:
>> +		src = strstr(args, "subvolid=");
>> +		break;
>> +	}
>>   
>> -	src = strstr(args, "subvol=");
>> -	/* This shouldn't happen, but just in case.. */
>> -	if (!src)
>> -		return NULL;
>> +	if (!src) {
>> +		/* Case 2, some args, default subvolume mounting
>> +		 * just append ',subvolid=<FS_ROOT>' */
>> +
>> +		/* 1 for ending '\0', 1 for leading ',' */
>> +		len = strlen(args) + strlen(subvol_string) +
>> +		      u64_to_strlen(subvol_objectid) + 2;
>> +		dst = kmalloc(len, GFP_NOFS);
>> +		if (!dst)
>> +			return NULL;
>> +		strcpy(dst, args);
>> +		sprintf(dst + strlen(args), ",%s%llu", subvol_string,
>> +			subvol_objectid);
>> +		return dst;
>> +	}
>> +
>> +	/* Case 3, subvolid=/subvol=  mount
>> +	 * repalce the 'subvolid/subvol' options to 'subvolid=<FS_ROOT>' */
>> +	comma = strchr(src, ',');
>> +	if (comma)
>> +		option_len = comma - src;
>> +	else
>> +		option_len = strlen(src);
>> +	len = strlen(args) - option_len  + strlen(subvol_string) +
>> +	      u64_to_strlen(subvol_objectid) + 1;
>>   
>>   	buf = dst = kmalloc(len, GFP_NOFS);
>>   	if (!buf)
>> @@ -1154,28 +1208,126 @@ static char *setup_root_args(char *args)
>>   		dst += strlen(args);
>>   	}
>>   
>> -	strcpy(dst, "subvolid=0");
>> -	dst += strlen("subvolid=0");
>> +	len = sprintf(dst, "%s%llu", subvol_string, subvol_objectid);
>> +	dst += len;
>>   
>>   	/*
>>   	 * If there is a "," after the original subvol=... string,
>>   	 * copy that suffix into our buffer.  Otherwise, we're done.
>>   	 */
>> -	src = strchr(src, ',');
>> -	if (src)
>> -		strcpy(dst, src);
>> +	if (comma)
>> +		strcpy(dst, comma);
>>   
>>   	return buf;
>>   }
>>   
>> -static struct dentry *mount_subvol(const char *subvol_name, int flags,
>> -				   const char *device_name, char *data)
>> +static char *str_append_head(char *dest, char *src)
> I think this is called 'prepend' :)
>
>> +{
>> +	memmove(dest + strlen(src), dest, strlen(dest) + 1);
>> +	memcpy(dest, src, strlen(src));
> Yes, prepends src to dest inplace.
>
>> +	return dest;
>> +}
>> +
>> +/* Find the path for given subvol_objectid.
>> + * Caller needs to readlock the root tree and kzalloc PATH_MAX for
>> + * subvol_name and namebuf */
>> +static char *find_subvol_by_id(struct btrfs_root *root, u64 subvol_objectid)
>> +{
>> +	struct btrfs_key key;
>> +	struct btrfs_key found_key;
>> +	struct btrfs_root_ref *ref;
>> +	struct btrfs_path *path;
>> +	char *namebuf = NULL;
>> +	char *new_buf = NULL;
>> +	char *subvol_ret = NULL;
>> +	int ret = 0;
>> +	u16 namelen = 0;
>> +
>> +	path = btrfs_alloc_path();
>> +	/* Alloc 1 byte for later strlen() calls */
>> +	subvol_ret = kzalloc(1, GFP_NOFS);
>> +	if (!path || !subvol_ret) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	key.objectid = subvol_objectid;
>> +	key.type = BTRFS_ROOT_BACKREF_KEY;
>> +	key.offset = 0;
>> +	/* We don't need to lock the tree_root,
>> +	 * if when we do the backref walking, some one deleted/moved
>> +	 * the subvol, we just return -ENOENT or let mount_subtree
>> +	 * return -ENOENT and no disaster will happen.
>> +	 * User should not modify subvolume when trying to mount it */
>> +	while (key.objectid != BTRFS_FS_TREE_OBJECTID) {
>> +		ret = btrfs_search_slot_for_read(root, &key, path, 1, 1);
>> +		if (ret < 0)
>> +			goto out;
>> +		if (ret) {
>> +			ret = -ENOENT;
>> +			goto out;
>> +		}
>> +		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
>> +				      path->slots[0]);
>> +		if (found_key.objectid != key.objectid ||
>> +		    found_key.type != BTRFS_ROOT_BACKREF_KEY) {
>> +			ret = -ENOENT;
>> +			goto out;
>> +		}
>> +		key.objectid = found_key.offset;
>> +		ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
>> +				     struct btrfs_root_ref);
>> +		namelen = btrfs_root_ref_name_len(path->nodes[0], ref);
>> +		/* One for ending '\0' One for '/' */
>> +		new_buf = krealloc(namebuf, namelen + 2, GFP_NOFS);
>> +		if (!new_buf) {
>> +			ret = -ENOMEM;
>> +			goto out;
>> +		}
>> +		namebuf = new_buf;
>> +		read_extent_buffer(path->nodes[0], namebuf,
>> +				   (unsigned long)(ref + 1), namelen);
>> +		btrfs_release_path(path);
>> +		*(namebuf + namelen) = '/';
>> +		*(namebuf + namelen + 1) = '\0';
>> +
>> +		new_buf = krealloc(subvol_ret, strlen(subvol_ret) + namelen + 2,
>> +				   GFP_NOFS);
>> +		if (!new_buf) {
>> +			ret = -ENOMEM;
>> +			goto out;
>> +		}
>> +		subvol_ret = new_buf;
>> +		str_append_head(subvol_ret, namebuf);
>> +	}
>> +out:
>> +	kfree(namebuf);
>> +	btrfs_free_path(path);
>> +	if (ret < 0) {
>> +		kfree(subvol_ret);
>> +		return ERR_PTR(ret);
>> +	} else
>> +		return subvol_ret;
>> +
>> +}
>> +
>> +static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
>> +				   int flags, const char *device_name,
>> +				   char *data)
>>   {
>>   	struct dentry *root;
>>   	struct vfsmount *mnt;
>> +	struct btrfs_root *tree_root = NULL;
>>   	char *newargs;
>> +	char *subvol_ret = NULL;
>> +	int ret = 0;
>>   
>> -	newargs = setup_root_args(data);
>> +	if (subvol_name)
>> +		newargs = setup_root_args(data, CLEAR_SUBVOL,
>> +					  BTRFS_FS_TREE_OBJECTID);
>> +	else
>> +		newargs = setup_root_args(data, CLEAR_SUBVOLID,
>> +					  BTRFS_FS_TREE_OBJECTID);
> There's no other value passed to setup_root_args than
> BTRFS_FS_TREE_OBJECTID? So you can put it directly to setup_root_args,
> or I'm missing someting.

