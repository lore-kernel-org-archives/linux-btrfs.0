Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34796 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbcGKTZM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 15:25:12 -0400
Received: by mail-oi0-f41.google.com with SMTP id s66so162375784oif.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 12:25:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1e650f7d-1f6c-9f74-7f8b-53ce31f81179@gmail.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com> <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com> <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
 <577B2E1D.5070808@gmail.com> <CAJCQCtSW+3eA-amrGgQAds1F8sYPDPgTB9x49RjWnaq=vSePgw@mail.gmail.com>
 <b9647ec5-fe9b-4bfe-97d1-329f47dbf7b0@gmail.com> <CAJCQCtRPhn0i0MkPn1QFr0wqovwQkuEdZ=eWtRZ0QR3O5z5T+w@mail.gmail.com>
 <04874cd6-b043-2743-8e6e-f0ebd61400ed@gmail.com> <CAJCQCtTAMHYBQ+PCrrsMcRW_yhyp8dqmOrLsujEHxy+jq1rOrw@mail.gmail.com>
 <3a554136-ba08-0b9d-7ef7-7a9d6c42f217@gmail.com> <CAJCQCtSuVzykDn+Xk31dSjdgRVOhGxy77dAwuo2aTeAB7XY8hw@mail.gmail.com>
 <0b23ddfd-c1df-4837-ef13-7df027c88508@gmail.com> <CAJCQCtSA9TXO5dEZ-77hoFnc3VAa+81KRoEx9CoJhfStvW3O0A@mail.gmail.com>
 <31d22f36-b97a-c150-3125-576a830e08c1@gmail.com> <CAJCQCtSiEz_rQxkSqiDb=dXTKgRPgBHWrJNVbv27-5_bZvTUEg@mail.gmail.com>
 <1e650f7d-1f6c-9f74-7f8b-53ce31f81179@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 11 Jul 2016 13:25:10 -0600
Message-ID: <CAJCQCtSemaRfrKA07Si=TRzHTe_DOWPn9roaLwz1tv3+L5Y8zg@mail.gmail.com>
Subject: Re: Unable to mount degraded RAID5
To: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 11:17 AM, Tomáš Hrdina <thomas.rkh@gmail.com> wrote:
> sudo btrfs-debug-tree /dev/sdc
> It has 200000 lines. Don't know, what you use for bigger files.
>
>
> sudo btrfs-debug-tree -b 6062434418688 /dev/sdc
> http://sebsauvage.net/paste/?fc156dee1d1deb3b#YpG/TA0H3I313jMuC4pgsdj++TcuDaFwWIBeuuOXfCA=
>
> sudo btrfs-debug-tree -b 6062497202176 /dev/sdc
> http://sebsauvage.net/paste/?86621abec9c239bd#kwTpZ7BZLcLw71yCfr3jHKZT08zsaXK3RgdFo7MFoFc=
>
>
> sudo btrfs-debug-tree -b 6062470332416 /dev/sdc
> http://sebsauvage.net/paste/?4ff40fa0b6b201c9#nFk7pT9MLj2w9egUJlgXdkmCkWyp1vSG0kADfq3J7eA=

None of these have anything useful in them, there's no tree root there.


>
> It got some results, but I don't know, what to look for.
>
>
> sudo btrfs-map-logical -l 7008899547136 /dev/sdc
> parent transid verify failed on 7008807157760 wanted 70175 found 70133
> parent transid verify failed on 7008807157760 wanted 70175 found 70133
> checksum verify failed on 7008807157760 found F192848C wanted 1571393A
> checksum verify failed on 7008807157760 found F192848C wanted 1571393A
> bytenr mismatch, want=7008807157760, have=65536
> mirror 1 logical 7008899547136 physical 735226609664 device /dev/sdb
> mirror 2 logical 7008899547136 physical 3166748524544 device /dev/sdc
>
>
> Also I don't know, what to do with this. How to compute new csum.

Right, that's pretty tricky to do manually.



>
> For me, it would be ok to give up and just start fresh.

OK in that case do that.


-- 
Chris Murphy
