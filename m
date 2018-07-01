Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36256 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030402AbeGASBj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2018 14:01:39 -0400
Received: by mail-lf0-f52.google.com with SMTP id n24-v6so10288399lfh.3
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jul 2018 11:01:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <23369eaa-d1cd-d8fd-4553-5c072a5eca36@gmx.com>
References: <CAHwd=GkFPxS=nOviDs41+e-JNXX1QWLctP=hb-rO=vCJiyuFDA@mail.gmail.com>
 <23369eaa-d1cd-d8fd-4553-5c072a5eca36@gmx.com>
From: Lewis Diamond <me@lewisdiamond.com>
Date: Sun, 1 Jul 2018 14:01:36 -0400
Message-ID: <CAHwd=GmtzjzY5xkXoueKZy2ORn0zLG+fLtLYsUm5fD7GEAGJcQ@mail.gmail.com>
Subject: Re: btrfs check --readonly crash
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes, you are right, after running `btrfs check --clear-space-cache v1
<dev>` a `btrfs check --readonly` passes without error. Thanks!

I'm absolutely not familiar with the btrfs code, but would it be
possible to have some error handling in `btrfs check` that picks up
this situation instead of crashing?

On Sat, Jun 30, 2018 at 10:07 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年07月01日 09:59, Lewis Diamond wrote:
>> Hi,
>> I've been told to report this issue to this mailing list.
>>
>> sudo btrfs check --readonly /dev/sdc
>> Checking filesystem on /dev/sdc
>> UUID: 2630aec8-8399-4bd8-9397-8c04953a35d5
>> checking extents
>> checking free space cache
>> there is no free space entry for 1596152365056-1596152381440
>> there is no free space entry for 1596152365056-1597220323328
>> cache appears valid but isn't 1596146581504
>> there is no free space entry for 1613348585472-1613348618240
>> there is no free space entry for 1613348585472-1614400192512
>> cache appears valid but isn't 1613326450688
>> block group 1645538705408 has wrong amount of free space, free space
>> cache has 58212352 block group has 58277888
>> failed to load free space cache for block group 1645538705408
>> block group 1683119669248 has wrong amount of free space, free space
>> cache has 52838400 block group has 52953088
>> failed to load free space cache for block group 1683119669248
>> btrfs: unable to add free space :-17
>
> Your free space cache is corrupted.
> And if not handled well, it could (may have already) damaged your fs
> further.
>
> You could try "btrfs check --clear-space-cache v1 <dev>" to remove the
> free space cache completely and re-try "btrfs check --readonly" to see
> if it works.
>
> Thanks,
> Qu
>
>> free-space-cache.c:843: btrfs_add_free_space: BUG_ON `ret == -EEXIST`
>> triggered, value 1
>> btrfs(+0x37337)[0x556024d5d337]
>> btrfs(btrfs_add_free_space+0x11d)[0x556024d5da2d]
>> btrfs(load_free_space_cache+0xde9)[0x556024d5e889]
>> btrfs(cmd_check+0x15fe)[0x556024d8b9ee]
>> btrfs(main+0x88)[0x556024d38768]
>> /usr/lib/libc.so.6(__libc_start_main+0xeb)[0x7f9382a9506b]
>> btrfs(_start+0x2a)[0x556024d3888a]
>> Aborted
>>
>>
>> This happened on a USB HDD duo in raid 1 which had btrfs issues
>> (probably due to a bad controller). One of the hdd was subsequently
>> dropped by a 2 year old (causing subsequent checks to crash).
>>
>> -Lewis
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
