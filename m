Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33313 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbbLNNXf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 08:23:35 -0500
Received: by iow186 with SMTP id 186so24938820iow.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 05:23:34 -0800 (PST)
Subject: Re: attacking btrfs filesystems via UUID collisions?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20151204120529.37E47D5A28@emkei.cz>
 <20151204130758.GR8775@carfax.org.uk>
 <1449286104.18841.14.camel@scientia.net>
 <pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
 <1449366680.3183.37.camel@scientia.net> <56644785.4090702@gmx.com>
 <1449639588.7835.2.camel@scientia.net> <5668A1CB.1020007@anonym.com>
 <CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
 <1449872498.31388.74.camel@fo>
 <CAJCQCtSXkXs0jQ=zaP6FJvRZS0yvz5CrjP8a06K0+htG5H8LTg@mail.gmail.com>
 <1450052868.30943.27.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <566EC2D7.3000101@gmail.com>
Date: Mon, 14 Dec 2015 08:23:35 -0500
MIME-Version: 1.0
In-Reply-To: <1450052868.30943.27.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-13 19:27, Christoph Anton Mitterer wrote:
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
>>   I think this concern is overblown.
> I don't think so. Let me give you an example: There is an attack[0]
> against crypto, where the attacker listens via a smartphone's
> microphone, and based on the acoustics of a computer where gnupg runs.
> This is surely not an attack many people would have considered even
> remotely possible, but in fact it works, at least under lab conditions.
>
> I guess the same applies for possible attack vectors like this here.
> The stronger actual crypto and the strong software gets in terms of
> classical security holes (buffer overruns and so), the more attackers
> will try to go alternative ways.
The reason that this isn't quite as high of a concern is because 
performing this attack requires either root access, or direct physical 
access to the hardware, and in either case, your system is already 
compromised.

I still think that that isn't a sufficient excuse for not fixing the 
issue, as there are a number of non-security related issues that can 
result from this (there are some things that are common practice with 
LVM or mdraid that can't be done with BTRFS because of this).
>
>> I'm suggesting bitwise identical copies being created is not what is
>> wanted most of the time, except in edge cases.
> mhh,.. well there's the VM case, e.g. duplicating a template VM,
> booting it deploying software. Guess that's already common enough.
> There are people who want to use btrfs on top of LVM and using the
> snapshot functionality of that... another use case.
> Some people may want to use it on top of MD (for whatever reason)... at
> least in the mirroring RAID case, the kernel would see the same btrfs
> twice.
Also, using flat DM-RAID (and yes, people do use DM-RAID without LVM), 
using the DM-cache target, some multi-path setups, some shared storage 
setups, a couple of other DM targets, and probably a number of other 
things I haven't thought of yet.
>
> Apart from that, btrfs should be a general purpose fs, and not just a
> desktop or server fs.
> So edge cases like forensics (where it's common that you create bitwise
> identical images) shouln't be forgotten either.
While I would normally agree, there are ways to work around this in the 
forensics case that don't work for any other case (namely, if BTRFS is 
built as a module, you can unmount everything, unload the module, reload 
it, and only scan the devices you want).
>
>
>>>> If your workflow requires making an exact copy (for the shelf or
>>>> for
>>>> an emergency) then dd might be OK. But most often it's used
>>>> because
>>>> it's been easy, not because it's a good practice.
>>> Ufff.. I wouldn't got that far to call something here bad or good
>>> practice.
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
Agreed, if yo9u can't substantiate _why_ it's bad practice, then you 
aren't making a valid argument.  The fact that there is software that 
doesn't handle it well would say to me based on established practice 
that that software is what's broken, not common practice.

The assumption that a UUID is actually unique is an inherently flawed 
one, because it depends both on the method of generation guaranteeing 
it's unique (and none of the defined methods guarantee that), and a 
distinct absence of malicious intent.
>
>> I disagree. It was due to the rudimentary nature of earlier
>> filesystems' metadata paradigm that it worked. That's no longer the
>> case.
> Well in the end it's of course up to the developers to decide whether
> this is acceptable or not, but being on the admin/end-user side, I can
> at least say that not everyone on there would accept "this is no longer
> the case" as valid explanation when their fs was corrupted or attacked.
On that note, why exactly is it better to make the filesystem UUID such 
an integral part of the filesystem?  The other thing I'm reading out of 
this all, is that by writing a total of 64 bytes to a specific location 
in a single disk in a multi-device BTRFS filesystem, you can make the 
whole filesystem fall apart, which is absolutely absurd.
>
>> Sure, the kernel code should get smarter about refusing to mount in
>> ambiguous cases, so that a file system isn't nerfed. That shouldn't
>> happen. But we also need to get away from this idea that dd is
>> actually an appropriate tool for making a file system copy.
> Uhm... your view is a bit narrow-sighted... again take the forensics
> example.
And some recovery situations (think along the lines of no recovery disk, 
and you only have busybox or something similar to work with).
>
> But apart from that,... I never said that dd should be the regular tool
> for people to copy a btrfs image. Typically it would be simply slower
> than other means.
>
> But for some solutions, it may still be the better choice, or at least
> the only choice implemented right now (e.g. I wouldn't now of a
> hypervisor system, that looks at an existing disk image, finds any
> btrfs in that (possibly "hidden" below further block layers), and
> cleanly copies the data into freshly created btrfs image, with the same
> structure.
> AFAIK, there's not even a solution right now, that copies a complete
> btrfs, with snapshots, etc. preserving all ref-links. At least nothing
> official that works in one command.
Send-receive kind of works for that, but requires down time because the 
subvolumes all have to be read-only.  In theory, it's possible, but it 
would take a lot of work, and a lot of special case handling to 
implement properly.
>
> Long story, short, I think we can agree, that - dd or not - corruptions
> or attack vectors shouldn't be possible.
> And be it just, to protect against the btrfs on hardware RAID1 case,
> which is accidentally switched to JBOD mode...


