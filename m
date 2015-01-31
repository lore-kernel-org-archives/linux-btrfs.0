Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:13200 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbbAaCay (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 21:30:54 -0500
Message-ID: <54CC3E59.2050204@huawei.com>
Date: Sat, 31 Jan 2015 10:30:49 +0800
From: Miao Xie <miaoxie@huawei.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v5 0/9] btrfs: Fix freeze/sysfs deadlock in better method.
References: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com> <20150130191749.GZ3641@twin.jikos.cz>
In-Reply-To: <20150130191749.GZ3641@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 30 Jan 2015 20:17:49 +0100, David Sterba wrote:
> On Fri, Jan 30, 2015 at 05:20:45PM +0800, Qu Wenruo wrote:
>> [Use VFS protect for sysfs change]
>> The 6th patch will introduce a new help function sb_want_write() to
>> claim write permission to a superblock.
>> With this, we are able to do write protection like mnt_want_write() but
>> only needs to ensure that the superblock is writeable.
>> This also keeps the same synchronized behavior using ioctl, which will
>> block on frozen fs until it is unfrozen.
> 
> You know what I think abuot the commit inside sysfs, but it looks better
> to me now with the sb_* protections so I give it a go.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

I worried about the following case

# fsfreeze btrfs
# echo "new label" > btrfs_sysfs
It should be hangup


On the other terminal
# umount btrfs


Because the 2nd echo command didn't increase mount reference, so umount
would not know someone still blocked on the fs, it would not go back and
return EBUSY like someone access the fs by common fs interface, it would
deactive fs directly and then blocked on sysfs removal.


Thanks
Miao
