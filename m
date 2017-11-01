Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:53732 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750925AbdKAGwU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 02:52:20 -0400
Received: by mail-wm0-f48.google.com with SMTP id r196so2987603wmf.2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 23:52:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f17a1de9-8340-dae3-3b29-0e04440ca2a3@rqc.ru>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
 <f17a1de9-8340-dae3-3b29-0e04440ca2a3@rqc.ru>
From: Dave <davestechshop@gmail.com>
Date: Wed, 1 Nov 2017 02:51:58 -0400
Message-ID: <CAH=dxU7APYANHn3PjqepY9dr9F3RRhzE1OSgtar9tN-74haS9g@mail.gmail.com>
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Marat Khalili <mkh@rqc.ru>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 1, 2017 at 2:19 AM, Marat Khalili <mkh@rqc.ru> wrote:

> You seem to have two tasks: (1) same-volume snapshots (I would not call them
> backups) and (2) updating some backup volume (preferably on a different
> box). By solving them separately you can avoid some complexity...

Yes, it appears that is a very good strategy -- solve the concerns
separately. Make the live volume performant and the backup volume
historical.

>
>> To reconcile those conflicting goals, the only idea I have come up
>> with so far is to use btrfs send-receive to perform incremental
>> backups
>
> As already said by Romain Mamedov, rsync is viable alternative to
> send-receive with much less hassle. According to some reports it can even be
> faster.

Thanks for confirming. I must have missed those reports. I had never
considered this idea until now -- but I like it.

Are there any blogs or wikis where people have done something similar
to what we are discussing here?

>
>> Given the hourly snapshots, incremental backups are the only practical
>> option. They take mere moments. Full backups could take an hour or
>> more, which won't work with hourly backups.
>
> I don't see much sense in re-doing full backups to the same physical device.
> If you care about backup integrity, it is probably more important to invest
> in backups verification. (OTOH, while you didn't reveal data size, if full
> backup takes just an hour on your system then why not?)

I was saying that a full backup could take an hour or more. That means
full backups are not compatible with an hourly backup schedule. And it
is certainly not a potential solution to making the system perform
better because the system will be spending all its time running
backups -- it would be never ending. With hourly backups, they should
complete in just a few moments, which is the case with incremental
backups. (It sounds like this will be the case with rsync as well.)
>
>> We will delete most snapshots on the live volume, but retain many (or
>> all) snapshots on the backup block device. Is that a good strategy,
>> given my goals?
>
> Depending on the way you use it, retaining even a dozen snapshots on a live
> volume might hurt performance (for high-performance databases) or be
> completely transparent (for user folders). You may want to experiment with
> this number.

We do experience severe performance problems now, especially with
Firefox. Part of my experiment is to reduce the number of snapshots on
the live volumes, hence this question.

>
> In any case I'd not recommend retaining ALL snapshots on backup device, even
> if you have infinite space. Such filesystem would be as dangerous as the
> demon core, only good for adding more snapshots (not even deleting them),
> and any little mistake will blow everything up. Keep a few dozen, hundred at
> most.

The intention -- if we were to keep all snapshots on a backup device
-- would be to never ever try to delete them. However, with the
suggestion to separate the concerns and use rsync, we could also
easily run the Snapper timeline cleanup on the backup volume, thereby
limiting the retained snapshots to some reasonable number.

> Unlike other backup systems, you can fairly easily remove snapshots in the
> middle of sequence, use this opportunity. My thinout rule is: remove
> snapshot if resulting gap will be less than some fraction (e.g. 1/4) of its
> age. One day I'll publish portable solution on github.

Thanks. I hope you do find time to publish it. (And what do you mean
by portable?) For now, Snapper has a cleanup algorithm that we can
use. At least one of the tools listed here has a thinout algorithm
too: https://btrfs.wiki.kernel.org/index.php/Incremental_Backup

>> Given this minimal retention of snapshots on the live volume, should I
>> defrag it (assuming there is at least 50% free space available on the
>> device)? (BTW, is defrag OK on an NVMe drive? or an SSD?)
>>
>> In the above procedure, would I perform that defrag before or after
>> taking the snapshot? Or should I use autodefrag?
>
> I ended up using autodefrag, didn't try manual defragmentation. I don't use
> SSDs as backup volumes.

I don't use SSD's as backup volumes either. I was asking about the live volume.
>
>> Should I consider a dedup tool like one of these?
>
> Certainly NOT for snapshot-based backups: it is already deduplicated almost
> as much as possible, dedup tools can only make it *less* deduplicated.

The question is whether to use a dedup tool on the live volume which
has a few snapshots. Even with the new strategy (based on rsync), the
live volume may sometimes have two snapshots (pre- and post- pacman
upgrades).

I still wish to know, in that case, about using both a dedup tool and
defragmenting the btrfs filesystem.

Also still wondering about these options: no-holes, skinny metadata,
or extended inode refs?

This is a very helpful discussion. Thank you.
