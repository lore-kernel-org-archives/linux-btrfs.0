Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:36356 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbbFLKLI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 06:11:08 -0400
Received: by qcjl8 with SMTP id l8so9057807qcj.3
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2015 03:11:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$e5a8$4c012c37$4117558f$ba504801@cox.net>
References: <CAGnHSEkEshdECi7TQ73DZRDg=t7kxwB7FCkPOTXruaiwHfzUUQ@mail.gmail.com>
	<pan$e5a8$4c012c37$4117558f$ba504801@cox.net>
Date: Fri, 12 Jun 2015 18:11:07 +0800
Message-ID: <CAGnHSE=ik7Vta4i3ia9AvH=Epb=G3oifCAvTJVck81zi=0VWjQ@mail.gmail.com>
Subject: Re: multiple "devices" with multiple partitions on one SSD
From: Tom Yan <tom.ty89@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for you reply. I thought of the same thing as you've told,
but because I don't really know how SSD/SATA works internally, so I
was also thinking if "raid0" on the same drive might works as
something like "Hyper-Threading" in CPU.

I'll go for "single" then. With that I don't have to start with two
partitions as well. : )

On 12 June 2015 at 17:47, Duncan <1i5t5.duncan@cox.net> wrote:
> Tom Yan posted on Thu, 11 Jun 2015 19:34:13 +0800 as excerpted:
>
>> So I am thinking of having multiple partitions (50GiB per one) on an
>> SATA3 SSD (200GiB available) to be used with a single btrfs filesystem.
>> The reason I am thinking about this is I would like to start from one
>> partition (or two if necessary), and then add the remaining one on
>> demand (if they aren't going to be used for other purpose). So I would
>> like to know whether raid0 has any advantages on a single drive, or I
>> should just use the "single" profile, or it's a bad idea either way.
>
> Interesting question.  Totally not where I thought this was going, given
> the subject.  I thought you were going to ask about faking raid1.[1]
> Instead, you went the opposite direction, and are effectively asking
> about faking raid0. =:^)
>
> On a partitioned single physical device, between single mode and raid1
> I'd say stick with single mode.  With ssd the speed shouldn't matter much
> (on spinning rust single mode would be predicted to be faster due to less
> seeking), but single mode is much less complex in terms of btrfs
> management, and in case of damage, you're more likely to recover more
> files in single mode, than you would with raid0.
>
> That said, btrfs checksumming and the chance of recovery it gives you if
> there's a second copy available, means if you have the room, raid1 (or dup
> mode on a single device, but that wouldn't work with your multi-partition-
> device idea, see the footnote below) can be worth the additional space it
> takes.  In single mode if the checksum is bad you just lost that file as
> btrfs doesn't yet have a way to tell it "I know the checksum says bad,
> but give it to me anyway as I might be able to recover /something/ out of
> it".  In raid1 or dup mode, there's a second copy to fall back to, that
> might well be valid.  For me at least, that's worth the extra space it
> requires.
>
> That's for data.  For metadata, I'd DEFINITELY recommend raid1/dup, even
> if you can't spare the room to raid1/dup the data, and that's actually
> the default, except for single-device SSD, which defaults to single mode
> metadata for various reasons.
>
>
> As for whether the whole multi-partition faking multi-device idea is
> worth it... I'd say it's close enough to be your call.
>
> Personally, were I working with a single device in that way, I'd probably
> do just one big partition, but use the mkfs.btrfs --byte-count option to
> create a filesystem smaller than the entire partition it was in.  Then I
> could increase the size of the filesystem when I needed to, without
> having to worry about adding a new fake device (actually partition on the
> same device) to it.  Or make just one smaller partition and leave the
> rest of the space unpartitioned, so you can grow the partition, and then
> the filesystem, when needed.
>
> But again for me personally, as I explained above, I prefer btrfs raid1
> or dup mode, so there's a second copy of everything in case of checksum
> failure on the one.  For the single physical device case, that means
> either mixed-blockgroup-mode data/metadata so dup mode can be used for
> both, or faking (at least) two devices and doing raid1 for both data and
> metadata, so one copy appears on each device.  I actually discuss that in
> the footnote section below.
>
> Tho of course if you're doing dup/raid1, that will by definition take
> twice the space, or put differently, let you store half the stuff.  While
> that's a tradeoff I consider well worth it, not everyone will.  In which
> case, we're back to what you proposed, single for data, with the caveat
> that I'd strongly recommend dup/raid1 for metadata, depending on whether
> you go the single logical device route or the multiple logical device
> route.
>
>
> Meanwhile... I'm not sure that came out as clear written down as it is in
> my head, but hopefully you can make at least some sense of it. =:^)
>
>
> -----
> [1] I thought it was going to be a question about faking multiple
> physical devices using partitions on a single physical device, in ordered
> to do raid1, in ordered to be able to take advantage of the checksum
> redundancy it provides for data, since only metadata can be set to dup
> mode.  For that use-case, I was going to say that while it doesn't matter
> so much on ssd, on spinning rust that's going to really drag down
> performance due to the seeks to write the second copy in the other
> partition.  Setting mixed-blockgroup-mode (data and metadata mix together
> in the same blockgroups, this is the default for filesystems under a GiB)
> during the mkfs.btrfs is a far more efficient way to achieve close to the
> same thing, at least on spinning rust, as you'll get the second copy, but
> without the long seeks.  Mixed-bg mode has performance penalty compared
> to separate data/metadata, but it's nothing close to the penalty you'll
> get from raid1 on separate partitions of the same physical disk.
>
> OTOH, in theory at least, if you create one partition at each end with
> some unused space in the middle for separation, the physical partitions
> raid1 would be a slightly more robust solution, as damage would be more
> likely limited to one copy of the two as they'd be guaranteed to be
> spaced at least the blank-space between the partitions apart.
>
> On ssd, separate partitions for raid1 on a single physical device
> wouldn't be as bad, but I /suspect/ that dup would still be better.
> However, I'd have to see benchmark results to be sure, and I don't know
> of any tests of that specific scenario, so I can't say for sure.  But the
> distance apart wouldn't likely matter on ssd, as the ssd firmware
> redirects writes so you don't have any way of knowing where they are
> actually placed on the physical media anyway, unless you know how that
> specific firmware works.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
