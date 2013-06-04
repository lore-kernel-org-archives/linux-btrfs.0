Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41221 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab3FDFbS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Jun 2013 01:31:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ujjpx-0005cG-Qb
	for linux-btrfs@vger.kernel.org; Tue, 04 Jun 2013 07:31:13 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Jun 2013 07:31:13 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Jun 2013 07:31:13 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID10 total capacity incorrect
Date: Tue, 4 Jun 2013 05:30:56 +0000 (UTC)
Message-ID: <pan$cce7a$a40e41fb$43748604$bdd088cf@cox.net>
References: <7b97469e82e675814317efef48cc3d71@mail.39.gs>
	<099CD4A1-A70D-4446-8C55-843D21BE4E7F@colorremedies.com>
	<20130602174359.GI20133@carfax.org.uk>
	<pan$ac513$8629998c$786e3c74$d6f66ecd@cox.net>
	<3a75ea505eaf023bce3e115533c7f314@mail.39.gs>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tim Eggleston posted on Mon, 03 Jun 2013 09:02:26 +0100 as excerpted:

>> I'd guess normal df (not btrfs filesystem df) and doing the math in his
>> head will be the simplest for him, as it is for me.
> 
>> But it's worth noting that normal df with math in your head isn't
>> /always/ going to be the answer, as things start getting rather more
>> complex as soon as different sized devices get thrown into the mix, or

> I think you've hit the nail on the head here Duncan. You're absolutely
> right that given my simple setup (even number of devices, all the same
> size, on raid10) it's trivial to do the math in my head. However I don't
> think this approach really scales as well as btrfs is intended to scale
> (up to big numbers, mixed device sizes, mixed raid levels etc etc).

Indeed.

> Obviously the implementation of a sane df output for all this stuff is
> non-trivial, but in the long run I don't think expecting the user to
> figure it out is the best approach. I speak here as an interested
> sysadmin who quite enjoys rough edges... but for a lot of users the
> primary thing they want to know about their storage is "how much space
> do I have left".

For a lot of sysadmins too, I'd venture.  Certainly so if one uses a 
literal definition of sysadmin, one who administers a system and 
(possibly in cooperation with others in the family, etc) makes all the 
decisions not made at the distro level or above, as opposed to the 
narrower corporate definition.  In many cases they take what the distro 
provides and know little about Linux' workings, themselves, nor do they 
care, except that it "just works".

> The documentation does do a good job of pointing out the problems and
> explaining why free space is a tricky concept. But does "tricky"
> /really/ mean "impossible", or is it just "this is a nice to have thing
> that we'll figure out once the core filesystem functions are stable"?

In the traditional sense of df, I guess it really /is/ impossible, yes. 
at least for the as yet unallocated areas of the device, because there 
really is no way of predicting how that area will be used.

However, I'd argue that the current btrfs fi df display can never-the-
less be made far more informative than it is.  Btrfs knows much more 
about the current allocation than it lists, and unallocated could be 
split out as a separate line like so:

Unallocated space, future allocation unknown: xxx.xx GB

And per-device and total information would be nice...

I'd say the btrfs fi df output, perhaps with a --detail option, 
definitely needs improvement if btrfs is ever to get as widespread 
utilization as its presumptive position as ext* successor suggests.  
However, as you said, to a large extent that's work for down the line, 
since for instance raid5/6 mode just got mainlined, so big features that 
would need serious btrfs fi df output changes to account for them if it 
were much more detailed are still being added.

But just the addition of an unallocated space line would be an 
improvement, and something that could be added immediately.  Similarly, 
at least the per-device output from btrfs fi show could be added as well, 
displaying the info for both commands together.  That would be an 
improvement and could be done immediately as well.

(Of course good sysadmins can easily hack up a script that presents the 
current information as they'd prefer to see it, and writing this makes me 
inclined to do just that, but that's beyond the level of some... Altho 
arguably the same "some" shouldn't be using the after all still 
experimental btrfs at this point anyway, but...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

