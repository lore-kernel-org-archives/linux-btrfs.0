Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:37947 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbdLIXMu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Dec 2017 18:12:50 -0500
Received: by mail-qt0-f176.google.com with SMTP id d4so30983118qtj.5
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Dec 2017 15:12:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b484d30c-f32d-78cf-7f07-b9cadb43a2d1@gmx.com>
References: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
 <211ded6e-5b02-0c33-b75e-b0ad6ff30ca4@gmx.com> <CABi++uKoMgi3WMw4z+kgJ1G2H_y_2e2Czg0OLwf18g9GmoU2Cg@mail.gmail.com>
 <2f4346d5-ccb9-8de2-11d1-b270058723c1@gmx.com> <CABi++uLD_2sXjuF6b0GKhWAX6fRRA0jqqUaujWP6_q+hiuvSXw@mail.gmail.com>
 <b484d30c-f32d-78cf-7f07-b9cadb43a2d1@gmx.com>
From: Benjamin Beichler <hadrian2002@googlemail.com>
Date: Sat, 9 Dec 2017 23:12:29 +0000
Message-ID: <CABi++u+Asgyrxq7+txcdJ4EkknrpTTOo7B1G36-Mymk+Wfhv6A@mail.gmail.com>
Subject: Re: Chunk-Recovery fails with alignment error
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

2017-12-07 12:09 GMT+00:00 Qu Wenruo <quwenruo.btrfs@gmx.com>:
>
> Since the btrfs chunk recovery doesn't work and my dirty quick hack
> doesn't work either, I don't expect much to recovery.
>
> Unless we have more detailed info about the how and why the BUG_ON() of
> chunk recovery is triggered.
>
> That's to say, it will be a quite time consuming work to use gdb to
> locate the problem, and see if any developer (mostly me) could use the
> info to further dig into the problem or fix it.
> (Considering the difference in timezone, I expect at least 8+ weeks to
> get a conclusion)

I'm really pleased that you want to help me, of course the current
backtrace was quite useless.
Firstly, I revised the code a bit, and since one run over the 1,7TB
drive took about 6h, I thought about saving the state of already found
chunks. I simply saved all bytenr which are valid to a file. The
consequence was a reduction of the time for scan_one_device to about
30s. If you think this could be interesting for the normal version, I
could create a patch for this.

>
> If you really want to do it, please step into the function
> btrfs_insert_item() in __rebuild_device_items() and to see at which
> point -EIO is returned.
>
> My guess is btrfs_search_slot() call in btrfs_insert_empty_items().
>
> If that's true, please call
>
> btrfs_print_tree(root->fs_info->chunk_root, root->fs_info->chunk_root->node, 1)
>
> in gdb, just before the btrfs_search_slot() call above, to show what's
> the problem.
>
Your guess was right. The current stack trace and btrfs_print_tree is
under : https://gist.github.com/anonymous/2cf40ac1d3ddcbca95177acec78041b2

As you can see, the code in disk.io:321 explicitly exclude the the
sector from 0 to sectorsize, and states it is unaligned. I think
because the code found a chunk/block at address zero, this triggers
the problem. Is it possible, that there live chunks/blocks at address
0 or is this fuzzy data?

>
> BTW, currently nothing in chunk tree/super block contains any info of
> your fs, feel free to share it with the mail list, where more guys may help.
>
I added the list, I simply forgot it in some answer.

> Thanks,
> Qu
>

thanks

Benjamin
