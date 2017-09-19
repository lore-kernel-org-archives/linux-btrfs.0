Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33554 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdISThe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 15:37:34 -0400
Received: by mail-lf0-f67.google.com with SMTP id y15so320098lfd.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 12:37:34 -0700 (PDT)
Subject: Re: ERROR: parent determination failed (btrfs send-receive)
To: Dave <davestechshop@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAH=dxU7t=p8MVh1y2Tv7wPrP=1ntYcHCy7W6aBQGRtMp_gaaRA@mail.gmail.com>
 <1fa167f4-a8ba-84c7-8e06-9c7e9f3d30e7@gmail.com>
 <CAH=dxU4yTdKQwZX3L-oOMs2ZYiR82m1-F0GhbSU4SV_K2jrBGA@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <a8df8ca2-8bc4-994a-2de0-fda8e9fc3985@gmail.com>
Date: Tue, 19 Sep 2017 22:37:31 +0300
MIME-Version: 1.0
In-Reply-To: <CAH=dxU4yTdKQwZX3L-oOMs2ZYiR82m1-F0GhbSU4SV_K2jrBGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

18.09.2017 09:10, Dave пишет:
> I use snap-sync to create and send snapshots.
> 
> GitHub - wesbarnett/snap-sync: Use snapper snapshots to backup to external drive
> https://github.com/wesbarnett/snap-sync
> 

Are you trying to backup top-level subvolume? I just reproduced this
behavior with this tool. The problem is, snapshots of top-level
subvolume do not have parent UUID (I am not even sure if UUID exists at
all TBH). If you mount any other subvolume, it will work. On openSUSE
root is always mounted as subvolume (actually, the very first snapshot)
which explains why I did not see it before.

I.e.

mkfs -t btrfs /dev/sdb1
mount /dev/sdb1 /test
snapper -c test create-config /test

attempt to "snap-sync -c test" will fail second time. But

btrfs sub create /test/@
umount /test
mount -o subvol=@ /dev/sdb1 /test
snapper -c test create-config /test
...

will work.

As I told you in the first reply, showing output of "btrfs su li -qu
/path/to/src" would explain your problem much earlier.

Actually if snap-sync used "btrfs send -p" instead of "btrfs send -c" it
would work as well, as then no parent search would be needed (and as I
mentioned in another mail both commands are functionally equivalent).
But this becomes really off-topic on this list. As already suggested,
open issue for snap-sync.
