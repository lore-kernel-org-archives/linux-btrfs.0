Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34943 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbbLNUz7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 15:55:59 -0500
Received: by iofq126 with SMTP id q126so48261742iof.2
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 12:55:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450052868.30943.27.camel@scientia.net>
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
	<CAJCQCtSXkXs0jQ=zaP6FJvRZS0yvz5CrjP8a06K0+htG5H8LTg@mail.gmail.com>
	<1450052868.30943.27.camel@scientia.net>
Date: Mon, 14 Dec 2015 13:55:59 -0700
Message-ID: <CAJCQCtQG7tLnc8WmGRvnB6OjbdVxZC6Q9Hp8J8bZfkdGcayZ2g@mail.gmail.com>
Subject: Re: attacking btrfs filesystems via UUID collisions?
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 13, 2015 at 5:27 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> On Fri, 2015-12-11 at 16:06 -0700, Chris Murphy wrote:
>> For anything but a new and empty Btrfs volume
> What's the influence of the fs being new/empty?
>
>> this hypothetical
>> attack would be a ton easier to do on LVM and mdadm raid because they
>> have a tiny amount of metadata to spoof compared to a Btrfs volume
>> with even a little bit of data on it.
> Uhm I haven't said that other systems properly handle this kind of
> attack. ;-)
> Guess that would need to be evaluated...
>
>
>>  I think this concern is overblown.
> I don't think so. Let me give you an example: There is an attack[0]
> against crypto, where the attacker listens via a smartphone's
> microphone, and based on the acoustics of a computer where gnupg runs.
> This is surely not an attack many people would have considered even
> remotely possible, but in fact it works, at least under lab conditions.

I'm aware of this proof of concept. I'd put it, and this one, in the
realm of a targeted attack, so it's not nearly as likely as other
problems needing fixing. That doesn't mean don't understand it better
so it can be fixed. It means understand before arriving at risk
assessment let alone conclusions.



> Apart from that, btrfs should be a general purpose fs, and not just a
> desktop or server fs.
> So edge cases like forensics (where it's common that you create bitwise
> identical images) shouln't be forgotten either.

I didn't. I did state there are edge cases, not normal use. My
criticism of dd for copying a volume is for general purpose copying,
not edge cases.



>
>
>> > >If your workflow requires making an exact copy (for the shelf or
>> > > for
>> > > an emergency) then dd might be OK. But most often it's used
>> > > because
>> > > it's been easy, not because it's a good practice.
>> > Ufff.. I wouldn't got that far to call something here bad or good
>> > practice.
>>
>> It's not just bad practice, it's sufficiently sloppy that it's very
>> nearly user sabotage. That this is due to innocent ignorance, and a
>> long standing practice that's bad advice being handed down from
>> previous generations doesn't absolve the practice and mean we should
>> invent esoteric work arounds for what is not a good practice. We have
>> all sorts of exhibits why it's not a good idea.
> Well if you don't give any real arguments or technical reasons (apart
> from "working around software that doesn't handle this well") I
> consider this just repetition of the baseless claim that long standing
> practise would be bad.

I already have, as have others.

Does the user want cake or pie? The computer doesn't have that level
of granular information when there are two apparently bitwise
identical devices. The file system sees them both as dessert, without
other distinction. So option a is to simply fail and let the user
resolve the ambiguity. Option b is maybe to leveral btrfs check code
and find out if there's more to the story, some indication that one of
the apparently identical copies isn't really identical. But that's a
lot of work for something that probably won't happen. What's more
likely is they aren't just apparently identical, they are in fact
identical because it's an LVM snapshot or a dd copy that's making them
appear identical. That's not something btrfs can resolve alone.

To automate the distinction, requires more information. If it's LVM,
possibly LVM and Btrfs could work together where LVM LV UUID * Btrfs
volume UUID = Btrfs volume UUID'  (as in a derivative) and to treat it
internally with a new temp UUID that's throw away.

If it's a raw device, I still see this as the user's problem. They
created it, they'll have to help resolve the ambiguity by yanking one
of the drives.



> Long story, short, I think we can agree, that - dd or not - corruptions
> or attack vectors shouldn't be possible.

Yes.


-- 
Chris Murphy
