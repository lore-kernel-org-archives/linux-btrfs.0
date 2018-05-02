Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:44195 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbeEBTnM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 May 2018 15:43:12 -0400
Received: by mail-pf0-f170.google.com with SMTP id q22so12650427pff.11
        for <linux-btrfs@vger.kernel.org>; Wed, 02 May 2018 12:43:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20edd001-152b-edbb-548b-dcb2647d828a@gmx.com>
References: <CAMoswehF-GGV-yi_5fFnuvmZWVkeb71F7OcgOgr80r1F-=R_tg@mail.gmail.com>
 <CAA7pwKOGS1MfwiO7AvfGPMP5ddhA6EMF+u3eZ+yE++RYvM=bfg@mail.gmail.com>
 <CAMoswejKgjw+ktxc7iGX9m6F-n5Xq_=kzyLiR4xYUf2s=bYaDA@mail.gmail.com> <20edd001-152b-edbb-548b-dcb2647d828a@gmx.com>
From: Paul Richards <paul.richards@gmail.com>
Date: Wed, 2 May 2018 20:43:11 +0100
Message-ID: <CAMosweg23md=bTDkKYyOX68DrghCa4sDeBGUJ6nJyK2N9mJhFA@mail.gmail.com>
Subject: Re: fs/btrfs/ctree.h:1559 warnings
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Patrik Lundquist <patrik.lundquist@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 29 April 2018 at 02:50, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年04月29日 04:16, Paul Richards wrote:
>> On 28 April 2018 at 20:39, Patrik Lundquist <patrik.lundquist@gmail.com> wrote:
>>> On 28 April 2018 at 20:54, Paul Richards <paul.richards@gmail.com> wrote:
>>>>
>>>> Hi,
>>>> I recently upgraded from Linux 4.4.0 to 4.13.0 (Ubuntu 16.04 stock to
>>>> hwe kernel).
>>>>
>>>> Since then, I've noticed lots of btrfs warnings in dmesg (example at
>>>> the end).  I believe these warnings to be benign, and they relate to
>>>> my partition not being a multiple of 4KiB in size (I confirmed that
>>>> alignment is okay in this instance).
>>>
>>>
>>> Run btrfs rescue fix-device-size <device>.
>>>
>>
>>
>> Excellent, that looks like exactly what I need.  It's a shame my
>> google-fu didn't uncover it before I posted.
>>
>> However, the "fix-device-size" sub-command is not available in
>> btrfs-tools (v4.4) from Ubuntu 16.04.  I guess my original question
>> still stands.  Is this warning safe for me to ignore?
>
> Safe to ignore.
>
> And there is another way to solve it.
>
> Shrink your fs by 4K, and newer kernel will do the round down for you
> and result new device size to be aligned.
>
> Thanks,
> Qu
>


Thanks - this fixed the issue for me (modulo my problem below..).  I
thought I should follow up with exactly what I did for anyone else
looking to fix this.

I used this command to identify which devices were not exact multiples
of 4KiB in size:

% btrfs fi show --raw /storage
Label: none  uuid: c4b33374-9006-47d7-b6f9-2136dc988f9a
Total devices 3 FS bytes used 7027891666944
devid    1 size 8001560055808 used 4691211583488 path /dev/mapper/storage1
devid    3 size 8001560059392 used 4691211583488 path /dev/mapper/storage3
devid    4 size 8001560059392 used 4690104287232 path /dev/mapper/storage4

I used a calculator to determine that devids 3 and 4 were the
offenders (they don't divide by 4006 nicely).


I then ran:
% btrfs fi resize 3:-1K /storage
% btrfs fi resize 4:-1K /storage

Which has resulted in this:
% btrfs fi show --raw /storage
Label: none  uuid: c4b33374-9006-47d7-b6f9-2136dc988f9a
Total devices 3 FS bytes used 7027891666944
devid    1 size 8001560055808 used 4691211583488 path /dev/mapper/storage1
devid    3 size 8001560055808 used 4691211583488 path /dev/mapper/storage3
devid    4 size 8001560055808 used 4690104287232 path /dev/mapper/storage4

PERFECT! :)


The issue I have now is that the filesystem cannot be unmounted.
"umount" reports "target is busy", but I cannot find anything relevant
with "lsof" or "fuser" (this is a very quiet home NAS).  Is this
something related to the resize?



For what it's worth, here are the sizes of the underlying devices
(output somewhat redacted):

% lsblk -b
NAME         MAJ:MIN RM          SIZE RO TYPE  MOUNTPOINT
storage3 253:2    0 8001560059392  0 crypt
storage4 253:1    0 8001560059392  0 crypt
storage1 253:0    0 8001560059392  0 crypt /storage/.snapshots

It looks like all the devices are an odd size.  One of these disks was
added after the others, presumably with a newer kernel that rounded
the btrfs dev size downwards.
