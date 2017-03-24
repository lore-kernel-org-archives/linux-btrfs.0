Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34293 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750721AbdCXRal (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Mar 2017 13:30:41 -0400
Received: by mail-it0-f66.google.com with SMTP id z70so1341193itb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Mar 2017 10:30:40 -0700 (PDT)
MIME-Version: 1.0
From: Hirotaka Yamamoto <ymmt2005@gmail.com>
Date: Sat, 25 Mar 2017 02:29:59 +0900
Message-ID: <CAC4Rxrf_PQO7kFypB-mJ1xYV_zMbpZuzngGGvALY=TxwQ-JKVQ@mail.gmail.com>
Subject: Re: [PATCH] fix inconsistent device between /proc/pid/maps and stat
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, satoru.takeuchi@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

2017-03-24 20:58 GMT+09:00 David Sterba <dsterba@suse.cz>:
> On Tue, Mar 21, 2017 at 10:53:09AM +0900, Satoru Takeuchi wrote:
>> There have been some discussions about inconsistent device between /proc/pid/maps and stat(2).
>>
>> http://thr3ads.net/btrfs-devel/2011/05/2346176-RFC-PATCH-0-2-btrfs-vfs-Return-same-device-in-stat-2-and-proc-pid-maps
>> https://www.spinics.net/lists/linux-btrfs/msg09044.html
>> https://patchwork.kernel.org/patch/2825842/
>> https://patchwork.kernel.org/patch/2831525/
>>
>> It's important since it breaks user programs like lsof(8). There was a patche by Mark to fix this problem.
>> However, unfortunately, that patch is not merged so far.
>
> And no variant of the get_map_dev will ever be merged. Reworking this
> requires extensions to the superblock and subvolume structures, making
> it more generic and suitable for VFS.

Aside from how to fix, yet I think fixing this is quite important.

I have found the problem when I wanted to list processes using vulnerable
shared libraries by, say, "lsof /lib/x86_64-linux-gnu/libcrypto.so.1.0.0".

As lsof did not report any process, I almost failed to restart processes
that were using the library in reality after installing upgrades.

Leaving this problem would open a big security concern as btrfs is
getting more popular.

Satoru, thank you for the proposal, and good luck to further
improvements!

@ymmt2005
