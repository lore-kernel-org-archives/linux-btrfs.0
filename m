Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35098 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbcEQVH6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 17:07:58 -0400
Received: by mail-wm0-f65.google.com with SMTP id g17so1286861wme.2
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 14:07:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSJgGXpvFAqOZx5VsAMkcxjpUTexWab4o-983uOYTLfEA@mail.gmail.com>
References: <CABt16=EDFKFj4duaWJ0qCS_SO9TE2jn8UMCx5e_u+X+M328yeA@mail.gmail.com>
	<CAJCQCtSJgGXpvFAqOZx5VsAMkcxjpUTexWab4o-983uOYTLfEA@mail.gmail.com>
Date: Wed, 18 May 2016 00:07:56 +0300
Message-ID: <CAJVJNe5EQkWB+aw8NVags+-af5bsF-P9xS3e+Yj+Tj=qOjk2Vw@mail.gmail.com>
Subject: Re: Corrupted system due to imbalanced metadata chunks
From: Goni Zahavy <goni1993@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Peter Kese <peter.kese@viidea.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/17/16, Chris Murphy <lists@colorremedies.com> wrote:
> On Tue, May 17, 2016 at 9:45 AM, Peter Kese <peter.kese@viidea.com> wrote:
>> I've been using btrfs on my main system for a few months. I know btrfs
>> is a little bit beta, but I thought not using any fancy features like
>> quotas, snapshotting, raid, etc. would keep me on the safe side.
>>
>> Then I tried a software upgrade (Ubuntu 15.10 -> 16.04) and it turned
>> out that while there was more than 100 GB (45%) of free disk space,
>> the upgrade process broke down somewhere in the middle reporting IO
>> errors and lack of free disk space.
>
> Yeah it's a weak area still that only completely unused data chunks
> become unallocated free space again, from which metadata chunks can be
> allocated. I think general consumption of Btrfs is difficult until
> there's better behavior; maybe a trigger that can happen before such
> enospc that causes the equivalent of filtered balance, e.g. -dusage=5,
> which should be quite fast even on HDD, and free up a lot of space or
> at least enough to allocate a metadata chunk in order to complete
> something like an OS upgrade.
>
>
>
>> As I have learned later on, my problem was lack of available metadata
>> blocks and a couple of tries at btrfs-balance remedied the space
>> problem, but I nevertheless ended up with a broken Ubuntu distribution
>> (there were broken packages and apt-get/dpkg hacking failed to fix the
>> problem).
>>
>> So there wasn't any major data loss (apart from some .deb packages
>> missing some files, my personal data is intact). But I'd still
>> consider this a major loss, because I'll end up having to reinstall
>> the whole system.
>
> The criticism is valid. But there is more than one valid criticism.
> The non-atomic upgrade process is also a problem that needs
> improvement for a very long time now.
>
> Ironically a snapshot would probably have helped because then worst
> case scenario  you could 'btrfs dev add' some small device like even a
> 2G USB stick to get out of the no space situation, and then delete the
> subvolume(s) containing the failed upgrade, then later delete the
> unneeded USB stick. So Btrfs can help give OS upgrades a more modern
> atomic way of doing updates and upgrades, almost for free, so that a
> failure can be rolled back to a known good point.
>
> But there are other reasons why updates can fail, other than running
> out of space, and that's why they need to be better designed to be
> fail safe.
>
>
>
>
>>
>> Now here's what I think:
>>  1) I may have been a bit unfortunate to experience this particular
>> issue but there's a large audience of people who might get bitten as
>> well,
>>  2) I find it hard to blame it on Ubuntu's upgrade process, as it does
>> check for free space availability before starting the upgrade,
>>  3) A file system should not refuse to store files (during system
>> upgrade or any other time), when there is 100 GB of free disk space
>> available,
>>  4) Not anywhere in any btrfs documentation (not even in btrfs
>> Gotchas) did I read any bold text saying *If installing btrfs, you
>> should always keep an eye on free space for metadata and perform
>> regular balances or otherwise you may corrupt your system.*
>
> 1 Definitely.
> 2 Dual blame.
> 3 It's technically not free disk space, it's unused but allocated
> space, and it's allocated for a specific purpose (data chunk or
> metadata chunk) and right now there's no automatic migration (balance)
> of extents in order to repurpose that space as needed. So, yeah Btrfs
> needs to get better in this area for sure but it's a difficult problem
> or it'd already be solved by now.
> 4 Technically the file system itself is not corrupt, it's just that
> upon enospc the updater face plants and I guess has some recovery
> problems identifying the system's in-between state and ability to fix
> it. I agree with the part that the user shouldn't need to know about
> keeping an eye on data vs metadata balancing act for a stable and
> production recommended fs.
>
> But at least as much we need better behavior in updaters. Quite a lot
> of them it seems make excessive use of fsync for probably no longer
> very good reasons.
>
> --
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Guys, just remember that this crappy-installer behavior works
"as-expected" on every other filesystem.
I think we need to treat this as a trigger to unwanted/unexpected
behavior on btrfs's part, especially in this "dead-simple" setup, in
order  to gain a bug/behavior fix in the near future.
In my opinion, we simply cannot "blame" the user's actions or some
installer's code in the current state of btrfs especially in the
"considered stable enough" feature sets.

Goni Zahavy
