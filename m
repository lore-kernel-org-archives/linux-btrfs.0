Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55700 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbbL1Dar (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 22:30:47 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDOWC-0000LF-FC
	for linux-btrfs@vger.kernel.org; Mon, 28 Dec 2015 04:30:44 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 04:30:44 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 04:30:44 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [BUG?] btrfs scrub -d doesn't scan all devices
Date: Mon, 28 Dec 2015 03:30:39 +0000 (UTC)
Message-ID: <pan$145c6$d63bc79f$a86f946f$d4f01e2@cox.net>
References: <1451187536.6446.14.camel@scientia.net>
	<pan$bcf44$1632328c$31564c06$c04774a8@cox.net>
	<1451265688.6320.22.camel@scientia.net>
	<1451265937.6320.26.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Mon, 28 Dec 2015 02:25:37 +0100 as
excerpted:

>>> (The manpage specifically says "all devices of the filesystem
>>> identified by <path>".  Emphasis on _ALL_DEVICES_ if given a
>>> normal path.)

>>> (The manpage continues ... "or on a single <device>." Emphasis
>>> on _SINGLE_DEVICE_ if given a device node.)

> Just noted, mine says this:
>>Start a scrub on all devices of the filesystem identified by <path>
>>or on a single <device>. If a scrub is already running, the new one
>>fails.
> still not the text you quoted,... but there it is.

The text I directly quoted... with quotation marks and "the manpage 
specifically says", is in my quote above, added back in here and marked 
off as the third level quote.

The material within my quotation marks is found verbatim within your 
quote of the manpage.  So how is it not the text I quoted?

It's in quotation marks attributed with "the manpage specifically says", 
my own rewording is marked as the manpage _"suggests"_ (with the choice 
of "suggests" as opposed to "says" and quote marks rather strongly 
implying that part is _not_ a direct quote), how could I _possibly_ make 
it any clearer than that?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

