Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28045 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab2FOJeD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 05:34:03 -0400
Message-ID: <4FDB0350.9000504@cn.fujitsu.com>
Date: Fri, 15 Jun 2012 17:41:36 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: don't update atime on RO subvolumes
References: <1339746573-3573-1-git-send-email-ablock84@googlemail.com>	<4FDAF8D9.60201@cn.fujitsu.com> <CAB9VWqCJK8=Oy=tCdBAZg1jLRMguNrZE0i+cV_BZJoxrOpAP6A@mail.gmail.com>
In-Reply-To: <CAB9VWqCJK8=Oy=tCdBAZg1jLRMguNrZE0i+cV_BZJoxrOpAP6A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/15/2012 05:18 PM, Alexander Block wrote:

> On Fri, Jun 15, 2012 at 10:56 AM, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>> index f6ab6f5..4d0ceed 100644
>>> --- a/fs/btrfs/inode.c
>>> +++ b/fs/btrfs/inode.c
>>> @@ -4478,6 +4478,11 @@ int btrfs_dirty_inode(struct inode *inode)
>>>  static int btrfs_update_time(struct inode *inode, struct timespec *now,
>>>                            int flags)
>>>  {
>>> +     struct btrfs_root *root = BTRFS_I(inode)->root;
>>> +
>>> +     if (btrfs_root_readonly(root))
>>> +             return -EROFS;
>>> +
>>
>> It also needs to acquire root->fs_info->subvol_sem, doesn't it?
>>
>> thanks,
>> liubo
>>
> 
> Normally yes I think. But does it matter at this point? If the flags are
> modified at the same time as we access them, wouldn't it be still
> random which value (old/new) we get, even with subvol_sem?
> 
> (sorry for the double mail Liu...as always forgot Reply All)
> 


I find other callers use btrfs_root_readonly without subvol_sem either,
anyway, I'm ok with this patch.

thanks,
liubo
