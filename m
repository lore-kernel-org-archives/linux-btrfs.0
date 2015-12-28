Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55437 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbbL1DQt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 22:16:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDOIh-0002IF-HY
	for linux-btrfs@vger.kernel.org; Mon, 28 Dec 2015 04:16:47 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 04:16:47 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 04:16:47 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [BUG?] btrfs scrub -d doesn't scan all devices
Date: Mon, 28 Dec 2015 03:16:41 +0000 (UTC)
Message-ID: <pan$5b580$699280fb$ded9f44b$b00968c3@cox.net>
References: <1451187536.6446.14.camel@scientia.net>
	<pan$bcf44$1632328c$31564c06$c04774a8@cox.net>
	<1451265688.6320.22.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Mon, 28 Dec 2015 02:21:28 +0100 as
excerpted:

> On Sun, 2015-12-27 at 07:22 +0000, Duncan wrote:
>> I'd call that NOTABUG.  As the btrfs-scrub manpage suggests:
>> 
>> * When you point scrub at a mountpoint, it scrubs all devices composing
>> that filesystem.

> Uhm,.. mine doesn't contain this,... neither do those of the master or
> devel branches from David's repo... or am I just blind?

I see that Chris Murphy just filed a bug on it with the particulars, but 
just to clear this up...

That's my paraphrase of what it says, thus the "suggests", but I do 
specifically quote, with "the manpage specifically says" and quote marks, 
so it's pretty hard to miss, which I /thought/, along with "suggests", 
should make it clear that I was NOT specifically quoting the manpage in 
the bullet-point.

Apparently not...

> Actually it says:
>>DESCRIPTION
>>       btrfs scrub is used to scrub a btrfs filesystem, which
>>       will read all data from all disks and verify checksums.

Look under scrub start...  as you did in a followup...

>> Since /dev/disk/by-*/* are symlinks to various block-device nodes, it
>> follows that if you point scrub at them, only the device pointed at is
>> scrubbed, exactly as one might expect based on the manpage.

> Sure... that was clear... but I have another manpage than yours...
> perhaps some distro specific patch?

No, just both a slightly more specific part of the manpage, under scrub 
start, and a mistake in believing "suggests" implies or explicitly 
specifies a direct quote, even when a direct quote is later actually 
made, complete with quotation marks and "the manpage specifically says" 
attribution.

btrfs-progs v4.3.1, if it matters.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

