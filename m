Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:35120 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbcCJRE0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 12:04:26 -0500
Received: by mail-qg0-f52.google.com with SMTP id y89so75610888qge.2
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 09:04:25 -0800 (PST)
Subject: Re: btrfs and containers
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
 <CAJCQCtSPEY1c-=GTJwH3-qRNxGCEsd0bVu9A_srdFt03bX7BcQ@mail.gmail.com>
 <20160308195857.GB26981@localhost.localdomain>
 <CAJCQCtSp5B=nnpCs3zaCsMK+8qLNLzYQAqka5P1X+a+R4RzGOQ@mail.gmail.com>
 <56E013E8.9080401@gmail.com> <pan$389e0$596a4ce9$6594c4ff$3be23a55@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56E1A901.6050207@gmail.com>
Date: Thu, 10 Mar 2016 12:04:01 -0500
MIME-Version: 1.0
In-Reply-To: <pan$389e0$596a4ce9$6594c4ff$3be23a55@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-09 21:55, Duncan wrote:
> Austin S. Hemmelgarn posted on Wed, 09 Mar 2016 07:15:36 -0500 as
> excerpted:
>
>> On 2016-03-08 16:28, Chris Murphy wrote:
>
>>> Yes, it's a bit peculiar I can create subvolumes and snapshot them, but
>>> can't 'btrfs sub list/show'
>>>
>>> It's an open question why the user needs a subvolume, but I'm not
>>> thinking of a human user necessarily but rather some service, maybe
>>> it's httpd. Or maybe with the xdg-app stuff the Gnome folks are working
>>> on it makes sense to encapsulate applications and their updates in
>>> their own subvolume. *shrug*  I'm open to the idea that the use case
>>> needs to be more compelling and detailed in order to get the
>>> implementation right.
>>>
>> It's probably worth tossing out there that I use them on a regular basis
>> as a normal user (not root or some service) for:
>> 1. Local copies of VCS repositories.
>> 2. Build directories.
>> 3. Staging areas for a variety of things.
>> 4. Specifically isolating certain parts of my home directory from
>> backups.
>>
>> 1-3 are mostly because of the fact that deleting a subvolume is insanely
>> fast compared to recursive deletion of a directory, although 4 is
>> somewhat significant for those as well.
>
> For #2 and possibly #3, depending on what's being staged and why, tmpfs
> works well, and deleting should be even faster (AFAIK, subvolume deletion
> returns immediately but the work continues in the background, so if
> you're running other IO-bound jobs they'll still be affected even tho the
> subvolume deletion command has returned... if it's all in memory as is
> tmpfs, that problem's eliminated too), tho of course you need enough
> memory so that tmpfs doesn't trigger swap-thrashing.
Yeah, most of the time I use subvolumes for item 2 or 3 it's either 
dealing with stuff that I specifically want persistent across reboots 
(for example, the build directory I keep in /usr/src for the kernel, or 
staging directories for audio recordings), or things that are big enough 
I really want to avoid the memory consumption from working on tmpfs (as 
of right now, the only package I have installed on any of my systems 
that fits this is LLVM/clang, I used to do this for some other software 
like LibreOffice, webkit-gtk, and icedtea as well though).
>
> But #1 and #4 of course don't work as well on tmpfs as you'll likely want
> them around longer, and all four cases definitely make use of the the
> fact that nested subvolumes wall off snapshotting and thus btrfs send,
> for backup purposes.  And of course if you're on a limited-memory machine
> and thus can't easily use tmpfs for building and other staging, and don't
> need to care about the ongoing background IO, using subvolumes for #2 and
> 3 remains useful, as well.
>
>> In general I can see them being useful for any number of things from a
>> service perspective, although I feel that snapshots are likely more
>> useful there (the ability to atomically save the state of a set of files
>> is extremely useful for a lot of things).
>
> I consider the current situation somewhat of a security (DoS) issue,
> since users (or runaway scripts or malware) can create unlimited
> subvolumes as an ordinary user, with that user then not being able to
> delete them, requiring admin intervention to do so.  Of course as long as
> it's a single-human-user with an admin-rights alter-ego login, it's not
> /that/ much of a security issue, but I could see it being one for human
> users who do not have that admin-rights alter-ego login.  So were I to be
> running in such a situation, I'd probably use the mount option to let the
> users delete their own subvolumes, unless of course that opens up other
> security issues I'm not aware of.
>
> IMO before btrfs can really be considered stable, this possible DoS needs
> resolved by making the list/delete set the exact same as the create set,
> either by giving users some way to deal with (only) their own subvolumes
> just as they can their own directories, or by reserving subvolume
> creation to superuser, because that's what's needed for listing and
> deletion.  Because if not, I fear someone's going to take advantage of it
> in some way, perhaps, as with many DoS vulns, using it to deny critical
> resources as a way to simplify some other more critical attack, and it'll
> be in the headlines as an attack that worked and a zero-day that still
> works.
The part that makes this tricky is that the list ioctl can be considered 
a potential information leak (as evidenced by the issue that started 
this thread), so IMHO what really needs to happen is for the mount 
option to be 'user_subvolume_ops', and control all three operations (or 
better yet, do something with ACL's in the btrfs xattr namespace to 
control it on a per-subvolume basis).

