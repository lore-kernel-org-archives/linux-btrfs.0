Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:45993 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132Ab3GEIGf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 04:06:35 -0400
Received: by mail-vc0-f170.google.com with SMTP id hf12so1439503vcb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jul 2013 01:06:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130704095138.GB12359@gmail.com>
References: <20130704095138.GB12359@gmail.com>
Date: Fri, 5 Jul 2013 12:06:33 +0400
Message-ID: <CANaxB-wvUcs2bKjrJUtKQxojFM86kF-oLwdWcm9d0i2MjHCJ6g@mail.gmail.com>
Subject: Re: btrfs: stat(2) and /proc/pid/maps returns different devices
From: Andrey Wagin <avagin@gmail.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: kzak@redhat.com, xemul@openvz.org, Mark Fasheh <mfasheh@suse.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2013/7/4 Andrew Vagin <avagin@gmail.com>:
> Hi All,
>
> I want to resurrect an old problem. Currently stat(2) returns another
> device than other places where the device is printed (/proc/pid/maps,
> /proc/pid/fdinfo/, unix-diag). stat(2) reports devices, which is absent
> in /proc/pid/mountinfo.

Hi Chris,

I found that this issue was introduced by yours changes:

commit 3394e1607eaf870ebba37d303fbd590a4c569908
Author: Chris Mason <chris.mason@oracle.com>
Date:   Mon Nov 17 20:42:26 2008 -0500

    Btrfs: Give each subvol and snapshot their own anonymous devid

Now we need to find a way how to fix other places (not only stat(2)).

Could you look at Mark Fasheh's fix and my points, why we can't use
vfs_getattr in this case? Maybe you will have any ideas or comments
about this issue.

Thanks

>
> # cat /proc/self/mountinfo | grep mnt
> 40 32 0:32 / /mnt rw,relatime shared:27 - btrfs /dev/loop0 rw,noacl,space_cache
>
> # cat /proc/2943/maps
> 00400000-00406000 r-xp 00000000 00:20 260 /mnt/xxx/sleep
>
> # stat -L -c "%D" /proc/2943/map_files/400000-406000
> 23
>
> We are not first who suffer from this problem:
> https://bugzilla.redhat.com/show_bug.cgi?id=711881
> http://marc.info/?l=linux-btrfs&m=130074451403261
> https://bugzilla.openvz.org/show_bug.cgi?id=2653
>
> This bug looks like KABI violation.
>
> And about 2 years ago Mark Fasheh tried to fix this problem:
> http://thr3ads.net/btrfs-devel/2011/05/2346176-RFC-PATCH-0-2-btrfs-vfs-Return-same-device-in-stat-2-and-proc-pid-maps
>
> Eric Biederman sugested to not create a new method and use vfs_getattr,
> but here is a few problems:
> * fanotify doesn't have dentry, but its fdinfo contains device.
> * vfs_getattr can fail and which device should be shown in this case?
> * vfs_getattr gets much more parameters, so here is a question about
>   performance degradation.
>
> So I have a question: Can two inodes from different subvolumes have
> equal inode numbers?
>
> If someone have any suggestions how to fix this problem or any
> explanation why this is not a problem at all, please write here.
>
> Thanks.
