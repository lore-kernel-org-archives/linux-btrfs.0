Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56348 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbaKGUzC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 15:55:02 -0500
Date: Fri, 7 Nov 2014 15:54:53 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: make xattr replace operations atomic
To: Filipe Manana <fdmanana@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <oliva@gnu.org>,
        Filipe Manana <fdmanana@suse.com>
Message-ID: <1415393693.1712.0@mail.thefacebook.com>
In-Reply-To: <1415392765-1877-1-git-send-email-fdmanana@suse.com>
References: <1415392765-1877-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, Nov 7, 2014 at 3:39 PM, Filipe Manana <fdmanana@suse.com> wrote:
> Replacing a xattr consists of doing a lookup for its existing value, 
> delete
> the current value from the respective leaf, release the search path 
> and then
> finally insert the new value. This leaves a time window where readers 
> (getxattr,
> listxattrs) won't see any value for the xattr. Xattrs are used to 
> store ACLs,
> so this has security implications.
> 
> This change also fixes 2 other existing issues which were:
> 
> *) Deleting the old xattr value without verifying first if the new 
> xattr will
>    fit in the existing leaf item (in case multiple xattrs are packed 
> in the
>    same item due to name hash collision);
> 
> *) Returning -EEXIST when the flag XATTR_CREATE is given and the 
> xattr doesn't
>    exist but we have have an existing item that packs muliple xattrs 
> with
>    the same name hash as the input xattr. In this case we should 
> return ENOSPC.
> 
> A test case for xfstests follows soon.
> 
> Thanks to Alexandre Oliva for reporting the non-atomicity of the 
> xattr replace
> implementation.

Thanks Filipe, one problem:

> +
> +		if (size > old_data_len) {
> +			if (btrfs_leaf_free_space(root, leaf) <
> +			    (size - old_data_len)) {
> +				ret = -ENOSPC;
> +				goto out;
> +			}
>  		}

This means replacing an xattr item can fail if the leaf doesn't happen 
to have free space.  btrfs_search_slot already has code meant to extend 
the item, even if the item you're searching for is already found.  (see 
the call to split_leaf with extend == 1).

So what you want to do is find out the current size of the item, and 
call btrfs search_slot again with that size + the extra needed for the 
new name.  From there you should be able to call btrfs_extend_item like 
you currently are.

-chris



