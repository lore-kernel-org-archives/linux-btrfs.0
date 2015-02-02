Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31118 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753456AbbBBBe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Feb 2015 20:34:58 -0500
Message-ID: <54CED4B5.3030702@cn.fujitsu.com>
Date: Mon, 2 Feb 2015 09:36:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Miao Xie <miaoxie@huawei.com>, <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v5 0/9] btrfs: Fix freeze/sysfs deadlock in better method.
References: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com> <20150130191749.GZ3641@twin.jikos.cz> <54CC3E59.2050204@huawei.com>
In-Reply-To: <54CC3E59.2050204@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH v5 0/9] btrfs: Fix freeze/sysfs deadlock in better 
method.
From: Miao Xie <miaoxie@huawei.com>
To: <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>, 
<linux-btrfs@vger.kernel.org>
Date: 2015年01月31日 10:30
> On Fri, 30 Jan 2015 20:17:49 +0100, David Sterba wrote:
>> On Fri, Jan 30, 2015 at 05:20:45PM +0800, Qu Wenruo wrote:
>>> [Use VFS protect for sysfs change]
>>> The 6th patch will introduce a new help function sb_want_write() to
>>> claim write permission to a superblock.
>>> With this, we are able to do write protection like mnt_want_write() but
>>> only needs to ensure that the superblock is writeable.
>>> This also keeps the same synchronized behavior using ioctl, which will
>>> block on frozen fs until it is unfrozen.
>> You know what I think abuot the commit inside sysfs, but it looks better
>> to me now with the sb_* protections so I give it a go.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> I worried about the following case
>
> # fsfreeze btrfs
> # echo "new label" > btrfs_sysfs
> It should be hangup
Yes, same as "btrfs pro set <mnt> label "
>
>
> On the other terminal
> # umount btrfs
Oh, that's a problem.
It can be umounted, but....
>
>
> Because the 2nd echo command didn't increase mount reference, so umount
> would not know someone still blocked on the fs, it would not go back and
> return EBUSY like someone access the fs by common fs interface, it would
> deactive fs directly and then blocked on sysfs removal.
The btrfs module can't be removed, but not blocked. Just return -EBUSY.
So at least it won't cause annoying block problem.

Although hard for sysadmin to find pinpoint the real block reason, it is 
still resolvable, mount again and unfreeze
can resolve it.
But it never seems to be a reasonable behavior for me either.

Just as you mentioned, in sysfs, we only have sb, no vfsmount, so 
without huge VFS change(*),
we could either accept the wrong method, or drop all write sysfs support 
for transaction-invoking features.

*: Maybe we can add ref counts to sb, and umount syscall checks for the 
sb ref counts if the mount point
is the last vfsmount of it. I'm not sure whether it is worthy but it 
seems valid.

Thanks,
Qu

>
>
> Thanks
> Miao

