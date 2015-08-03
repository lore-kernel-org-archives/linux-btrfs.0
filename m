Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36824 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbbHCHpx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 03:45:53 -0400
Received: by lbbud7 with SMTP id ud7so69290516lbb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 00:45:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55BEC24E.5010908@cn.fujitsu.com>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
	<558CB0D4.8060401@cn.fujitsu.com>
	<558CB404.8050300@cn.fujitsu.com>
	<CAJCQCtTMdQG4EB8dNAYPq8H3V68TCb2YQztoXXYMkCYA3GBCXw@mail.gmail.com>
	<CAO5K3OcA1_Z4-jvv_2C0StBkOr++_vUX4kOspY8cuhnX2t3z_A@mail.gmail.com>
	<CAJCQCtQ35xzMBjcUUTzWm3CjC1r=UNgkog2YbB0X1QcZofNj0g@mail.gmail.com>
	<559F131B.30206@cn.fujitsu.com>
	<CAC8ULPaOWS=WS-_oSkihrzi7bnWXuevyqL3R7FPFFQQCdjqdvA@mail.gmail.com>
	<CAC8ULPaYmQNj_cvgGxqKtJ4w237J5vAJFTQMO1=o+y+eUYrPLg@mail.gmail.com>
	<55BAD89A.8030203@cn.fujitsu.com>
	<CAC8ULPbe+E6JzGS-BYvjoLTN+Y9j6PYGC4U3f5cYhgz=eaaUOg@mail.gmail.com>
	<55BEC24E.5010908@cn.fujitsu.com>
Date: Mon, 3 Aug 2015 10:45:51 +0300
Message-ID: <CAC8ULPYTqWQBbG5xkYRpVk+EmkgWz4Fu2CN-WAH2Nyzw175EVQ@mail.gmail.com>
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260 __btrfs_abort_transaction+0x4b/0x120
From: Robert Munteanu <robert.munteanu@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>, Vytautas D <vytdau@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 3, 2015 at 4:22 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Yes, you're right, that's a dead loop.
>
> But for better debugging, would you please upload the following info?
> 1) output of command "btrfs-debug-tree -t 5 <DEV>".
> The only important things are info about that inode.
> Whose objectid(first item in a key) is 14214570 and type is one of the
> following:
> INODE_ITEM, INODE_REF, EXTENT_DATA
> So you may only need to cut the things like below:
> ======
>         item 4 key (14214570 INODE_ITEM 0) itemoff 15881 itemsize 160
>                 inode generation 6 transid 6 size 1073741824 nbytes
> 1073741824
>                 block group 0 mode 100644 links 1 uid 0 gid 0
>                 rdev 0 flags 0x0
>         item 5 key (14214570 INODE_REF XXX) itemoff 15866 itemsize 15
>                 inode ref index 2 namelen 5 name: file1
>         item 6 key (14214570 EXTENT_DATA 0) itemoff 15813 itemsize 53
>                 extent data disk byte 2176843776 nr 134217728
>                 extent data offset 0 nr 134217728 ram 134217728
>                 extent compression 0
>         item 7 key (14214570 EXTENT_DATA XXX) itemoff 15760 itemsize 53
>                 extent data disk byte 2311061504 nr 134217728
>                 extent data offset 0 nr 134217728 ram 134217728
>                 extent compression 0
>         ....(All items with 14214570 objectid is needed to debug)
> ======
>
> And it's highly recommended to only cut that part and paste it.
> Not only to reduce the output, but also help your privacy.
> As you can see, INODE_REF contains file name, which can be sometimes leaking
> your personal infomation.

        item 46 key (14214570 INODE_ITEM 0) itemoff 11902 itemsize 160
                inode generation 2285 transid 2308 size 32768 nbytes 0
                block group 0 mode 100644 links 1 uid 1000 gid 100
                rdev 0 flags 0x10
        item 47 key (14214570 INODE_REF 5506079) itemoff 11875 itemsize 27
                inode ref index 300 namelen 17 name: root-0bc95412.log


I double-checked and there is no EXTENT_DATA entry.

>
> 2) output of command "btrfs-debug-tree -t 2 <DEV>"
> Just in case your extent tree mismatch with fs tree.

The gzipped log is 13MB, so I've uploaded it to
https://dl.dropboxusercontent.com/u/3160732/btrfs-debug-tree-t-2.log.gz
; sha1sum is fb4c671bb90b97aa64f6d3938948100c2175e6a5 .

>
> If you don't like to execute 2 commands and are OK with leaking file/dir
> names, you can also use "btrfs-debug-tree <DEV>" to dump every metadata
> info.

If the above aren't enough I will provide the more comprehensive output.

>
> Alternatively, if "btrfs-image -c9 <DEV>" works without problem, it will
> also helps a lot for debugging.

This one is also quite large ( 332MB ) ->
https://dl.dropboxusercontent.com/u/3160732/sda1-btrfs-image-c9.img ;
sha1sum is c243e127a317f69faa5548993914a678f6f79524.

Thanks,

Robert
