Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:39867 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751087AbdKTCYk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Nov 2017 21:24:40 -0500
Received: by mail-ot0-f196.google.com with SMTP id v15so6470850ote.6
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Nov 2017 18:24:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 19 Nov 2017 19:24:38 -0700
Message-ID: <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 19, 2017 at 7:13 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年11月19日 14:17, Chris Murphy wrote:
>> fstrim should trim free space, but it only trims unallocated. This is
>> with kernel 4.14.0 and the entire 4.13 series. I'm pretty sure it
>> behaved this way with 4.12 also.
>
> Tested with 4.14-rc7, can't reproduce it.

$ sudo btrfs fi us /
Overall:
    Device size:          70.00GiB
    Device allocated:          31.03GiB
    Device unallocated:          38.97GiB
    Device missing:             0.00B
    Used:              22.12GiB
    Free (estimated):          47.62GiB    (min: 47.62GiB)
...snip...

$ sudo fstrim -v /
/: 39 GiB (41841328128 bytes) trimmed

Then I run btrfs-debug -b / and find the least used block group, at 8% usage;

block group offset   174202028032 len 1073741824 used   89206784
chunk_objectid 256 flags 1 usage 0.08

And balance that block group:

$ sudo btrfs balance start -dvrange=174202028032..174202028033 -dlimit=1 /
Done, had to relocate 1 out of 32 chunks

And trim again:

/: 39 GiB (41841328128 bytes) trimmed


> Any special mount options or setup?
> (BTW, I also tried space_cache=v2 and default v1, no obvious difference)


/dev/nvme0n1p8 on / type btrfs
(rw,relatime,seclabel,ssd,space_cache,subvolid=333,subvol=/root27)


Would a strace of fstrim help?


-- 
Chris Murphy
