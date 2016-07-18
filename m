Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:33032 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbcGRW3F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 18:29:05 -0400
Received: by mail-lf0-f44.google.com with SMTP id b199so479635lfe.0
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jul 2016 15:29:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <aa570d41-872d-bfde-e569-85e8b274b029@gmail.com>
References: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
 <56C7BB16-91D2-42AB-B81A-33403CAFE0ED@gmail.com> <9d52a64a-eb5a-e626-2c62-2ff9bede2eef@friedels.name>
 <CAKinxcUBhsh_b6en_4B9cQ77UPMTtbYPusedPegucW3ZP0Fkuw@mail.gmail.com>
 <0e3dfcb6-c635-5904-9e97-1aa11a84dcd4@friedels.name> <96008b98-0100-35e5-50b0-43e923c92010@gmail.com>
 <bd311710-35c8-ce52-5b5a-96876330bde6@friedels.name> <667a14be-4a01-02f6-79f9-a8cd585f360d@gmail.com>
 <f7dec129-0aa2-832a-1842-95cd2ddd940e@friedels.name> <aa570d41-872d-bfde-e569-85e8b274b029@gmail.com>
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Date: Mon, 18 Jul 2016 23:29:01 +0100
Message-ID: <CAKinxcX+hLKODqPYjyTdADphC_dd6W1GApNV8JE-KfNjPBNyVw@mail.gmail.com>
Subject: Re: Status of SMR with BTRFS
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Hendrik Friedel <hendrik@friedels.name>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, dave@jikos.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for late reply, there was a lot of traffic in this thread so:

1. I do apologize but I've got a wrong end of the stick, I was
convinced that btrfs does cause corruption on your disk because some
of the link that you've hav in original post were pointing to topics
with corruptions going on, but you are concerned about performance -
right ?

2. I'm still not convinced that Seagate would miss out such a feature
as SMR and mistakenly called it TGMR ... a lot of money is involved
with storing data and egg in the face moment can cast them a lot ...
ALSO it's called "barracuda" historically this meant disks with good
IO performance, can't think that somebody at seagate would put
barracuda label on stinking SMR (yes SMR stinks! but about that later
on). Thou I remember how Micron used to have a complete mess in their
data sheets :/

3. f2fs as well as jffs2, logfs will give a tremendous performance on
spinners :D those file system are meant for tiny flash devices with
minimal IO, minimal power available, minimal erases, and ti fit in
that market those try to mimise fragmentation of flash, to serialise
writes, to eliminate jumping thought flash so in will self wear
balance. Result of that on spinner is that it will give you a very
static and sequential IO on writing data, but your reads will be crap
... and as every single "developed for flash" filesystem it will
expect your device to have a 100% functional TRIM that will result in
a block (usually 128kB) to be reset to 0xFF ... spinners don't do that
... and this is where you will see corruption. Also a lot of those
file systems will require a direct access to device rather than block
device emulation. Also on a flash device you can walk in and alter a
bit in a byte as long as you change it from physical "1" to "0", on
spinner you need to rewrite a sector and associated with it CRC and
corrective data etc, on SMR you will have to rewrite a whole BAND ...
FUN !! so every time your filesystem will mark something for future
TRIM it will try to set single bit in block associated data (hahaha
your band needs to get rewritten) and this is how you will effectively
kill sectors (bands) on your disk !

4. SMR stinks ... yes it does ... it's a recipe for a disaster, slight
modifications cause a lot of work load on a drive ... if you modify a
"sector" most of a band needs to get rewritten ... this is where
corruption creeps it, where disk surface wears, I understand how NSA
may have a use case for that - google shifts data between server farms
in US and broad then they send a copy to NSA (yes they do), NSA stores
it, but they don't care about single bit root of minor defects, data
does not get modified, just analysed in bulk and discarded and whole
array get written with fresh data ... amazon on the other hand gets
paid for not having your data corrupted ... so they won't fancy SMR
that much (maybe glacier) see a patern here ? as a user to have that
type of use case is just weird, if you want to back up your data than
you care about it ... then I'm not convinced that SMR is truly for
you. Also 5TB device connected to USB3 used as a backup :O :O :O :O :O
:O I wouldn't keep my "just in case internet was down backup of
pornhub" on that setup :) And I'm not picking on you here ... I
personally used far better backup than that and still it failed and
still people pointed out bluntly how pathetic it was ... and they were
right !


In terms of SMR those are my brutal opinions ... and nothing more. I
accept that most likely I'm wrong. Hell, been wrong most of my life,
it's just after 10 years of engineering embedded devices for various
application I'm just veeeeeerrrrrrrrryyyy precocious due to
experiences with a lot of "some bright spark" (clueless guy that
wanted to feel more intelligent than engineers) "decided to use this
revolutionising thing" (wanted to prove him self and based everything
on a luck) "and created a valid learning experience for whole
development team" (all engineers wanted to kill him) "and we all came
out of that stronger and with more experience" (he/she got fired).

On 18 July 2016 at 20:30, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> On 2016-07-18 15:05, Hendrik Friedel wrote:
>>
>> Hello Austin,
>>
>> thanks for your reply.
>>
>>>> Ok, thanks; So, TGMR does not say whether or not the Device is SMR or
>>>> not, right?
>>>
>>> I'm not 100% certain about that.  Technically, the only non-firmware
>>> difference is in the read head and the tracking.  If it were me, I'd be
>>> listing SMR instead of TGMR on the data sheet, but I'd be more than
>>> willing to bet that many drive manufacturers won't think like that.
>>>>
>>>> While the Data-Sheet does not mention SMR and the 'Desktop' in the name
>>>> rather than 'Archive' would indicate no SMR, some reviews indicate SMR
>>>>
>>>> (http://www.legitreviews.com/seagate-barracuda-st5000dm000-5tb-desktop-hard-drive-review_161241)
>>>>
>>>>
>>>  Beyond that, I'm not sure,
>>> but I believe that their 'Desktop' branding still means it's TGMR and
>>> not SMR.
>>
>>
>> ... which in the Seagate nomenclature might not exclude each other (TGMR
>> could still be SMR). I will just ask them...
>> How did you find out on your drives whether they use SMR?
>
> I've actually manually deconstructed quite a few hard disks for work. We
> have to wipe old disks before they leave the building, and if we can't do it
> in software because of something like a head crash, we have to take them
> apart and physically destroy the platters.  There are actually visible
> differences in regular TGMR and SMR heads, so if you know what to look for,
> you can tell by the write heads (it's also a dead giveaway when a drive has
> significantly fewer platters than TB's of space).  There's also measurable
> performance differences for certain access patterns, but that doesn't work
> as reliably as it sounds like it should (the actual physical data layout on
> disk these days may look nothing like what software sees).
>>
>>
>>> I'd very much suggest avoiding USB connected SMR drives though, USB is
>>> already poorly designed for storage devices (even with USB attached
>>> SCSI), and most of the filesystem issues I see personally (not just with
>>> BTRFS, but any other filesystem as well) are on USB connected storage,
>>> so I'd be very wary of adding all the potential issues with SMR drives
>>> on top of that as well.
>>
>>
>> Understood. But I use this drive as a Backup. The Drive must not be
>> connected to the System unless doing a backup. Otherwise a Virus, or
>> just an issue with the power (peak due to lightning strike) might vanish
>> both the Source data and Backup at once (single point of failure).
>
> In that case, I'd be very careful to wait for a while after finishing a
> backup before disconnecting the disk (and make sure to unmount the
> filesystem before waiting so that everything gets flushed to disk), and make
> sure to validate your backups as well.  Once the disk has been safely
> disconnected, you're fine though, the issues arise if the device suddenly
> disappears from the bus or loses power (which is of course an issue for
> regular drives, the filesystem damage just tends to be much worse with SMR
> drives).  For what it's worth, I've seen fewer issues with (recent) USB 3.0
> devices than USB 2.0, but even just bumping the cable can cause issues
> sometimes.
