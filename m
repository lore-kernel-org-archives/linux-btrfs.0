Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f170.google.com ([209.85.210.170]:34812 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3CJEVS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Mar 2013 23:21:18 -0500
Received: by mail-ia0-f170.google.com with SMTP id h8so2671831iaa.15
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Mar 2013 20:21:18 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 10 Mar 2013 12:21:18 +0800
Message-ID: <CAP9B-Qkzy=Q+Lh5zeH7LhgQUQuEa4DPubku6cTr4DEuVxu1Swg@mail.gmail.com>
Subject: about btrfs quota issues
From: Shilong Wang <wangshilong1991@gmail.com>
To: Arne Jansen <sensille@gmx.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Arne

          Steps to reproduce:


                mkfs.btrfs <disk>
                mount <disk> <mnt>
                btrfs quota enable <mnt>

                btrfs sub create <mnt>/sub
                btrfs qgroup create 1/1 <mnt>
                btrfs qgroup assign sub_qgroupid 1/1 <mnt>


                dd if=/dev/zero of=<mnt>/sub/data bs=1M count=1
                sync
                btrfs qgroup show  <mnt>
                #until now, every thing goes well, however, if snapshot happens
                #the quota accounting will go wrong

               btrfs sub snapshot <mnt>/sub <mnt>/snap
               sync
               btrfs qgroup show <mnt>
               #the accounting information of group(1/1) is not expected
               #here exclusive of group (1/1) do not change as expected.

So i took a close look at the algorithm of quota accounting, the 3
steps of algorithm don't
consider some cases like the above example.

In fact, i think you try to put some work on users, especially when
snapshot happens.
It is complex to track all the group's accounting when having
snapshots..See the following
commands.

btrfs sub snapshot -c src_qgroupid:dst_qgroupid  <mnt>
btrfs sub snapshot  -x src_qgroupid:dst_qgroupid <mnt>


Are these commands designed for some cases regarding to
snapshots/subvolume cases?
If so, i think it really confusing and too complex for users to do
such work, is't it?...

BTW, i have a question about the function btrfs_qgroup_inherit(),
when copying exclusive value from src_qgroup to dst_qgroup:

       dst_qgroup->exclusive = src_qgroup->exclusive + level_size

while copying referenced value from src_qgroup to dot_qgroup:

       dst_qgroup->referenced = src_qgroup->referenced -level_size

I can't really figure out...~_~

Thanks,
Wang
