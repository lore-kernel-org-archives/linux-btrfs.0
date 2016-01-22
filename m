Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46004 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbcAVMIx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 07:08:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aMaWJ-0007fb-V1
	for linux-btrfs@vger.kernel.org; Fri, 22 Jan 2016 13:08:51 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 13:08:51 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 13:08:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Out of space on small-ish partition, clobber and other methods
 haven't worked
Date: Fri, 22 Jan 2016 12:08:41 +0000 (UTC)
Message-ID: <pan$978c4$c1c61c61$74128c09$7a6863e0@cox.net>
References: <CAHRikPEe9JVRmBysLQ8r1OhwXsSpfJOXy4EWU8m=egbkt9zE7w@mail.gmail.com>
	<CAJCQCtSyc1YAsVgNcPCeA5fW8cofwqSVuF69acZo+GYm2rUx4A@mail.gmail.com>
	<pan$a0430$c59023ae$8ef223cd$7c2025cc@cox.net>
	<CAJCQCtQpHuN9QYeTY+dZ7KH09cjD1=CPUw1Ba8vY-8bVgicTdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 21 Jan 2016 10:40:51 -0700 as excerpted:

>> Global reserve is normally reserved from metadata, which of course is
>> shared data/metadata here, due to the size of the filesystem (which
>> makes shared a practical necessity, the problems would be much worse if
>> data and metadata chunks were separate!).
>>
>> So of the 506 MiB in data/metadata, 12 MiB are global reserve.  Which
>> means there's only 494 MiB of normal data/metadata space, plus 12 MiB
>> of global reserve.
>>
>> But the DF shows 500.39 MiB of data/metadata used, which means we're
>> roughly 6.4 MiB past normal data/metadata usage into the emergency use
>> only global reserve, which is indeed (roughly) what global reserve
>> shows,
>> 6.45 MiB used.
> 
> OK that's a fine explanation, but the UI is not explaining this at all.
> In fact it's completely misleading *away* from the explanation you give.
> It's suggesting there's free space by the fact "used" is less than
> "total".

... Which is why there's already a proposal (and patch, IIRC) to indent 
global reserve under metadata, increasing the "used" metadata value by 
the "total" value of global reserve, tho there's an alternate viewpoint 
in the discussion saying that global reserve shouldn't be shown at all, 
just included in the metadata "used" figure, unless an option is given to 
show it.

With David, IIRC, as another viewpoint, saying that fi df is fine as-is, 
as it's intended for dev and advanced users who know the score, while fi 
usage should be recommended for normal users.

But as I pointed out (my viewpoint) until David's patches that made it 
into -progs 4.4, usage didn't work in some cases, namely --mixed mode, 
with a warning at the top and often returning 8 EiB (on 64-bit anyway) as 
something was going negative due to a screwy formula (thus the 
unsupported warning) but then being reported as the ridiculously high 
unsigned value.  Between that and the fact that fi usage is itself 
relatively new compared to the old fi show and fi df recommendation, it's 
simply impractical to recommend fi usage in the generic case, without a 
big hairy explanation of why it might not even be there (too old 
userspace) or be reporting absolutely crazy values (--mixed mode before 
it was properly supported in the still very new 4.4 userspace).  So 
recommending users post their btrfs fi show and btrfs fi df is going to 
remain the only practical option for another year or two, and  
interpreting the global reserve line in btrfs fi df is as much a 
challenge for those not "in the know" as is interpreting the global total 
vs. device total in btrfs fi show is.  In both cases, interpretation is 
definitely a form of art, only doable by those who know the inside tricks 
of interpretation.

So yeah, interpretation of btrfs fi df, particularly the global reserve 
as part of metadata, is tricky, requiring internal knowledge to do 
correctly, but so is interpreting btrfs fi show, and we've gotten so used 
to dealing with that, that it's hardly ever remarked on any more, except 
perhaps in explaining to newbies that the simplest thing to do there is 
to ignore the global total line and only look at the individual device 
lines.  (The numbers in show's global total have a value, but they're not 
what people intuitively think they are, and it's often easier to simply 
tell people to pretend that line doesn't exist than to explain where the 
number actually comes from, doing the required math[1] along the way.)

Meanwhile, simply adding global reserve total to metadata used, tends to 
work pretty well, and if that total is then more than metadata total, the 
difference is found in global reserved used, which if non-zero, really 
does indicate a filesystem in pretty dire straits.

And yes, it's a bug if btrfs gets into a jam so tight it can't even 
delete a file to make more room, but the reporter wasn't on the latest 
kernel either, and there's a reason the latest is recommended.  As I 
said, I think I saw some patches go by that should I believe be in 4.4, 
that may very well allow btrfs to use the global reserve for file 
deletions.  And if so, that bug is not only known, but already fixed.

---
[1] Doing the required math: Heh, I just typoed that as doing the 
required meth... which might explain some things about these "gotta know 
the inside story to interpret" lines in both sub-commands!  =;^p

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

