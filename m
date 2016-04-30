Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36054 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbcD3Ktv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Apr 2016 06:49:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1awST7-0008Cw-1k
	for linux-btrfs@vger.kernel.org; Sat, 30 Apr 2016 12:49:49 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Apr 2016 12:49:49 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Apr 2016 12:49:49 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: receive snapshot, complains about missing file
Date: Sat, 30 Apr 2016 10:49:34 +0000 (UTC)
Message-ID: <pan$e4ba4$a250943d$4b67b01a$4a6c9e1c@cox.net>
References: <CAGGqMYQPVQoKDcuDqp0D=3BCD+oTghew0fyzqo58BSLFrmrEJQ@mail.gmail.com>
	<CAJCQCtTG68BicgFwoyYgM0OzphsVbstgWTNybF3CeBo1VCJhNg@mail.gmail.com>
	<CAGGqMYTso0XNjgfmWfY8g3Xs9xym5gHFcTizzAq1_Y-mMTTx0w@mail.gmail.com>
	<CAJCQCtRk+V0vhdCsyi-3aoNDimV0E4XJjQc9Us35uO59HpjSAQ@mail.gmail.com>
	<CAGGqMYSZ8P=ZVSgL4zWJKi7uuYLxRMZh=XEzPYpT2PykQD58oQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexander Fougner posted on Sat, 30 Apr 2016 12:28:34 +0200 as excerpted:

>>>> Do scrub and btrfs check (no repair) complete without errors?
> 
> Send side
> 
> sudo btrfs check /dev/sda1
> Checking filesystem on /dev/sda1

[... but no errors]

> Receive side only outputs this:
> sudo btrfs check -p /dev/sdc
> Couldn't open file system

It wasn't mounted at the time, right?

Cuz btrfs check won't work with a mounted filesystem.

Of course you'll need to be root to access the device as well,
but that's pretty much a given.


> Scrub completes without errors on both FS.

That's good. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

