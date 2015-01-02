Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51991 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbbABDrb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Jan 2015 22:47:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y6tCy-0004NT-LQ
	for linux-btrfs@vger.kernel.org; Fri, 02 Jan 2015 04:47:28 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Jan 2015 04:47:28 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Jan 2015 04:47:28 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: I need to P. are we almost there yet?
Date: Fri, 2 Jan 2015 03:47:12 +0000 (UTC)
Message-ID: <pan$8f373$6f6405c7$92ea23ac$7a5fdcf1@cox.net>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
	<54A3633C.3040609@ubuntu.com>
	<1da0cf9a75a357c960af323aa56c7530.squirrel@webmail.wanet.net>
	<2740386.L6W23cCsJO@quad> <m849ng$lcg$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roger Binns posted on Thu, 01 Jan 2015 12:12:31 -0800 as excerpted:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 12/31/2014 05:26 PM, Chris Samuel wrote:
>> I suspect this is a knock-on effect of the fact that (unless this has
>> changed recently & IIRC) RAID-1 with btrfs will only mirrors data over
>> two drives, no matter how many you add to an array.

It hasn't changed yet, but now that raid56 support is basically complete 
(with 3.19, other than bugs of course, it'll be another kernel cycle or 
two before I'd rely on it), that's next up on the raid-features roadmap. 
=:^)

I know as that's my most hotly anticipated roadmapped btrfs feature yet 
to hit, and I've been waiting for it, patiently only because I didn't 
have much choice, for a couple years now.

> I wish btrfs wouldn't use the old school micro-managing storage
> terminology (or only as aliases) and instead let you set the goals. What
> people really mean is that they want their data to survive the failure
> of N drives - exactly how that is done doesn't matter.  It would also be
> nice to be settable as an xattr on files and directories.

Actually, a more flexible terminology has been discussed, and /might/ 
actually be introduced either along with or prior to the multi-way-
mirroring feature (depending on how long the latter takes to develop, I'd 
guess).  The suggested terminology would basically treat number of data 
strips, mirrors, parity, hot-spares, etc, each on its own separate axis, 
with parity levels ultimately extended well beyond 2 (aka raid6) as well 
-- I think to something like a dozen or 16.

Obviously if it's introduced before N-way-mirroring, N-way-parity, etc, 
it would only support the current feature set for now, and would just be 
a different way of configuring mkfs as well as displaying the current 
layouts in btrfs filesystem df and usage.

Hugo's the guy who has proposed that, and has been doing the preliminary 
patch development.

Meanwhile, ultimately the ability to configure all this at least by 
subvolume is planned, and once it's actually possible to set it on less 
than a full filesystem basis, setting it by individual xattr has been 
discussed as well.  I think the latter depends on the sorts of issues 
they run into in actual implementation.

Finally, btrfs is already taking the xattr/property route with this sort 
of attribute.  The basic infrastructure for that went in a couple kernel 
cycles ago, and can be seen and worked with using the btrfs property 
command.  So the basic property/xattr infrastructure is already there, 
and the ability to configure redundancy per subvolume already built into 
the original btrfs design and roadmapped altho it's not yet implemented, 
which means it's actually quite likely to eventually be configurable by 
file via xattr/properties as well -- emphasis on /eventually/, as these 
features /do/ tend to take rather longer to actually develop and 
stabilize than originally predicted.  The raid56 code is a good example, 
as it was originally slated for kernel cycle 3.6 or so, IIRC, but it took 
it over two years to cook and we're finally getting it in 3.19!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

