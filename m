Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35315 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbcFFLyq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jun 2016 07:54:46 -0400
Received: by mail-io0-f178.google.com with SMTP id o189so125775685ioe.2
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jun 2016 04:54:45 -0700 (PDT)
Subject: Re: RAID1 vs RAID10 and best way to set up 6 disks
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1464977432.1571.20.camel@gmail.com>
 <1464977591.6679.13.camel@scientia.net> <1464979359.1571.25.camel@gmail.com>
 <1464980373.6679.28.camel@scientia.net>
 <89aaee85-9ad5-9bde-b4fb-6c4758e8fd34@swiftspirit.co.za>
 <1465089045.6662.19.camel@scientia.net>
 <CAJCQCtSLsA5RfPG1Q2m99DHmYCp3EAXkTnZxBbfX8usLvFbgCw@mail.gmail.com>
 <1465158692.6702.21.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <cf780b5c-0a9d-14ea-2d06-870a7575755d@gmail.com>
Date: Mon, 6 Jun 2016 07:54:41 -0400
MIME-Version: 1.0
In-Reply-To: <1465158692.6702.21.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-05 16:31, Christoph Anton Mitterer wrote:
> On Sun, 2016-06-05 at 09:36 -0600, Chris Murphy wrote:
>> That's ridiculous. It isn't incorrect to refer to only 2 copies as
>> raid1.
> No, if there are only two devices then not.
> But obviously we're talking about how btrfs does RAID1, in which even
> with n>2 devices there are only 2 copies - that's incorrect.
Go read the original standards that defined the term RAID (assuming you 
can find a openly accessible copy), it defines RAID1 as a mirrored 
_pair_ of disks.  This is how every hardware RAID controller I've ever 
seen implements RAID1, and in fact how most software RAID 
implementations (including the fake raid in some motherboards) 
implements it with the sole exception of Linux's MD-RAID and it's direct 
derivatives (which includes LVM/DM based RAID, as well as BSD's GEOM 
framework).
>
>
>>  You have to explicitly ask both mdadm
> Aha, and which option would that be?
Specifying more than two disks.  The request is more correctly an 
implicit one, but the fact that it's implied by a now largely obsolete 
piece of software does not mean that BTRFS should have the same 
implications.
>
>>  and lvcreate for the
>> number of copies you want, it doesn't automatically happen.
> I've said that before, but at least it allows you to use the full
> number of disks, so we're again back to that it's closer to the
> original and common meaning of RAID1 than what btrfs does.
/me inserts reflink to the first part of my reply.
>
>
>>  The man
>> page for mkfs.btrfs is very clear you only get two copies.
>
> I haven't denied that... but one shouldn't use terms that are commonly
> understood in a different mannor and require people to read all the
> small printed.
> One could also have changed it's RAID0 with RAID1, and I guess people
> wouldn't be too delighted if the excuse was "well it's in the manpage".
You can leave the hyperbolic theoreticals out of this, they really do 
detract from your argument.
>
>
>>
>>> Well I'd say, for btrfs: do away with the term "RAID" at all, use
>>> e.g.:
>>>
>>> linear = just a bunch of devices put together, no striping
>>>          basically what MD's linear is
>> Except this isn't really how Btrfs single works. The difference
>> between mdadm linear and Btrfs single is more different in behavior
>> than the difference between mdadm raid1 and btrfs raid1. So you're
>> proposing tolerating a bigger difference, while criticizing a smaller
>> one. *shrug*
>
> What's the big difference? Would you care to explain? But I'm happy
> with "single" either, it just doesn't really tell that there is no
> striping, I mean "single" points more towards "we have no resilience
> but only 1 copy", whether this is striped or not.
On this point I actually do kind of agree with you, but Chris is also 
correct here, BTRFS single mode is just as different from MD linear mode 
as BTRFS raid1 is from MD RAID1, if not more so.
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
>>> striped = basically what RAID0 is
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
>
> SINGLE would be something like "replicas1-parity0-notstriped".
> RAID5 would be something like "replicas0-parity1-striped".
It's worth pointing out that both programmers and sysadmins are still 
lazy typists, so it would more likely end up being:
rep1-par0-strip0
rep0-par1-stripN (with N being the number of desired stripes).

Having a number to indicate the striping is actually useful (there are 
legitimate cases for not striping across everything we can, and we need 
some way to represent stripes that weren't allocated at full width for 
some reason).

Such a scheme was actually proposed back when the higher order parity 
patches were being discussed.  Like those patches, it was decided to 
wait until we had basic feature completeness before trying to tackle that.
>
>
>>> And just mention in the manpage, which of these names comes closest
>>> to
>>> what people understand by RAID level i.
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
And it's also almost always someone who didn't properly read the 
documentation, which means they would have gotten bitten by something 
else eventually as well.  This expectation that anyone should be able to 
pick up any piece of software and immediately use it without reading 
documentation needs to stop.  Catering to such people is not a 
sustainable design choice for a piece of software as complex as a 
filesystem.
> And I don't think these people can be blamed for not RTFM, because IMHO
> this is a term commonly understood as mirror all available devices.
> That's how the original paper describes it, it's how Wikipedia
> describes it and all other sources I've ever read to the topic.
The first sentence of 
https://en.wikipedia.org/wiki/Standard_RAID_levels#RAID_1 as of right 
now is exactly:
RAID 1 consists of an exact copy (or mirror) of a set of data on two or 
more disks; a classic RAID 1 mirrored pair contains two disks.

The 'classic RAID 1 mirrored pair' it refers to describes every RAID-1 
implementation I or anyone I've asked (including people of the pre-UNIX 
vintage who still deal with computers) has ever seen with the sole 
exception of the software implementations in Linux and BSD.
>
>>  The one that's unequivocally
>> problematic alone without reading the man page is raid10. The
>> historic
>> understanding is that it's a stripe of mirrors, and this suggests you
>> can lose a mirror of each stripe i.e. multiple disks and not lose
>> data, which is not true for Btrfs raid10. But the man page makes that
>> clear, you have 2 copies for redundancy, that's it.
> Yes, same basic problem.
>
>
>> On the CLI? Not worth it. If the user is that ignorant, too bad, use
>> a
>> GUI program to help build the storage stack from scratch. I'm really
>> not sympathetic if a user creates a raid1 from two partitions of the
>> same block device anymore than if it's ultimately the same physical
>> device managed by a device mapper variant.
>
> Well one I have no strong opinion on that... if testing for it (or at
> least simple cases) would be easy, why not.
> Not every situation may be as easily visible as creating a RAID1 on
> /dev/sda1 and /dev/sda2.
> One may use LABELs, or UUIDs and accidentally catch the wrong, and in
> such cases a check may help.
To paraphrase something from the Debian IRC:
'Our job is to make sure that if the user points a gun at his foot and 
pulls the trigger, the bullet gets to the intended location'

There are limits to what we can protect against, and we shouldn't be 
preventing people from doing things that while they seem unreasonable at 
face value, are perfectly legitimate uses of the software.  BTRFS raid1 
mode on a single device falls solidly into this category for a couple of 
reasons:
1. Until recently, this was the only way without mixed mode to get data 
chunk redundancy on a single device.  In many distros, this is still the 
only way to do so.
2. Because of how it's implemented, this actually doesn't get insanely 
horrible performance like trying to do the same thing with MD or LVM 
based RAID would.
3. This allows for forcing specific organization of data on the media, 
which can combined with item 1, be particularly useful (for example, 
some SSD's have SLC flash backing the area up through where the MFT 
would be on NTFS, and MLC for the rest, or some 'hybrid' disks actually 
just have flash for the first part of the logical device they expose, 
and traditional magnetic storage for the rest).
