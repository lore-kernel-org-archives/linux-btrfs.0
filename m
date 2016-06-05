Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35313 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbcFEXfd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 19:35:33 -0400
Received: by mail-oi0-f43.google.com with SMTP id w184so202395115oiw.2
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jun 2016 16:35:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465158692.6702.21.camel@scientia.net>
References: <1464977432.1571.20.camel@gmail.com>
	<1464977591.6679.13.camel@scientia.net>
	<1464979359.1571.25.camel@gmail.com>
	<1464980373.6679.28.camel@scientia.net>
	<89aaee85-9ad5-9bde-b4fb-6c4758e8fd34@swiftspirit.co.za>
	<1465089045.6662.19.camel@scientia.net>
	<CAJCQCtSLsA5RfPG1Q2m99DHmYCp3EAXkTnZxBbfX8usLvFbgCw@mail.gmail.com>
	<1465158692.6702.21.camel@scientia.net>
Date: Sun, 5 Jun 2016 17:35:31 -0600
Message-ID: <CAJCQCtT9py7nN+TLpcE+FAren3YmeJN04bSjB00j+ZVCKR2djQ@mail.gmail.com>
Subject: Re: RAID1 vs RAID10 and best way to set up 6 disks
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 5, 2016 at 2:31 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> On Sun, 2016-06-05 at 09:36 -0600, Chris Murphy wrote:
>> That's ridiculous. It isn't incorrect to refer to only 2 copies as
>> raid1.
> No, if there are only two devices then not.
> But obviously we're talking about how btrfs does RAID1, in which even
> with n>2 devices there are only 2 copies - that's incorrect.

OK and I think the assertion is asinine. You reject the only neutral
party's definition and distinction of RAID-1 types, and then claim on
the basis of opinion that Btrf's raid1 is not merely different from
traditional/classic/common understandings of RAID-1, but that they're
incorrect to have called it raid1. It's just nonsense. I find your
argument uncompellling.


>>  You have to explicitly ask both mdadm
> Aha, and which option would that be?

For mdadm it's implied as a combination of -n -x and number of
devices. For lvcreate it's explicit with -m. This is in the man page,
so I don't understand why you're asking.


>
>>  and lvcreate for the
>> number of copies you want, it doesn't automatically happen.
> I've said that before, but at least it allows you to use the full
> number of disks, so we're again back to that it's closer to the
> original and common meaning of RAID1 than what btrfs does.

The original and common meaning defined by whom, where? You're welcome
to go take it up with Wikipedia but they're using SNIA definitions for
the standard RAID levels.




>
>
>>  The man
>> page for mkfs.btrfs is very clear you only get two copies.
>
> I haven't denied that... but one shouldn't use terms that are commonly
> understood in a different mannor and require people to read all the
> small printed.

And I disagree because what you required is more reading by the user
to understand entirely new nomenclature.



> One could also have changed it's RAID0 with RAID1, and I guess people
> wouldn't be too delighted if the excuse was "well it's in the manpage".

Except nothing that crazy has been done so I fail to see the point.



>
>
>>
>> > Well I'd say, for btrfs: do away with the term "RAID" at all, use
>> > e.g.:
>> >
>> > linear = just a bunch of devices put together, no striping
>> >          basically what MD's linear is
>> Except this isn't really how Btrfs single works. The difference
>> between mdadm linear and Btrfs single is more different in behavior
>> than the difference between mdadm raid1 and btrfs raid1. So you're
>> proposing tolerating a bigger difference, while criticizing a smaller
>> one. *shrug*
>
> What's the big difference? Would you care to explain?

It's not linear. The archives detail how block groups are allocated to
devices. There are rules, linearity isn't one of them.



> But I'm happy
> with "single" either, it just doesn't really tell that there is no
> striping, I mean "single" points more towards "we have no resilience
> but only 1 copy", whether this is striped or not.
>
>
>
>> If a metaphor is going to be used for a technical thing, it would be
>> mirrors or mirroring. Mirror would mean exactly two (the original and
>> the mirror). See lvcreate --mirrors. Also, the lvm mirror segment
>> type
>> is legacy, having been replaced with raid1 (man lvcreate uses the
>> term
>> raid1, not RAID1 or RAID-1). So I'm not a big fan of this term.
>
> Admittedly, I didn't like the "mirror(s)" either... I was just trying
> to show that different names could be used that are already a bit
> better.
>
>
>> > striped = basically what RAID0 is
>>
>> lvcreate uses only striped, not raid0. mdadm uses only RAID0, not
>> striped. Since striping is also employed with RAIDs 4, 5, 6, 7, it
>> seems ambiguous even though without further qualification whether
>> parity exists, it's considered to mean non-parity striping. The
>> ambiguity is probably less of a problem than the contradiction that
>> is
>> RAID0.
>
> Mhh,.. well or one makes schema names that contain all possible
> properties of a "RAID", something like:
> replicasN-parityN-[not]striped



SNIA has created such a schema.




>
> SINGLE would be something like "replicas1-parity0-notstriped".
> RAID5 would be something like "replicas0-parity1-striped".
>
>
>> > And just mention in the manpage, which of these names comes closest
>> > to
>> > what people understand by RAID level i.
>>
>> It already does this. What version of btrfs-progs are you basing your
>> criticism on that there's some inconsistency, deficiency, or
>> ambiguity
>> when it comes to these raid levels?
>
> Well first, the terminology thing is the least serious issue from my
> original list ;-) ... TBH I don't know why such a large discussion came
> out of that point.
>
> Even though I'm not reading along all mails here, we have probably at
> least every month someone who wasn't aware that RAID1 is not what he
> assumes it to be.
> And I don't think these people can be blamed for not RTFM, because IMHO
> this is a term commonly understood as mirror all available devices.


You have the wrong understanding. The most common is exactly two disk RAID-1.


> That's how the original paper describes it, it's how Wikipedia
> describes it and all other sources I've ever read to the topic.

Wikipedia:

"RAID 1 consists of an exact copy (or mirror) of a set of data on two
or more disks; a classic RAID 1 mirrored pair contains two disks. "

An exact copy = one copy. It does not say or imply n-way.




-- 
Chris Murphy
