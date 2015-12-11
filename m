Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33993 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbbLKXGQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Dec 2015 18:06:16 -0500
Received: by ioir85 with SMTP id r85so142538220ioi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Dec 2015 15:06:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1449872498.31388.74.camel@fo>
References: <20151204120529.37E47D5A28@emkei.cz>
	<20151204130758.GR8775@carfax.org.uk>
	<1449286104.18841.14.camel@scientia.net>
	<pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
	<1449366680.3183.37.camel@scientia.net>
	<56644785.4090702@gmx.com>
	<1449639588.7835.2.camel@scientia.net>
	<5668A1CB.1020007@anonym.com>
	<CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
	<1449872498.31388.74.camel@fo>
Date: Fri, 11 Dec 2015 16:06:15 -0700
Message-ID: <CAJCQCtSXkXs0jQ=zaP6FJvRZS0yvz5CrjP8a06K0+htG5H8LTg@mail.gmail.com>
Subject: Re: attacking btrfs filesystems via UUID collisions?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 11, 2015 at 3:21 PM, Christoph Anton Mitterer <fo@fo> wrote:
> On Thu, 2015-12-10 at 12:42 -0700, Chris Murphy wrote:
>> That isn't what I'm suggesting. In the multiple device volume case
>> where there are two exact (same UUID, same devid, same generation)
>> instances of one of the block devices, Btrfs could randomly choose
>> either one if it's an RO mount.
> No, for the same reasons as just stated in my mail few minutes ago.
> An attacker could probably find out the UUID/devid/generation... it
> would probably possible for him to craft a device with exactly those
> and try to use it.

For anything but a new and empty Btrfs volume, this hypothetical
attack would be a ton easier to do on LVM and mdadm raid because they
have a tiny amount of metadata to spoof compared to a Btrfs volume
with even a little bit of data on it. I think this concern is
overblown.



> If then btrfs would select any of these, it may also select the wrong
> one - ro or rw, this may likely lead to problems.





>> dd is not a copy operation. It's creating a 2nd original. You don't
>> end up with an original and a copy (or clone). A copy or clone has
>> some distinguishing difference. Volume UUID is used throughout Btrfs
>> metadata, it's not just in the superblocks. Changing volume UUID
>> requires a rewrite of all metadata. This is inefficient for two
>> reasons: one dd copies unused sectors; two it copies metadata that
>> will have to be completely rewritten by btrfstune to change volume
>> UUID; and also the subvolume UUIDs aren't changed, so it's an
>> incomplete solution that has problems (see other threads).
> Well dd is surely not the only thing that can be used to create a clone
> (i.e. a bitwise identical copy - I guess we don't really care which is
> the "original" and which are the "clones", or whether these are "2nd
> originals).
> We always just use it here as an example for scenarios in which bitwise
> identical copies are created.

I'm suggesting bitwise identical copies being created is not what is
wanted most of the time, except in edge cases.





>
> And even if internally it's a big thing, from the user's PoV, changing
> the UUID is pretty simple (I guess that's what S.J. meant).
>
>
>> If your workflow requires making an exact copy (for the shelf or for
>> an emergency) then dd might be OK. But most often it's used because
>> it's been easy, not because it's a good practice.
> Ufff.. I wouldn't got that far to call something here bad or good
> practice.

It's not just bad practice, it's sufficiently sloppy that it's very
nearly user sabotage. That this is due to innocent ignorance, and a
long standing practice that's bad advice being handed down from
previous generations doesn't absolve the practice and mean we should
invent esoteric work arounds for what is not a good practice. We have
all sorts of exhibits why it's not a good idea.


> At least, I do not see any reason to call it a bad practice, except
> that systems got over time much more complex and haven't dealt properly
> with the problems that can occur by using dd.

The lack of maturity in tools to make it just as easy, or easier, and
faster, to make a *data* bitwise identical copy, that preserves the
intent and integrity of UUID by ensuring there aren't duplicates of
them floating around, as well as profile reshaping on the fly, as well
as a means to account for format changes, etc is a completely
reasonable excuse for continuing to use dd - but it's still suboptimal
which is what I mean by bad idea.


> Again, I don't demand magical "solutions" (i.e. the btrfs or LVM people
> getting code into all dd like tools, so that these auto-detect when the
> duplicate such data and auto-change the UUIDs)... they just should
> handle the situations gracefully.

I disagree. It was due to the rudimentary nature of earlier
filesystems' metadata paradigm that it worked. That's no longer the
case.

Sure, the kernel code should get smarter about refusing to mount in
ambiguous cases, so that a file system isn't nerfed. That shouldn't
happen. But we also need to get away from this idea that dd is
actually an appropriate tool for making a file system copy.



>
>
>>  Note that Btrfs is
>> not unique, XFS v5 does a very similar thing with volume UUID as
>> well,
>> and resulted in this change:
>> http://oss.sgi.com/pipermail/xfs/2015-April/041267.html
> Do you mean that xfs may suffer from the same issues that we're talking
> about here? If so, one should probably give them a notice.

They're aware, that's why xfs_db had the option to change the UUID in
the first place. And the XFS kernel code knows not to mount a 2nd
instance of a volume UUID. But it doesn't support multiple devices, so
it's no where near as prone to problems in this area. If you're using
LVM snapshots, the duplicate UUID problem certainly comes up. While
there is a 'nouuid' mount option for XFS, I have no idea what problems
this might cause for V5 filesystems.




-- 
Chris Murphy
