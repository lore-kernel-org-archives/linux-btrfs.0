Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47398 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbaJUJuy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 05:50:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XgW5Z-0002VJ-V7
	for linux-btrfs@vger.kernel.org; Tue, 21 Oct 2014 11:50:49 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 11:50:49 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 11:50:49 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: strange 3.16.3 problem
Date: Tue, 21 Oct 2014 09:50:37 +0000 (UTC)
Message-ID: <pan$87a32$ab14c0c8$d31af00$391cbfd4@cox.net>
References: <201410181454.19375.russell@coker.com.au>
	<54426C16.5030206@pobox.com> <201410191041.42013.russell@coker.com.au>
	<54454858.8010802@pobox.com> <54456EB0.9020503@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Mon, 20 Oct 2014 22:21:04 +0200 as
excerpted:

> On 10/20/2014 07:37 PM, Robert White wrote:
>> On 10/18/2014 04:41 PM, Russell Coker wrote:
> [...]
>> Also you said that you are using a 32bit user space "copied from
>> another server" under a 64bit kernel. Is the "ls" command a 32 bit
>> executable then?
> 
> Could this be related to the inode overflow in 32 bit system (see
> inode_cache options) ? If so running a 64bit "ls -i" should work....

Good point.  Russell might just owe you a beverage of choice.  =:^)

The inode_cache mount option isn't recommended for any bitness.

@ Russ, are you mounting with inode_cache?  If so, definitely try running 
without it and see if it changes the results.

(FWIW I wish that mount option would just go away as it would definitely 
remove an invitation to a Russian roulette party with their data for the 
unwary, but I suppose there's someone paying some bills somewhere that 
wants it kept for some specific use-case where the performance gain must 
be worth the calculated risk, thus continuing that invitation to data 
Russian roulette for everyone else.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

