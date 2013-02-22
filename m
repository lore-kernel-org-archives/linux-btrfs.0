Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:36327 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435Ab3BVJum (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 04:50:42 -0500
Received: by mail-la0-f43.google.com with SMTP id ek20so427091lab.30
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 01:50:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51273BB7.60504@cn.fujitsu.com>
References: <1361520691-22665-1-git-send-email-bo.li.liu@oracle.com>
	<CAAdM645SGn=in2xq-Gv=DBCfpxJvynQEywr5tq7sh=jt-J197A@mail.gmail.com>
	<20130222084034.GC12835@liubo.cn.oracle.com>
	<51273BB7.60504@cn.fujitsu.com>
Date: Fri, 22 Feb 2013 04:50:40 -0500
Message-ID: <CAAdM645yVtL0_-uZozCWD7L1q+gcGPk+nptxyVTP-b7iOfb7yQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: update inode flags when renaming
From: Marios Titas <redneb8888@gmail.com>
To: miaox@cn.fujitsu.com
Cc: bo.li.liu@oracle.com, btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wouldn't though inheriting create all sorts of problems? For instance
check the example that I give in my other responese [1].

[1] http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg22396.html

On Fri, Feb 22, 2013 at 4:34 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> On      fri, 22 Feb 2013 16:40:35 +0800, Liu Bo wrote:
>> On Fri, Feb 22, 2013 at 03:32:50AM -0500, Marios Titas wrote:
>>> Sorry, but the bug persists even with the above patch.
>>>
>>> touch test
>>> chattr +C test
>>> lsattr test
>>> mv test test2
>>> lsattr test2
>>>
>>> In the above scenario test2 will not have the C flag.
>>
>> What do you expect?  IMO it's right that test2 does not have the C flag.
>
> No, it's not right.
> For the users, they expect the C flag is not lost because they just do
> a rename operation. but fixup_inode_flags() re-sets the flags by the
> parent directory's flag.
>
> I think we should inherit the flags from the parent just when we create
> a new file/directory, in the other cases, just give a option to the users.
> How do you think about?
>
> Thanks
> Miao
>
>>
>> This patch ensure that we get the same result after we remount, no more
>> the C flag coming back :)
>>
>> thanks,
>> liubo
>>
>>>
>>> On Fri, Feb 22, 2013 at 3:11 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>>>> A user reported some weird behaviours,
>>>> if we move a file with the noCow flag to a directory without the
>>>> noCow flag, the file is now without the flag, but after remount,
>>>> we'll find the file's noCow flag comes back.
>>>>
>>>> This is because we missed a proper inode update after inheriting
>>>> parent directory's flags,
>>>>
>>>> Reported-by: Marios Titas <redneb8888@gmail.com>
>>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>>> ---
>>>>  fs/btrfs/inode.c |    7 +++++--
>>>>  1 files changed, 5 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>>> index d9984fa..d2e3352 100644
>>>> --- a/fs/btrfs/inode.c
>>>> +++ b/fs/btrfs/inode.c
>>>> @@ -7478,8 +7478,6 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>>>>                                         old_dentry->d_inode,
>>>>                                         old_dentry->d_name.name,
>>>>                                         old_dentry->d_name.len);
>>>> -               if (!ret)
>>>> -                       ret = btrfs_update_inode(trans, root, old_inode);
>>>>         }
>>>>         if (ret) {
>>>>                 btrfs_abort_transaction(trans, root, ret);
>>>> @@ -7514,6 +7512,11 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>>>>         }
>>>>
>>>>         fixup_inode_flags(new_dir, old_inode);
>>>> +       ret = btrfs_update_inode(trans, root, old_inode);
>>>> +       if (ret) {
>>>> +               btrfs_abort_transaction(trans, root, ret);
>>>> +               goto out_fail;
>>>> +       }
>>>>
>>>>         ret = btrfs_add_link(trans, new_dir, old_inode,
>>>>                              new_dentry->d_name.name,
>>>> --
>>>> 1.7.7.6
>>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
