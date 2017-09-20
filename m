Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:52826 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbdITXhq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 19:37:46 -0400
Received: by mail-io0-f180.google.com with SMTP id i197so7252127ioe.9
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 16:37:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a8df8ca2-8bc4-994a-2de0-fda8e9fc3985@gmail.com>
References: <CAH=dxU7t=p8MVh1y2Tv7wPrP=1ntYcHCy7W6aBQGRtMp_gaaRA@mail.gmail.com>
 <1fa167f4-a8ba-84c7-8e06-9c7e9f3d30e7@gmail.com> <CAH=dxU4yTdKQwZX3L-oOMs2ZYiR82m1-F0GhbSU4SV_K2jrBGA@mail.gmail.com>
 <a8df8ca2-8bc4-994a-2de0-fda8e9fc3985@gmail.com>
From: Dave <davestechshop@gmail.com>
Date: Wed, 20 Sep 2017 19:37:24 -0400
Message-ID: <CAH=dxU6VW_T2P_gnNhPTywWZKyqCboy8m5A1CUNwc78OemGnXg@mail.gmail.com>
Subject: Re: ERROR: parent determination failed (btrfs send-receive)
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 19, 2017 at 3:37 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 18.09.2017 09:10, Dave пишет:
>> I use snap-sync to create and send snapshots.
>>
>> GitHub - wesbarnett/snap-sync: Use snapper snapshots to backup to external drive
>> https://github.com/wesbarnett/snap-sync
>>
>
> Are you trying to backup top-level subvolume?

No. I never mount the top-level subvolume.

>  I just reproduced this > behavior with this tool. The problem is, snapshots of top-level
> subvolume do not have parent UUID (I am not even sure if UUID exists at
> all TBH). If you mount any other subvolume, it will work.

Well, that's not exactly my issue but it still helps me gain
additional understanding.  It may help me reproduce my original
problem too. Thank you.

>
>
> As I told you in the first reply, showing output of "btrfs su li -qu
> /path/to/src" would explain your problem much earlier.
>
> Actually if snap-sync used "btrfs send -p" instead of "btrfs send -c" it
> would work as well, as then no parent search would be needed (and as I
> mentioned in another mail both commands are functionally equivalent).
> But this becomes really off-topic on this list. As already suggested,
> open issue for snap-sync.

Thank you for this also. I will simply edit my current copy of the
snap-sync script to use "-p" now. That's a simple change I am
implement immediately.
