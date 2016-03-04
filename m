Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55523 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbcCDMzl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Mar 2016 07:55:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1abpGd-0007HB-4T
	for linux-btrfs@vger.kernel.org; Fri, 04 Mar 2016 13:55:39 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Mar 2016 13:55:39 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Mar 2016 13:55:39 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: incomplete conversion to RAID1?
Date: Fri, 4 Mar 2016 12:55:31 +0000 (UTC)
Message-ID: <pan$a0b9$20e2036$fc12847$9c0b91e0@cox.net>
References: <CAD=QJKiB9m_F+6AgmSJT_Dsd9HLBhXjEDFAcy6wLQNzO1DOkbQ@mail.gmail.com>
	<pan$54754$3acbb0c8$6074e95a$678977e7@cox.net>
	<CAD=QJKh2ugTHe7OyHniPL0dXm9wXZ3ur3-SSUTCAUWB2ZHRT9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nicholas D Steeves posted on Thu, 03 Mar 2016 16:21:53 -0500 as excerpted:

> Hi Duncan,
> 
>> Of course either way assumes you don't run into some bug that will
>> prevent removal of that chunk, perhaps exactly the same one that kept
>> it from being removed during the normal raid1 conversion.  If that
>> happens,
>> the devs may well be interested in tracking it down, as I'm not aware
>> of anything similar being posted to the list.
> 
> I've made up-to-date backups of this volume.  Is one of these two
> methods more likely to trigger a potential bug?  Also, this potential
> bug, if it's not just cosmetic wouldn't silently corrupt something in my
> pool, right?  It's when things won't fail loudly and immediately that
> concerns me, but if that's not an issue then I'd prefer to try to gather
> potentially useful data.

I don't actually expect a bug.

The only reason I added that as a caveat is that having that one empty 
single-profile chunk left around is a bit surprising as well, tho I 
expect it's simply an artifact of the hoops you needed to jump thru to 
manage the available space well enough to keep backups while doing the 
convert from LVM to, ultimately btrfs raid1.  But since that left over 
chunk /is/ a bit unexpected, it's /also/ possible it's evidence of a bug, 
not simply an artifact from the roundabout conversion process used, in 
which case the bug may hit again when trying to remove the empty chunk, 
and since it's an unknown (possible) bug, the extent of its affects are 
also unknown.

But that's just a caveat to cover the possible case, and not something 
actually expected.

Meanwhile, both methods use balance filters, either usage or profile 
based, to accomplish the same end result.  They simply take advantage of 
two different descriptors of the empty chunk, that it's empty (0% usage), 
and that it's single-profile, the only single-profile chunk left.

And both /should/ work quickly and with little to no risk.  But since we 
/do/ have the remote possibility of a possible unknown bug, it's equally 
remotely possible that one method will work while the other one won't, 
that being the possibility I had in mind when I mentioned both instead of 
just one, or that one will trigger on the unknown bug, with equally 
unknown consequences since it's an unknown bug that we only have a slight 
hint is there in the first place, with the hint just as likely being 
attributable to being a legitimate artifact of the round about way you 
had to do the conversion in ordered to be sure you weren't risking your 
backups while working within the space you had available.

Which basically is a very wordy way of saying don't worry about it; just 
do it.  You have backups and thus are covered in the remote case that the 
apparently empty chunk is actually evidence of a bug, not just the 
artifact of the conversion it would seem to be at first glance. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

