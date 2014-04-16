Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:65017 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbaDPKgY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 06:36:24 -0400
Received: by mail-qa0-f53.google.com with SMTP id w8so10260430qac.26
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 03:36:23 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1468801.p0fTO3mgjp@localhost.localdomain>
References: <1396392799-9858-1-git-send-email-fdmanana@gmail.com>
	<1468801.p0fTO3mgjp@localhost.localdomain>
Date: Wed, 16 Apr 2014 11:36:23 +0100
Message-ID: <CAL3q7H68Z+6=oHUFMuHpkPET+Q-U23F_0W7rWEa7vXsGX_QgAg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: implement inode_operations callback tmpfile
From: Filipe David Manana <fdmanana@gmail.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linuxpatches@star.c10r.facebook.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 16, 2014 at 10:00 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Tuesday 01 Apr 2014 11:53:19 PM Filipe David Borba Manana wrote:
>> +static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
>> +{
>> +     struct btrfs_trans_handle *trans;
>> +     struct btrfs_root *root = BTRFS_I(dir)->root;
>> +     struct inode *inode = NULL;
>> +     u64 objectid;
>> +     u64 index;
>> +     int ret = 0;
>> +
>> +     /*
>> +      * 2 for inode item and ref
>> +      * 2 for dir items
>> +      * 1 for xattr if selinux is on
>> +      */
>> +     trans = btrfs_start_transaction(root, 5);
>> +     if (IS_ERR(trans))
>> +             return PTR_ERR(trans);
>> +
>
> Hello,
>
> Any particular reason to reserve space for 5 items? For the O_TMPFILE
> case we seem to allocate and use just the one inode item and none of
> the associated 'inode ref', 'dir item' and 'dir index item' since
> there is no directory entry associated with the file. I am not
> sure about the xattr item though.

Correct, not needed for directory entries.
The xattr is needed for the case where an acl is inherited. And 5
units are required for orphan insertion (see comment on top of
btrfs_orphan_add).
I'll update the comment.

Thanks

>
> Thanks,
> chandan.
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
