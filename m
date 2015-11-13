Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56129 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbbKMXxW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 18:53:22 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZxO9f-0000ID-I8
	for linux-btrfs@vger.kernel.org; Sat, 14 Nov 2015 00:53:19 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2015 00:53:19 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2015 00:53:19 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: illegal snapshot, cannot be deleted
Date: Fri, 13 Nov 2015 23:53:07 +0000 (UTC)
Message-ID: <pan$b6f6$b48b3e9f$e7ad9f7$2f6462b7@cox.net>
References: <CAHTEL3=r8kUJOU=xUAg2iG52HuWmqQ16QxUjY6d+zqbziW5+gw@mail.gmail.com>
	<564486F3.5020804@gmail.com>
	<CAHTEL3mEGmc5BhbGMEAbyPNU90nFQGZprLkWrh1WaEh5sSiH8w@mail.gmail.com>
	<56461034.3070209@gmail.com>
	<CAHTEL3m0uGWZGWUH_SLmg8TqMe4DcXU77p+S=4Aebukr1BZ-Bg@mail.gmail.com>
	<56462784.2060601@gmail.com> <20151113184227.GF24333@carfax.org.uk>
	<56463CBC.70808@gmail.com> <20151113195520.GG24333@carfax.org.uk>
	<pan$38813$161f71be$a3fa4155$7377d9e9@cox.net>
	<20151113211341.GH24333@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Fri, 13 Nov 2015 21:13:41 +0000 as excerpted:

> On Fri, Nov 13, 2015 at 09:11:46PM +0000, Duncan wrote:
>> Hugo Mills posted on Fri, 13 Nov 2015 19:55:20 +0000 as excerpted:
>> 
>> > receive is implemented almost exclusively in userspace, with only a
>> > couple of ioctls for mucking around with the UUIDs at the end.
>> 
>> I wasn't aware of that and had assumed kernel space.  Apart from the
>> topic of discussion here, that has implications for the old "how old is
>> too old" versioning question regarding userspace, so thanks, Hugo. =:^)
> 
> Note that send is still heavily kernel-side. It's only receive
> that's all in userspace.

Being "runtime", send's kernel-side use would be expected.

The more general rule that runtime operations are kernel side, so user 
side versioning doesn't have the same importance, unless you're trying to 
use userside tools such as check, rescue and recover, generally run on an 
unmounted btrfs, to recover from damage, since in the general case that's 
where userspace code really goes to work and thus where it's version 
becomes important.

That the receive side of the send/receive feature is an exception to this 
general rule is the news, since now we have a runtime tool, normally run 
on a mounted btrfs, where the userspace code is doing the work and 
therefore the userspace version, newer versions having the latest fixes, 
becomes important.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

