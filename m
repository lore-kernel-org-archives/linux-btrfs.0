Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:36228 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753922AbdHWMH5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 08:07:57 -0400
Received: by mail-io0-f179.google.com with SMTP id p141so6593984iop.3
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 05:07:57 -0700 (PDT)
Subject: Re: finding root filesystem of a subvolume?
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <22940.17147.756378.347580@tree.ty.sabi.co.uk>
 <62494c0c-0c27-5b36-3727-b8755eb2cb58@gmail.com>
 <22940.27854.159264.779233@tree.ty.sabi.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3026f8a6-0ea6-0ed2-41c7-7d25c51a32fe@gmail.com>
Date: Wed, 23 Aug 2017 08:07:53 -0400
MIME-Version: 1.0
In-Reply-To: <22940.27854.159264.779233@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-22 13:41, Peter Grandi wrote:
> [ ... ]
> 
>>> There is no fixed relationship between the root directory
>>> inode of a subvolume and the root directory inode of any
>>> other subvolume or the main volume.
> 
>> Actually, there is, because it's inherently rooted in the
>> hierarchy of the volume itself. That root inode for the
>> subvolume is anchored somewhere under the next higher
>> subvolume.
> 
> This stupid point relies on ignoring that it is not mandatory to
> mount the main volume, and that therefore "There is no fixed
> relationship between the root directory inode of a subvolume and
> the root directory inode of any other subvolume or the main
> volume", because the "root directory inode" of the "main volume"
> may not be mounted at all.
> 
> This stupid point also relies on ignoring that subvolumes can be
> mounted *also* under another directory, even if the main volume
> is mounted somewhere else. Suppose that the following applies:
> 
>    subvol=5	/local
>    subvol=383	/local/.backup/home
>    subvol=383	/mnt/home-backup
> 
> and you are given the mountpoint '/mnt/home-backup', how can you
> find the main volume mountpoint '/local' from that?Assuming /mnt/home-backup is mounted and visible in /proc/mounts (your 
explanation requires it was either mounted directly via a subvol option 
or indirectly via a bind mount), then the following generic method works 
(and should always work on a modern kernel):
1. Find it in /proc/mounts or the output of `mount` run without any 
arguments.
2. If the mount type is 'bind', the device field will point to the 
source directory.  Using any method you like, figure out what the actual 
mount point that is under is, and repeat from step one with that mount 
point.
3. If the mount type is 'btrfs', and 'subvolid=5' is present in the 
mount options (this gets added automatically on any recent kernel), you 
just found the top level subvolume.
4. If the mount type is 'btrfs', and 'subvolid=5' is not present in the 
mount options, scan /proc/mounts for other entries with the same device 
value (this is going to be consistent).
5. If another entry does exist, and has 'subvolid=5' in the mount 
options, that's the top level subvolume.
6. If other entries exist, but 'subvolid=5' not in the mount options for 
any of them, or no other entries exist, the top level volume isn't 
mounted, and you can view it by mounting the device with 'subvolid=5'.

In the event that you need to know where the next higher level subvolume 
is mounted instead of the root subvolume for the volume, you can use the 
same method, but add the following after step two to figure out what 
subvolid to look for:
2b. Run `btrfs subvol show` on the mount point (it by definition has to 
be a subvolume because it's mounted and it's not a bind mount in 
userspace).  Find the 'Top level ID' (note that this just points to the 
next higher subvolume, not the root subvolume) value in the output, and 
use that instead of 5 when looking for 'subvolid=' options.
> 
> Please explain how '/mnt/home-backup' is indeed "inherently
> rooted in the hierarchy of the volume itself", because there is
> always a "fixed relationship between the root directory inode of
> a subvolume and the root directory inode of any other subvolume
> or the main volume".
You did one of three things to mount that:
1. You used a bind mount directly.  In this case, you're not changing 
the relation at all of the subvolume (which is technically not what's 
mounted in this case because a bind mount operates at the VFS layer and 
knows nothing about subvolumes) and it's parent subvolumes.
2. You mounted using 'subvol=.backup/home'.  This in and of itself 
should pretty concisely explain that there is a hierarchical 
relationship between subvolumes.  That path indicates the path in the 
hierarchy of the volume itself used to access the subvolume.
3. You mounted using 'subvolid=383'.  This is the only case where there 
isn't a hierarchical relationship, and just uses the tree ID to 
reference the subvolume.  This is the only case where there isn't some 
direct reference to the parent subvolume.

Note also that this relation is not inherent to the subvolume, but to 
it's parent.  Just like a symbolic link, the reference is in the 
containing object, not the referenced object (although subvolumes do 
store info about what their parent subvolume is).
> 
> [ ... ]
> 
>> Again, it does, it's just not inherently exposed to userspace
>> unless you mount the top-level subvolume (subvolid=5 and/or
>> subvol=/ in mount options).
> 
> This extra stupid point is based on ignoring that to "mount the
> top-level subvolume" relies on knowing already which one is the
> "top-level subvolume", which is begging the question.
You have information in /proc/mounts as to what is mounted.  Trace your 
particular path up to that, and then mount the indicated block device 
with `-o subvolid=5`.  The subvolume with ID 5 is _ALWAYS_ the top level 
subvolume for the volume, that's inherently hard coded in the filesystem 
format, so if that's all you want it's trivial to get it.
