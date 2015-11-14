Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34973 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbbKNQgB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Nov 2015 11:36:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zxdnz-0003be-QI
	for linux-btrfs@vger.kernel.org; Sat, 14 Nov 2015 17:35:59 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2015 17:35:59 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2015 17:35:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Using Btrfs on single drives
Date: Sat, 14 Nov 2015 16:35:53 +0000 (UTC)
Message-ID: <pan$cd520$db285952$21230473$ba4e939d@cox.net>
References: <CA+LE0jwrdpjmJhwmG9Yv5HjqZh28-yp3Man8NSmXqCoB=JJ=Ew@mail.gmail.com>
	<56471661.6020101@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Sat, 14 Nov 2015 12:09:21 +0100 as
excerpted:

> On 2015-11-14 11:43, audio muze wrote:
>> I can turn checksumming off given it's of no utility where a Btrfs
>> volume is comprised of a single device only?
> 
> The checksums are used to detect a data corruption; in case of a
> btrfs-raid, the checksums are used *also* to pick the good copy.

And yes, you can turn them off (for data, not metadata), using the 
nodatasum mount option.

Tho personally, I prefer raid1, not just for the normal raid1 capacities, 
but for the ability to scrub corrupt data as well, and thus would never 
turn off checksumming here (except possibly in the context of nocow, for 
vm images, etc).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

