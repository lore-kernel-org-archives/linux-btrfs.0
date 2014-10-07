Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51805 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751252AbaJGBEC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Oct 2014 21:04:02 -0400
Message-ID: <54333BEE.7070308@cn.fujitsu.com>
Date: Tue, 7 Oct 2014 09:03:42 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Eryu Guan <guaneryu@gmail.com>
CC: <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Make btrfs handle security mount options internally
 to avoid losing security label.
References: <1411450808-14988-1-git-send-email-quwenruo@cn.fujitsu.com> <54329935.7080404@fb.com> <20141006133827.GF13950@dhcp-13-216.nay.redhat.com>
In-Reply-To: <20141006133827.GF13950@dhcp-13-216.nay.redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs: Make btrfs handle security mount options 
internally to avoid losing security label.
From: Eryu Guan <guaneryu@gmail.com>
To: <quwenruo@cn.fujitsu.com>
Date: 2014年10月06日 21:38
> On Mon, Oct 06, 2014 at 09:29:25AM -0400, Josef Bacik wrote:
>> On 09/23/2014 01:40 AM, Qu Wenruo wrote:
>>> [BUG]
>>> Originally when mount btrfs with "-o subvol=" mount option, btrfs will
>>> lose all security lable.
>>> And if the btrfs fs is mounted somewhere else, due to the lost of
>>> security lable, SELinux will refuse to mount since the same super block
>>> is being mounted using different security lable.
>>>
>>> [REPRODUCER]
>>> With SELinux enabled:
>>>   #mkfs -t btrfs /dev/sda5
>>>   #mount -o context=system_u:object_r:nfs_t:s0 /dev/sda5 /mnt/btrfs
>>>   #btrfs subvolume create /mnt/btrfs/subvol
>>>   #mount -o subvol=subvol,context=system_u:object_r:nfs_t:s0 /dev/sda5
>>>    /mnt/test
>>>
>>> kernel message:
>>> SELinux: mount invalid.  Same superblock, different security settings
>>> for (dev sda5, type btrfs)
>>>
>>> [REASON]
>>> This happens because btrfs will call vfs_kern_mount() and then
>>> mount_subtree() to handle subvolume name lookup.
>>> First mount will cut off all the security lables and when it comes to
>>> the second vfs_kern_mount(), it has no security label now.
>>>
>>> [FIX]
>>> This patch will makes btrfs behavior much more like nfs,
>>> which has the type flag FS_BINARY_MOUNTDATA,
>>> making btrfs handles the security label internally.
>>> So security label will be set in the real mount time and won't lose
>>> label when use with "subvol=" mount option.
>>>
>> Please make this an xfstest, I'm going to change how subvols are mounted in
>> a bit and I'd like to make sure I don't break anything.  Thanks,
> Hi Qu, I'll submit one xfstest, just want to make sure you don't do
> duplicated work here.
>
> Thanks,
> Eryu
Thanks a lot.

I remember you have already submitted an xfstest testcase for this.

Thanks,
Qu
