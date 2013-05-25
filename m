Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47802 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab3EYNbI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 09:31:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UgEYs-0005wg-GS
	for linux-btrfs@vger.kernel.org; Sat, 25 May 2013 15:31:06 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 May 2013 15:31:06 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 May 2013 15:31:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recommended settings for SSD
Date: Sat, 25 May 2013 13:30:50 +0000 (UTC)
Message-ID: <pan$31e65$6347b30d$404ec4b3$5bda7158@cox.net>
References: <CAAeznTr3rsJWcFWKoagNrduXGzP2AWaXMKY0FO8te2Xpa7XiHw@mail.gmail.com>
	<CAAeznTo1uiZMgedoWfE-E0v=2vTWVkV0_k-9_+vVZ6YMFfjdRg@mail.gmail.com>
	<pan$1197$73f28aeb$cb95553f$36bb7307@cox.net> <1751895.r3q1HmeO0C@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Sat, 25 May 2013 14:13:07 +0200 as excerpted:

> Am Samstag, 25. Mai 2013, 03:58:12 schrieb Duncan:
>> Leonidas Spyropoulos posted on Fri, 24 May 2013 23:38:17 +0100 as
>> 
>> excerpted:
>> > On 24 May 2013 21:07, "cwillu" <cwillu@cwillu.com> wrote:
>> >> No need to specify ssd, it's automatically detected.
>> > 
>> > I'm not so sure it did detected. When I manually set it I saw
>> > significant improvement.
>> 
>> Without going back to check the wiki, IIRC it was there that the /sys
>> paths it checks for that detection are listed.

> cat /sys/block/sda/queue/rotational
> 0

Thanks.  That looks like what I read/checked, indeed.

>> I do know my new SSDs (Corsair Neutrons, 256GB) are detected here, and
>> the ssd mount option is thus not needed.  

> And can be verified by: grep ssd /proc/mounts

Yes, that's effectively what I did.

>> Meanwhile, what about the discard option?  As I'm still setting up on
>> the SSDs as well as btrfs here, I haven't had a chance to decide
>> whether I want that, or would rather setup fstrim as a cron job, or
>> what.  But that's the other big question for SSD.
> 
> I just use fstrim once in a while.

=:^)

> We had a discussion on debian-user-german, where one user has an Intel
> SSD with media wear out indicator down to 98 I think.
> 
> The SSD is in use for about 2 years. I left about 25 GiB free of the 300
> GB it has.

> Intel claims a useful life of 5 years with 20 GB of host writes per day.
> For 2 years thats 365*20 = 7300 GB. So it seems that I am exceeding this
> a bit.
> 
> Strange, last time I looked it was way under the specified limit. KDE
> Nepomuk / Akonadi stuff? Switch of /home to BTRFS? I don´t know. What I
> know that Akonadi / KDEPIM has gone wild once and wrote 450 GB in a row
> until I stopped it doing that manually.

I run kde as my desktop and in fact am active on the kde lists as well, 
but to keep this from going /too/ far OT, let's just say that I run claws-
mail for mail now, tho I do my mailing lists via gmane using pan, so 
that's what should be in my headers.  Being on gentoo, I set
USE=-semantic-desktop and rid myself of that millstone around my neck 
around kde 4.7.  Ironic that given that the semantic-desktop millstone 
was a major kde4 feature bullet-point, it was only after I dropped it 
entirely -- at build time not just runtime -- that I FINALLY found the 
kde4 experience surpassed that of kde3, for me.

I'll leave it there, but it's safe to say there's no love here for akonadi 
and the rest of the semantic-desktop junk.

> Anyway, it seems this SSD is still good to go. Erase fail count has not
> gotten higher:
> 
> merkaba:~> smartctl -a /dev/sda | grep Erase 172 Erase_Fail_Count       
> 0x0032   100   100   000    Old_age   Always -       169
> 
> It went up from zero to 169 at some time but stayed there since then.
> 
> Also according to some other Intel PDF Intel recommends to replace the
> SSD when Media Wearout Indicitator reaches 1. This SSD is far from it at
> the moment. But I don´t know who quickly that indicator can raise.

That's interesting to know.  I don't have a media wearout indicator 
listed in smart for my devices, but I have program-fail and erase-fail 
counts, and there's still several attributes listed as "unknown", that 
will likely be filled in by smartctl updates over time.

>> Here, I'm actually partitioning for near 100% over-provisioning,
>> (120-ish GiB of partitions on the 238GiB/256GB drives, so I suspect
>> actually running with discard as a mount option won't be such a big
>> deal and will likely only cut write performance as I head toward
>> stable-state, since the drive should have plenty of trimmed space to
>> work with in any case due to the over-provisioning.  But I suspect it
>> could be of benefit to those much closer to 0% over-provisioning than
>> to my near 100%.
> 
> 100% overprovisioning is a lot. There is a PDF from Intel where 20% was
> beneficial and 40% even more so, but I think much more really isn´t
> need. But in case you don´t need the space for something, hey, why not?

Yes.  I was actually planning on 128 MB SSDs or so as I had counted only 
64 gig or so of partitions I really wanted on SSD and figured I'd grow 
them a bit, but the 128-ish gig units didn't seem to have a particularly 
good price point and 240-256 gig seemed the lower-end price-point knee, 
so that's what I bought.  That let me put a few more partitions on them 
-- everything but the media partition, basically.  I just couldn't see 
spending a bit under $1/gig for it, even if there were 500-ish gig units 
available for $400-ish.

And since I'm leaving the "spinning rust" in (on my main machine anyway, 
not the netbook when I get to it, but it's currently a 120-gig spinning 
rust drive anyway, so it'll end up similarly over-provisioned), the 
backups can go to that, meaning I don't need them on the SSDs either...

Which left me with near 100% over-provisioning!

But whatever.  I suppose I'll throw additional partitions on or expand 
what I have, over time.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

