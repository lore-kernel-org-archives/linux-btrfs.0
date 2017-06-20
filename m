Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34003 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751019AbdFTQJG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 12:09:06 -0400
Received: by mail-pg0-f68.google.com with SMTP id j186so22339177pge.1
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jun 2017 09:09:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170620151526.GC7140@carfax.org.uk>
References: <CADtmLM_wcKDix3RJz3m0_=YiZ=kFtvvT8p359PNq30BusPdHFA@mail.gmail.com>
 <20170620151526.GC7140@carfax.org.uk>
From: Alexander Peganz <a.peganz@gmail.com>
Date: Tue, 20 Jun 2017 18:08:45 +0200
Message-ID: <CADtmLM9U9tBtnK3TnM8TzVZGWAASqk=g0OZVP00C2hVQEy03Pg@mail.gmail.com>
Subject: Re: does using different uid/gid/forceuid/... mount options for
 different subvolumes work / does fuse.bindfs play nice with btrfs?
To: Hugo Mills <hugo@carfax.org.uk>, Alexander Peganz <a.peganz@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, thanks for the clarification. Bindfs will continue to live on my
machines then!

Regards,
Alexander

On 20 June 2017 at 17:15, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Jun 20, 2017 at 04:35:48PM +0200, Alexander Peganz wrote:
>> Hello everyone,
>>
>> I intend to provide different "views" of the data stored on btrfs subvolumes.
>> e.g. mount a subvolume in location A rw; and ro in location B while
>> also overwriting uids, gids, and permissions.
>> In the past I have been using fuse.bindfs for this. Now I'm trying to
>> find out if there is a 'native' way to do this in btrfs, and if it
>> works by design or by accident (I wouldn't want to rely on something
>> that might go away in a newer kernel version).
>>
>> So here goes:
>> Do different uid/gid/... mount options for different subvolumes work?
>
>    No. uid= and gid= mount options don't work at all for btrfs (or on
> most other filesystems with their own concept of file ownership). You
> can't arbitrarily change the ownership of files like this -- except
> for filesystems like FAT, which don't have the concept at all.
>
>> Or does the first mounted subvolume "win"?
>
>    See above. The options don't do anything.
>
>> Can a subvolume be mounted more than once (I guess not, but btrfs
>> might surprise me)?
>
>    Yes.
>
>> Is there some completely different way I don't know about to do this
>> in btrfs that might not even have anything to do with mount options?
>
>    If you want to do it, it'll _have_ to be done without mount
> options, because the options you're proposing to use don't work.
>
>    As far as I know, there's no mount option for this in btrfs (or any
> other POSIX filesystem), and there are no plans to implement such a
> feature.
>
>> If there is no magical btrfs way, does fuse.bindfs play nice with
>> btrfs or should I be worried?
>
>    We haven't had any complaints about it that I'm aware of.
>
>    Hugo.
>
> --
> Hugo Mills             | I believe that it's closely correlated with the
> hugo@... carfax.org.uk | aeroswine coefficient
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |                                       Adrian Bridgett
