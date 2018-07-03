Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:40386 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752789AbeGCAbq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 20:31:46 -0400
Received: by mail-oi0-f49.google.com with SMTP id w126-v6so401328oie.7
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2018 17:31:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
References: <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com> <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <02ba7ad4-b618-85f0-a99f-c43b25d367de@cn.fujitsu.com> <20180629061001.kkmgvdgqfhz23kll@merlins.org>
 <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com> <20180629064354.kbaepro5ccmm6lkn@merlins.org>
 <20180701232202.vehg7amgyvz3hpxc@merlins.org> <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org> <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
 <20180702140527.wfbq5jenm67fvvjg@merlins.org> <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 2 Jul 2018 18:31:43 -0600
Message-ID: <CAJCQCtQsNnebkZ-vOfw5WABUj2vOChaE2yyeTBDKVyUcPMgcCg@mail.gmail.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Marc MERLIN <marc@merlins.org>, Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 2, 2018 at 8:42 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年07月02日 22:05, Marc MERLIN wrote:
>> On Mon, Jul 02, 2018 at 02:22:20PM +0800, Su Yue wrote:
>>>> Ok, that's 29MB, so it doesn't fit on pastebin:
>>>> http://marc.merlins.org/tmp/dshelf2_inspect.txt
>>>>
>>> Sorry Marc. After offline communication with Qu, both
>>> of us think the filesystem is hard to repair.
>>> The filesystem is too large to debug step by step.
>>> Every time check and debug spent is too expensive.
>>> And it already costs serveral days.
>>>
>>> Sadly, I am afarid that you have to recreate filesystem
>>> and reback up your data. :(
>>>
>>> Sorry again and thanks for you reports and patient.
>>
>> I appreciate your help. Honestly I only wanted to help you find why the
>> tools aren't working. Fixing filesystems by hand (and remotely via Email
>> on top of that), is way too time consuming like you said.
>>
>> Is the btrfs design flawed in a way that repair tools just cannot repair
>> on their own?
>
> For short and for your case, yes, you can consider repair tool just a
> garbage and don't use them at any production system.

So the idea behind journaled file systems is that journal replay
enabled mount time "repair" that's faster than an fsck. Already Btrfs
use cases with big, but not huge, file systems makes btrfs check a
problem. Either running out of memory or it takes too long. So already
it isn't scaling as well as ext4 or XFS in this regard.

So what's the future hold? It seems like the goal is that the problems
must be avoided in the first place rather than to repair them after
the fact.

Are the problem's Marc is running into understood well enough that
there can eventually be a fix, maybe even an on-disk format change,
that prevents such problems from happening in the first place?

Or does it make sense for him to be running with btrfs debug or some
subset of btrfs integrity checking mask to try to catch the problems
in the act of them happening?



-- 
Chris Murphy
