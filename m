Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12698 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750918AbbHCBW1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Aug 2015 21:22:27 -0400
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260
 __btrfs_abort_transaction+0x4b/0x120
To: Robert Munteanu <robert.munteanu@gmail.com>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
 <558CB0D4.8060401@cn.fujitsu.com> <558CB404.8050300@cn.fujitsu.com>
 <CAJCQCtTMdQG4EB8dNAYPq8H3V68TCb2YQztoXXYMkCYA3GBCXw@mail.gmail.com>
 <CAO5K3OcA1_Z4-jvv_2C0StBkOr++_vUX4kOspY8cuhnX2t3z_A@mail.gmail.com>
 <CAJCQCtQ35xzMBjcUUTzWm3CjC1r=UNgkog2YbB0X1QcZofNj0g@mail.gmail.com>
 <559F131B.30206@cn.fujitsu.com>
 <CAC8ULPaOWS=WS-_oSkihrzi7bnWXuevyqL3R7FPFFQQCdjqdvA@mail.gmail.com>
 <CAC8ULPaYmQNj_cvgGxqKtJ4w237J5vAJFTQMO1=o+y+eUYrPLg@mail.gmail.com>
 <55BAD89A.8030203@cn.fujitsu.com>
 <CAC8ULPbe+E6JzGS-BYvjoLTN+Y9j6PYGC4U3f5cYhgz=eaaUOg@mail.gmail.com>
CC: Chris Murphy <lists@colorremedies.com>, Vytautas D <vytdau@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55BEC24E.5010908@cn.fujitsu.com>
Date: Mon, 3 Aug 2015 09:22:22 +0800
MIME-Version: 1.0
In-Reply-To: <CAC8ULPbe+E6JzGS-BYvjoLTN+Y9j6PYGC4U3f5cYhgz=eaaUOg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes, you're right, that's a dead loop.

But for better debugging, would you please upload the following info?
1) output of command "btrfs-debug-tree -t 5 <DEV>".
The only important things are info about that inode.
Whose objectid(first item in a key) is 14214570 and type is one of the 
following:
INODE_ITEM, INODE_REF, EXTENT_DATA
So you may only need to cut the things like below:
======
         item 4 key (14214570 INODE_ITEM 0) itemoff 15881 itemsize 160
                 inode generation 6 transid 6 size 1073741824 nbytes 
1073741824
                 block group 0 mode 100644 links 1 uid 0 gid 0
                 rdev 0 flags 0x0
         item 5 key (14214570 INODE_REF XXX) itemoff 15866 itemsize 15
                 inode ref index 2 namelen 5 name: file1
         item 6 key (14214570 EXTENT_DATA 0) itemoff 15813 itemsize 53
                 extent data disk byte 2176843776 nr 134217728
                 extent data offset 0 nr 134217728 ram 134217728
                 extent compression 0
         item 7 key (14214570 EXTENT_DATA XXX) itemoff 15760 itemsize 53
                 extent data disk byte 2311061504 nr 134217728
                 extent data offset 0 nr 134217728 ram 134217728
                 extent compression 0
         ....(All items with 14214570 objectid is needed to debug)
======

And it's highly recommended to only cut that part and paste it.
Not only to reduce the output, but also help your privacy.
As you can see, INODE_REF contains file name, which can be sometimes 
leaking your personal infomation.

2) output of command "btrfs-debug-tree -t 2 <DEV>"
Just in case your extent tree mismatch with fs tree.

If you don't like to execute 2 commands and are OK with leaking file/dir 
names, you can also use "btrfs-debug-tree <DEV>" to dump every metadata 
info.

Alternatively, if "btrfs-image -c9 <DEV>" works without problem, it will 
also helps a lot for debugging.

Thanks,
Qu


Robert Munteanu wrote on 2015/07/31 16:38 +0300:
> On Fri, Jul 31, 2015 at 5:08 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Any full output about it?
>
> Please see the attached log. I left the process running for about 4
> hours, and after the first five minutes all it cared about was a
> single inode. I ended up stopping it as it looks like it's not making
> progress.
>
>> Not sure if it real loops, but maybe the inode number changed in later
>> output?
>
> Looks to me like it's the same inode
>
>    $ awk '/ for inode/ { print $7  } ' screenlog.0  | sort | uniq
>    14214570
>
> Thanks,
>
> Robert
>
>
>
>
>
>
>
