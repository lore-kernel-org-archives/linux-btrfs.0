Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:36284 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbeBHEcq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 23:32:46 -0500
Received: by mail-lf0-f41.google.com with SMTP id t79so4537614lfe.3
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Feb 2018 20:32:45 -0800 (PST)
Subject: Re: IO Error (.snapshots is not a btrfs subvolume)
To: Chris Murphy <lists@colorremedies.com>,
        Nick Gilmour <nickeforos@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAH-droxO-K9RM9uCLie=6bg3cgC5uqo_wcscc0BmB9HyKM5gQQ@mail.gmail.com>
 <CAJCQCtTqJQkLmsowxun7YuRsy4MkN9A4iO5LVwp3tO_6G=LqNQ@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <ea8e5fd1-25f4-0f26-14eb-8aeb9de2fb86@gmail.com>
Date: Thu, 8 Feb 2018 07:32:42 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTqJQkLmsowxun7YuRsy4MkN9A4iO5LVwp3tO_6G=LqNQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

08.02.2018 06:03, Chris Murphy пишет:
> On Wed, Feb 7, 2018 at 6:26 PM, Nick Gilmour <nickeforos@gmail.com> wrote:
>> Hi all,
>>
>> I have successfully restored a snapshot of root but now when I try to

How exactly was it done?

>> make a new snapshot I get this error:
>> IO Error (.snapshots is not a btrfs subvolume).
>> My snapshots were within @ which I renamed to @_old.
>> What can I do now? How can I move the snapshots from @_old/ into @ and
>> be able to make snapshots again?
>>
>> This is an excerpt of my subvolumes list:
>>
>> # btrfs subvolume list /
>> ID 257 gen 175397 top level 5 path @_old
>> ID 258 gen 175392 top level 5 path @pkg
>> ID 260 gen 175447 top level 5 path @tmp
>> ID 262 gen 19 top level 257 path @_old/var/lib/machines
>> ID 268 gen 175441 top level 5 path @test
>> ID 291 gen 175394 top level 257 path @_old/.snapshots
>> ID 292 gen 1705 top level 291 path @_old/.snapshots/1/snapshot
>> ...
>>
>> ID 3538 gen 175398 top level 291 path @_old/.snapshots/1594/snapshot
>> ID 3540 gen 175447 top level 5 path @
>>
> 
> 
> This is a snapper behavior. It creates .snapshots as a subvolume and
> then puts snapshots into that subvolume. If you snapshot a subvolume
> that contains another subvolume, the nested subvolume is not snapshot,
> instead a plain directory placeholder is created instead. So your
> restored snapshot contains a .snapshot directory rather than a
> .snapshot subvolume. Possibly if you delete the directory and create a
> new subvolume .snapshot, the problem will be fixed.
> 

No, you should create subvolume @/.snapshots and mount it as /.snapshots
(and have it in /etc/fstab). Snapshots should always be available in
running system under fixed path and this only possible when it is
mounted, otherwise after rollback /.snapshots will be lost just like it
happened now.

Exact subvolume name probably not matters that much, but better stick
with what installer does by default. It may matter for grub2 snapshots
handling.

Also openSUSE expects that actual root is subvolume under /.snapshots
which is valid snapper snapshot (i.e. it has valid metadata). Again, not
having this may confuse snapper.

It may be possible to move @_old/.snapshots into @/.snapshots, although
this breaks parent-child relationships those old snapshots cannot be
cleaned up without removing old root completely.

> I can't tell you how this will confuse snapper though, or how to
> unconfuse it. It pretty much expects to be in control of all
> snapshots, creation, deletion, and rollbacks. So if you do it manually
> for whatever reason, I think it can confuse snapper.
> 
> 

There was blog post recently outlining how to restore openSUSE root. You
may want to search opensuse or opensuse-factory mailing list. Ah found:

https://rootco.de/2018-01-19-opensuse-btrfs-subvolumes/
