Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:50054 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbaKGVeR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Nov 2014 16:34:17 -0500
Received: by mail-lb0-f178.google.com with SMTP id f15so3700655lbj.37
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Nov 2014 13:34:15 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1415393693.1712.0@mail.thefacebook.com>
References: <1415392765-1877-1-git-send-email-fdmanana@suse.com>
	<1415393693.1712.0@mail.thefacebook.com>
Date: Fri, 7 Nov 2014 21:34:15 +0000
Message-ID: <CAL3q7H6--2DUN6T8VeHv5MjjEpvK5QVk23sG40_NJMChi8BmJQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: make xattr replace operations atomic
From: Filipe David Manana <fdmanana@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Alexandre Oliva <oliva@gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 7, 2014 at 8:54 PM, Chris Mason <clm@fb.com> wrote:
>
>
> On Fri, Nov 7, 2014 at 3:39 PM, Filipe Manana <fdmanana@suse.com> wrote:
>>
>> Replacing a xattr consists of doing a lookup for its existing value,
>> delete
>> the current value from the respective leaf, release the search path and
>> then
>> finally insert the new value. This leaves a time window where readers
>> (getxattr,
>> listxattrs) won't see any value for the xattr. Xattrs are used to store
>> ACLs,
>> so this has security implications.
>>
>> This change also fixes 2 other existing issues which were:
>>
>> *) Deleting the old xattr value without verifying first if the new xattr
>> will
>>    fit in the existing leaf item (in case multiple xattrs are packed in
>> the
>>    same item due to name hash collision);
>>
>> *) Returning -EEXIST when the flag XATTR_CREATE is given and the xattr
>> doesn't
>>    exist but we have have an existing item that packs muliple xattrs with
>>    the same name hash as the input xattr. In this case we should return
>> ENOSPC.
>>
>> A test case for xfstests follows soon.
>>
>> Thanks to Alexandre Oliva for reporting the non-atomicity of the xattr
>> replace
>> implementation.
>
>
> Thanks Filipe, one problem:
>
>> +
>> +               if (size > old_data_len) {
>> +                       if (btrfs_leaf_free_space(root, leaf) <
>> +                           (size - old_data_len)) {
>> +                               ret = -ENOSPC;
>> +                               goto out;
>> +                       }
>>                 }
>
>
> This means replacing an xattr item can fail if the leaf doesn't happen to
> have free space.  btrfs_search_slot already has code meant to extend the
> item, even if the item you're searching for is already found.  (see the call
> to split_leaf with extend == 1).
>
> So what you want to do is find out the current size of the item, and call
> btrfs search_slot again with that size + the extra needed for the new name.
> From there you should be able to call btrfs_extend_item like you currently
> are.

So what I do is call btrfs_seach_slot with ins_size == new_xattr_size.
If it returns -eoverflow (it couldn't extent by +new_size, which
includes the name, dir_item and btrfs_item structs), I don't return
immediately because after deleting the existing xattr we may have
enough space in the leaf (that is, we no longer to extend by new_size,
but by a smaller amount == new_size - old_size, and excluding the
name, dir_item and btrfs_item structs), effectively not requiring the
original size passed to btrfs_search_slot. So if I correctly
understood you, it's almost equivalent to your suggestion but without
releasing paths and keep retrying.

Did I miss something? :)

>
> -chris
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
