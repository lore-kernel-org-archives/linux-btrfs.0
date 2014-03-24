Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51240 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbaCXSi6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 14:38:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WS9lw-000856-HU
	for linux-btrfs@vger.kernel.org; Mon, 24 Mar 2014 19:38:56 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 19:38:56 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 19:38:56 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-tools missing "btrfs device delete devid=x path" ?
Date: Mon, 24 Mar 2014 18:38:30 +0000 (UTC)
Message-ID: <pan$5c9a9$34404310$3c11d99a$22bd163f@cox.net>
References: <20140323152516.GJ12833@merlins.org>
	<20140323161843.GD25400@carfax.org.uk>
	<20140323162506.GL12833@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 23 Mar 2014 09:25:06 -0700 as excerpted:

> On Sun, Mar 23, 2014 at 04:18:43PM +0000, Hugo Mills wrote:
>> On Sun, Mar 23, 2014 at 08:25:17AM -0700, Marc MERLIN wrote:
>>> 
>>> What's the syntax for removing a drive that isn't there?
>> 
>>    btrfs dev del missing /path
>> 
>>    Removes all the missing devices.
> 
> Aaah, this worked, thank you.
> This isn't documented in the 3.12 man page, but I'm guessing it'll be in
> the upcoming 3.14.
> 
> I'll document this in the raid5 page I'm currently writing.

It's on the wiki as I remembered, covered on the multiple devices page.

https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Removing_devices

(FWIW it's pretty safe to say that if it was in the wiki, at least in
the user docs section, I saw it before I ever did my first mkfs.btrfs,
as I pretty much scoured the wiki, then asked some questions not covered
there here as well, before I actually tried to use it.  Unlike some people
I actually tend to read the instructions before trying to use stuff I buy,
too. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

