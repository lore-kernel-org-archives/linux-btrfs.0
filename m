Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:52993 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab2JOGuE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 02:50:04 -0400
Message-ID: <507BB21A.4020700@jan-o-sch.net>
Date: Mon, 15 Oct 2012 08:50:02 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: extended inode refs support for send mechanism
References: <1349868091-23041-1-git-send-email-list.btrfs@jan-o-sch.net> <20121011213928.GY8097@wotan.suse.de>
In-Reply-To: <20121011213928.GY8097@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mark,

On Thu, October 11, 2012 at 23:39 (+0200), Mark Fasheh wrote:
> On Wed, Oct 10, 2012 at 01:21:31PM +0200, Jan Schmidt wrote:
>> @@ -1574,11 +1599,22 @@ static int get_first_ref(struct send_ctx *sctx,
>>  		goto out;
>>  	}
>>  
>> -	iref = btrfs_item_ptr(path->nodes[0], path->slots[0],
>> -			struct btrfs_inode_ref);
>> -	len = btrfs_inode_ref_name_len(path->nodes[0], iref);
>> -	ret = fs_path_add_from_extent_buffer(name, path->nodes[0],
>> -			(unsigned long)(iref + 1), len);
>> +	if (key.type == BTRFS_INODE_REF_KEY) {
>> +		struct btrfs_inode_ref *iref;
>> +		iref = btrfs_item_ptr(path->nodes[0], path->slots[0],
>> +				      struct btrfs_inode_ref);
>> +		len = btrfs_inode_ref_name_len(path->nodes[0], iref);
>> +		ret = fs_path_add_from_extent_buffer(name, path->nodes[0],
>> +						     (unsigned long)(iref + 1),
>> +						     len);
>> +	} else {
>> +		struct btrfs_inode_extref *extref;
>> +		extref = btrfs_item_ptr(path->nodes[0], path->slots[0],
>> +					struct btrfs_inode_extref);
>> +		len = btrfs_inode_extref_name_len(path->nodes[0], extref);
>> +		ret = fs_path_add_from_extent_buffer(name, path->nodes[0],
>> +					(unsigned long)&extref->name, len);
>> +	}
>>  	if (ret < 0)
>>  		goto out;
>>  	btrfs_release_path(path);
> 
> Ok there's the following line in get_first_ref() which I believe was missed:
> 
> 	*dir = found_key.offset;
> 
> that will have to account for an extended ref.

Oops. I will fix that.

> The rest of the patch looks pretty good to me. Thanks for writing this up!

Thanks for taking a look!
-Jan
