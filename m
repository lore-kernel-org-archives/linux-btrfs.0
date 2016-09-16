Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:37034 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757532AbcIPMOB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 08:14:01 -0400
Received: by mail-it0-f44.google.com with SMTP id 186so14782418itf.0
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Sep 2016 05:14:00 -0700 (PDT)
Subject: Re: Is stability a joke? (wiki updated)
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz> <20160912162747.GF16983@twin.jikos.cz>
 <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
 <CAJCQCtQUS-8F+pOtQ2VA9=j=-TGV=wOfj+3SnnMvY3HMTzd=9g@mail.gmail.com>
 <1ef8e6db-89a1-6639-cd9a-4e81590456c5@gmail.com>
 <CAJCQCtQq08bOpRbZq90wRLUGD62Rnqwx6vjJOv5hvPVwp=jz0w@mail.gmail.com>
 <24d64f38-f036-3ae9-71fd-0c626cfbb52c@gmail.com>
 <1473974581.6678.53.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <10d64c2a-3817-3d49-023b-039c3b3565bb@gmail.com>
Date: Fri, 16 Sep 2016 08:13:57 -0400
MIME-Version: 1.0
In-Reply-To: <1473974581.6678.53.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-15 17:23, Christoph Anton Mitterer wrote:
> On Thu, 2016-09-15 at 14:20 -0400, Austin S. Hemmelgarn wrote:
>> 3. Fsck should be needed only for un-mountable filesystems.  Ideally,
>> we
>> should be handling things like Windows does.  Preform slightly
>> better
>> checking when reading data, and if we see an error, flag the
>> filesystem
>> for expensive repair on the next mount.
>
> That philosophy also has some drawbacks:
> - The user doesn't directly that anything went wrong. Thus errors may
> even continue to accumulate and getting much worse if the fs would have
> immediately gone ro and giving the user the chance to manually
> intervene (possibly then with help from upstream).
Except that the fsck implementation in windows for NTFS actually fixes 
things that are broken.  MS policy is 'if chkdsk can't fix it, you need 
to just reinstall and restore from backups'.  They don't beat around the 
bush trying to figure out what exactly went wrong, because 99% of the 
time on Windows a corrupted filesystem means broken hardware or a virus. 
  BTRFS obviously isn't to that point yet, but it has the potential if 
we were to start focusing on fixing stuff that's broken instead of 
working on shiny new features that will inevitably make everything else 
harder to debug, we could probably get there faster than most other 
Linux filesystems.
>
> - Any smart auto-magical™ repair may also just fail (and make things
> worse, as the current --repair e.g. may). Not performing such auto-
> repair, gives the user at least the possible chance to make a bitwise
> copy of the whole fs, before trying any rescue operations.
> This wouldn't be the case, if the user never noticed that something
> happen, and the fs tries to repair things right at mounting.
People talk about it being dangerous, but I have yet to see it break a 
filesystem that wasn't already in a state that in XFS or ext4 would be 
considered broken beyond repair.  For pretty much all of the common 
cases (orphaned inodes, dangling hardlinks, isize mismatches, etc), it 
does fix things correctly.  Most of that stuff could be optionally 
checked at mount and fixed without causing issues, but it's not 
something that should be done all the time since it's expensive, hence 
me suggesting checking such things dynamically on-access and flagging 
them for cleanup next mount.
>
> So I think any such auto-repair should be used with extreme caution and
> only in those cases where one is absolutely a 100% sure that the action
> will help and just do good.
In general, I agree with this, and I'd say it should be opt-in, not 
mandatory.  I'm not talking about doing things that are all that risky 
though, but things which btrfs check can handle safely.
