Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42444 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751203AbbDHHgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2015 03:36:21 -0400
Message-ID: <5524DA70.4060501@cn.fujitsu.com>
Date: Wed, 8 Apr 2015 15:36:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Omar Sandoval <osandov@osandov.com>
CC: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Btrfs: unify subvol= and subvolid= mounting
References: <cover.1428471096.git.osandov@osandov.com> <0d43234f1b2c1d35a06e8259ca94c7d976e0a604.1428471096.git.osandov@osandov.com> <5524C556.1040607@cn.fujitsu.com> <20150408071703.GA24891@mew>
In-Reply-To: <20150408071703.GA24891@mew>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [PATCH 2/3] Btrfs: unify subvol= and subvolid= mounting
From: Omar Sandoval <osandov@osandov.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年04月08日 15:17

> On Wed, Apr 08, 2015 at 02:06:14PM +0800, Qu Wenruo wrote:
>>
>>
>> -------- Original Message  --------
>> Subject: [PATCH 2/3] Btrfs: unify subvol= and subvolid= mounting
>> From: Omar Sandoval <osandov@osandov.com>
>> To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba
>> <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
>> Date: 2015年04月08日 13:34
>>
>>> Currently, mounting a subvolume with subvolid= takes a different code
>>> path than mounting with subvol=. This isn't really a big deal except for
>>> the fact that mounts done with subvolid= or the default subvolume don't
>>> have a dentry that's connected to the dentry tree like in the subvol=
>>> case. To unify the code paths, when given subvolid= or using the default
>>> subvolume ID, translate it into a subvolume name by walking
>>> ROOT_BACKREFs in the root tree and INODE_REFs in the filesystem trees.
>
> Hi, Qu,
>
>> Oh, this patch is what I have tried long long ago, and want to do the same
>> thing, to show subvolume mount for btrfs.
>
> Thanks for pointing that out, I didn't come across your post when I was
> looking around. I figured that someone must have thought of it first :)
>
>> But it came to me that, superblock->show_path() is a better method to do it.
>>
>> You can implement btrfs_show_path() to allow mountinfo to get the subvolume
>> name from subvolid, and don't change the mount routine much.
>
> Hm, I don't think that the changes to the mount code would be
> unwarranted. Having one code path makes it more obvious what's going on.
> Do you mind elaborating on why you preferred doing it in ->show_path()?
The story seems to be long.

At that time, I also tried to do the subvolid->path convert and it seems 
works.

But another problem, IIRC, btrfs losing its security label bug,
will be triggered more easy if we all go through the "subvol=" routine,
as that routine will use vfs_mount twice. The second time it will
definitely lost the security label.

Although the problem is later resolved by handling security label 
internally, but it drove me not touching the mount routine.


Also another problem is, "subvolid=" routine can also happen when the fs 
is already mounted, so there may be some operations ,like deleting files 
and dirs, interfere your subvolid->path search codes.
(During your while loop, there is a race windows between your 
release_path() and search_slot())
Resulting a mount failure even nothing goes wrong.

->show_path() method can't avoid above race problem, but the good thing 
is, even race happens, it won't disturb our mount.
Just a -EBUSY when showing /proc/self/mountinfo, not a mount failure.


Thanks,
Qu
>
> Thanks!
>
>> Thanks,
>> Qu
>
