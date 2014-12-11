Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43943 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964919AbaLKIQm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 03:16:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XyyvQ-0004gD-NF
	for linux-btrfs@vger.kernel.org; Thu, 11 Dec 2014 09:16:40 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 09:16:40 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 09:16:40 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: out of space warning?
Date: Thu, 11 Dec 2014 08:16:28 +0000 (UTC)
Message-ID: <pan$6aed4$da742710$2d9d1dc2$995131a9@cox.net>
References: <CAAe=sHXGpiZN5hKmzv1ynY8x=rH9tMvx86HZP2veLRpAFJN+wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sys.syphus posted on Wed, 10 Dec 2014 16:54:07 -0600 as excerpted:

> I would like to avoid running out of space. is there a way to know that
> I am getting close? i'd like to make a script that runs as part of my
> bash prompt and lets me know when i am getting close. i know there are
> several ways you can run out of space and I'd like to avoid all of them.

With the concerns about your bash prompt registered...

btrfs filesystem show

... is a good choice.

If you have multiple filesystems you can point show at a device/
mountpoint/label/UUID to get the output for just the one.

You'll want to pay particular attention to the individual device lines.  
Of course you can grep/sed/otherwise-process that down to a single line 
if desired.

If btrfs filesystem show says it's close to out of room, run btrfs 
filesystem df for more info.  There's lots of information on the wiki and 
in various threads here about interpreting the information these commands 
output (it takes both commands to get a good picture, but show is good 
for brief summary, provided you know to look at the device lines not the 
overall total line), and what to do when necessary to return some balance 
to the situation.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

