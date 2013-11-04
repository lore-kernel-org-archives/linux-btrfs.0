Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23928 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3KDDkA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Nov 2013 22:40:00 -0500
Message-ID: <52771705.4050008@oracle.com>
Date: Mon, 04 Nov 2013 11:39:49 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add framework to read fs info from btrfs-control
References: <1382721007-5531-1-git-send-email-anand.jain@oracle.com> <20131029213331.GC17681@lenny.home.zabbo.net>
In-Reply-To: <20131029213331.GC17681@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  (sorry for the delay, various external issues)
  I have sent out the new patch set. Thanks for the comments.
  more inline.


On 10/30/13 05:33 AM, Zach Brown wrote:
>
>> This adds ioctl BTRFS_IOC_GET_FSIDS which reads the fs
>> info through the btrfs-control
>
> Why not use sysfs?

  various sysfs interface for btrfs is still being a RFC
  ioctl would much simpler to get the bug fixed.

>> +	sz_fslist_arg = sizeof(*fslist_arg);
>> +	fslist_arg = memdup_user(arg, sz_fslist_arg);
>
> Doesn't check allocation failure.

fixed it.

>> +
>> +	sz_fslist = sizeof(*fslist) * fslist_arg->count;
>> +	kfree(fslist_arg);
>
> That allocation and copy and free gets a single u64.  Use
> copy_from_user() for the u64.

  oh yes. thanks.


>> +	fslist_arg = memdup_user(arg, sz_fslist_arg + sz_fslist);
>
> Allocates an arbitrarily huge size that depends only on user input.
> Doesn't check failure again.  And I bet you can scribble on kernel
> memory if you wrap the size.

  fixed it. now it finds the number of fsid and then allocates mem.


>> +	if (copy_to_user(arg, fslist_arg, sz_fslist_arg + sz_fslist))
>> +		ret = -EFAULT;
>
> And there's no reason to buffer all this in the kernel to begin with.
> Just copy_to_user() as you iterate over each fs_devices.

  Ok in the v2 patch I have narrowed the allocation and copy to
  just what is present. but I still feel one-shot copy is better.

  Now I have also used uuid_mutex its bit less granular for the
  purpose here but taking into consideration that thread is from
  btrfs-control (and so no root pointer is readily available) for
  which it should be fine IMO. any comments. thanks.

>> +			fslist = (struct btrfs_ioctl_fslist *) fslist +
>> +							sizeof(*fslist);
>
> AKA fslist++.

  fixed it.

> - z

  Posted V2.

Thanks, Anand
