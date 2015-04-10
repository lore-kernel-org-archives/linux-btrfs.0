Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25245 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751510AbbDJAdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 20:33:15 -0400
Message-ID: <55271A48.20005@cn.fujitsu.com>
Date: Fri, 10 Apr 2015 08:33:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Omar Sandoval <osandov@osandov.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Btrfs: unify subvol= and subvolid= mounting
References: <cover.1428471096.git.osandov@osandov.com> <0d43234f1b2c1d35a06e8259ca94c7d976e0a604.1428471096.git.osandov@osandov.com> <5524C556.1040607@cn.fujitsu.com> <20150409161054.GG25622@twin.jikos.cz>
In-Reply-To: <20150409161054.GG25622@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [PATCH 2/3] Btrfs: unify subvol= and subvolid= mounting
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年04月10日 00:10

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
>> Oh, this patch is what I have tried long long ago, and want to do the
>> same thing, to show subvolume mount for btrfs.
>>
>> But it came to me that, superblock->show_path() is a better method to do it.
>>
>> You can implement btrfs_show_path() to allow mountinfo to get the
>> subvolume name from subvolid, and don't change the mount routine much.
>
> The problem I see with the show_mount approach is related to the
> additional path lookup, memory allocation and locking.
>
> If the mountpoint dentry is the right on ,it's just a simple seq_dentry
> in show_options.
>
> OTOH, your patch takes subvol_sem that will block the callback if
> there's eg. a subvolume being deleted (that takes the write lock). This
> is not a lightweight operation nor an infrequent one. There are more
> write locks to subvol_sem.
Thanks for pointing out this problem.
That's right.

But I found that, since in show_path() function, we can just return 
-EAGAIN without breaking anything, locking in btrfs_path should be enough.

So I can remove all the unneeded lock/sem.

Thanks,
Qu
>
> I'm not sure if I've ever sent this comment back to you, sorry if not.
>
