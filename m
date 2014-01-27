Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43917 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaA0Iuc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 03:50:32 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W7htn-0008DH-Ou
	for linux-btrfs@vger.kernel.org; Mon, 27 Jan 2014 09:50:31 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 09:50:31 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 09:50:31 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: deleting files and qgroups
Date: Mon, 27 Jan 2014 08:50:06 +0000 (UTC)
Message-ID: <pan$37643$969fc17b$d862cdfc$854e4085@cox.net>
References: <6820542.RmHzTAgQHU@russell.coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Mon, 27 Jan 2014 18:59:16 +1100 as excerpted:

> As an aside, is it expected that a SE Linux Play Machine (with hostile
> "root" user) should survive with BTRFS?  I'm preparing a new Play
> Machine which will run BTRFS and use qgroups, are there any bugs or
> missing features I should be aware of?
> 
> I realise that qgroups are an area of BTRFS that hasn't been tested a
> lot and that using them to restrict actively hostile users is probably
> more experimental than most BTRFS stuff.  But I'm happy to get a broken
> system if we learn something useful.

While (as a btrfs user not dev) I don't use qgroups here, AFAIK, they 
have known bugs ATM and are not considered ready for primetime.  Among 
other infamous current bugs, deleting subvolumes with qgroups enabled can 
lead to negative quotas as that bit simply isn't managed properly at all!

At this point, therefore, I'd not only not recommend depending on qgroups 
at all, I'd recommend not even trying to test them unless you're actively 
working on the currently known bugs, as there's simply too much /known/ 
wrong with them ATM to sanely test, unless you're close enough to 
development to know what's a known bug that they're already working on 
fixing and what's not.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

