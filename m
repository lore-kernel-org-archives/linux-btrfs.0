Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51771 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2FOJSk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 05:18:40 -0400
Received: by dady13 with SMTP id y13so3775020dad.19
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jun 2012 02:18:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FDAF8D9.60201@cn.fujitsu.com>
References: <1339746573-3573-1-git-send-email-ablock84@googlemail.com>
	<4FDAF8D9.60201@cn.fujitsu.com>
Date: Fri, 15 Jun 2012 11:18:40 +0200
Message-ID: <CAB9VWqCJK8=Oy=tCdBAZg1jLRMguNrZE0i+cV_BZJoxrOpAP6A@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: don't update atime on RO subvolumes
From: Alexander Block <ablock84@googlemail.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 15, 2012 at 10:56 AM, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index f6ab6f5..4d0ceed 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -4478,6 +4478,11 @@ int btrfs_dirty_inode(struct inode *inode)
>>  static int btrfs_update_time(struct inode *inode, struct timespec *now,
>>                            int flags)
>>  {
>> +     struct btrfs_root *root = BTRFS_I(inode)->root;
>> +
>> +     if (btrfs_root_readonly(root))
>> +             return -EROFS;
>> +
>
>
> It also needs to acquire root->fs_info->subvol_sem, doesn't it?
>
> thanks,
> liubo
>

Normally yes I think. But does it matter at this point? If the flags are
modified at the same time as we access them, wouldn't it be still
random which value (old/new) we get, even with subvol_sem?

(sorry for the double mail Liu...as always forgot Reply All)
