Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:54867 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaILBug (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 21:50:36 -0400
Received: by mail-qg0-f49.google.com with SMTP id j5so60206qga.36
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 18:50:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5411AB68.7020506@fb.com>
References: <1410254376-6357-1-git-send-email-rongqing.li@windriver.com>
	<5411AB68.7020506@fb.com>
Date: Fri, 12 Sep 2014 09:50:36 +0800
Message-ID: <CAJFZqHzey9rNoX-EnNQ344_QNVwObdGKtX-GT61qwh3-8SeStA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix a overflowing boundary writing in csum_tree_block
From: Li RongQing <roy.qing.li@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Rongqing Li <rongqing.li@windriver.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do you means we can handle it like below?  I think it is not better,
if that, csum size can not the expand, and the code in csum_tree_block
seems redundancy;

If you do not want to truncate in first patch, I think we can try to avoid it

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 22a3676..baed6c0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -879,6 +879,7 @@ static struct dentry *btrfs_mount(struct
file_system_type *fs_type, int flags,
        u64 subvol_objectid = 0;
        u64 subvol_rootid = 0;
        int error = 0;
+       u16 csum_size;

        if (!(flags & MS_RDONLY))
                mode |= FMODE_WRITE;
@@ -974,6 +975,13 @@ static struct dentry *btrfs_mount(struct
file_system_type *fs_type, int flags,
                return root;
        }

+       csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
+       if (csum_size > 4) {
+               printk(KERN_ERR "btrfs: csume size is larger than 4\n");
+               deactivate_locked_super(s);
+               return -EINVAL;
+       }
+
        return root;

 error_close_devices:

On Thu, Sep 11, 2014 at 10:02 PM, Chris Mason <clm@fb.com> wrote:
> On 09/09/2014 05:19 AM, rongqing.li@windriver.com wrote:
>> From: Li RongQing <roy.qing.li@gmail.com>
>>
>> It is impossible that csum_size is larger than sizeof(long), but the codes
>> still add the handler for this condition, like allocate new memory, for
>> extension. If it becomes true someday, copying csum_size size memory to local
>> 32bit variable found and val will overflow these two variables.
>>
>> Fix it by returning the max 4 byte checksum.
>
> Thanks for the patch.  I'd rather not silently truncate the copy down
> though.  How about a one time check at mount to make sure the value in
> the super is reasonable?
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
