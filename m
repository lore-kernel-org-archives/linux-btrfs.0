Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:37189 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbcIMLf1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 07:35:27 -0400
Received: by mail-it0-f54.google.com with SMTP id 186so36854708itf.0
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Sep 2016 04:35:27 -0700 (PDT)
Subject: Re: Is stability a joke? (wiki updated)
To: Chris Murphy <lists@colorremedies.com>
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz> <20160912162747.GF16983@twin.jikos.cz>
 <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
 <CAJCQCtQUS-8F+pOtQ2VA9=j=-TGV=wOfj+3SnnMvY3HMTzd=9g@mail.gmail.com>
Cc: David Sterba <dsterba@suse.cz>, Waxhead <waxhead@online.no>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <1ef8e6db-89a1-6639-cd9a-4e81590456c5@gmail.com>
Date: Tue, 13 Sep 2016 07:35:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQUS-8F+pOtQ2VA9=j=-TGV=wOfj+3SnnMvY3HMTzd=9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-12 16:08, Chris Murphy wrote:
> On Mon, Sep 12, 2016 at 10:56 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>>
>> Things listed as TBD status:
>> 1. Seeding: Seems to work fine the couple of times I've tested it, however
>> I've only done very light testing, and the whole feature is pretty much
>> undocumented.
>
> Mostly OK.
>
> Odd behaviors:
> - mount seed (ro), add device, remount mountpoint: this just changed
> the mounted fs volume UUID
> - if two sprouts for a seed exist, ambiguous which is remounted rw,
> you'd have to check
> - remount should probably be disallowed in this case somehow; require
> explicit mount of the sprout
>
> btrfs fi usage crash when multiple device volume contains seed device
> https://bugzilla.kernel.org/show_bug.cgi?id=115851
Yeah, like I said, I've only done very light testing.  I kind of lost 
interest in seeding when overlayfs went mainline, as it offers pretty 
much everything I care about that seeding does, and it's filesystem 
agnostic.
>
>
>> 2. Device Replace: Works perfectly as long as the filesystem itself is not
>> corrupted, all the component devices are working, and the FS isn't using any
>> raid56 profiles.  Works fine if only the device being replaced is failing.
>> I've not done much testing WRT replacement when multiple devices are
>> suspect, but what I've done seems to suggest that it might be possible to
>> make it work, but it doesn't currently.  On raid56 it sometimes works fine,
>> sometimes corrupts data, and sometimes takes an insanely long time to
>> complete (putting data at risk from subsequent failures while the replace is
>> running).
>> 3. Balance: Works perfectly as long as the filesystem is not corrupted and
>> nothing throws any read or write errors.  IOW, only run this on a generally
>> healthy filesystem.  Similar caveats to those for replace with raid56 apply
>> here too.
>> 4. File Range Cloning and Out-of-band Dedupe: Similarly, work fine if the FS
>> is healthy.
>
> Concur.
>
>
> Missing from the matrix:
>
> - default file system for distros recommendation
> e.g. between enospc and btrfsck status, I'd say in general this is not
> currently recommended by upstream (short of having a Btrfs kernel
> developer on staff)
I'd add the whole UUID issue to that too.
>
> - enospc status
> e.g. there's new stuff in 4.8 that probably still needs to shake out,
> and Jeff's found some metadata accounting problem resulting in enospc
> where there's tons of unallocated space available.
> e.g. I have empty block groups, and they are not being deallocated,
> they just stick around, and this is with 4.7 and 4.8 kernels; so
> whatever was at one time automatically removing totally empty bg's
> isn't happening anymore.
FWIW, that's still working on my systems.
>
> - btrfsck status
> e.g. btrfs-progs 4.7.2 still warns against using --repair, and lists
> it under dangerous options also;  while that's true, Btrfs can't be
> considered stable or recommended by default
> e.g. There's still way too many separate repair tools for Btrfs.
> Depending on how you count there's at least 4, and more realistically
> 8 ways, scattered across multiple commands. This excludes btrfs
> check's -E, -r, and -s flags. And it ignores sequence in the success
> rate. The permutations are just excessive. It's definitely not easy to
> know how to fix a Btrfs volume should things go wrong.
I assume you're counting balance and scrub in that, plus check gives 3, 
what are you considering the 4th?

In the case of just balance, scrub, and check, the differentiation there 
makes more sense IMHO than combining them, check only runs on offline 
filesystems (and as much as we want online fsck, I doubt that that will 
happen any time soon), while scrub and balance operate on online 
filesystems and do two semantically different things.

