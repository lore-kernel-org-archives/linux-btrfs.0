Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35125 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836AbaHVHf4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 03:35:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XKjO7-0006gU-02
	for linux-btrfs@vger.kernel.org; Fri, 22 Aug 2014 09:35:55 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 09:35:54 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 09:35:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Significance of high number of mails on this list?
Date: Fri, 22 Aug 2014 07:35:40 +0000 (UTC)
Message-ID: <pan$258d1$c3749601$d83e6a85$e56acf7f@cox.net>
References: <CAH-HCWVZPNkc7ycsL4jH0i6niVU3nqZiB2MLD6CfP85FckAg7g@mail.gmail.com>
	<2217061.yFV10mnZWq@merkaba>
	<CAH-HCWVxOA+NBD5ON_D2Np2mC6+PC=n5QCCc410pQC04X7VnxA@mail.gmail.com>
	<53F6E9B7.1040701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Konstantinos Skarlatos posted on Fri, 22 Aug 2014 09:56:55 +0300 as
excerpted:

> I would stay with rsync for a while, because there is always the
> possibility of a bug that corrupts both your primary filesystem and your
> backup one, or send propagating corruption from one filesystem to
> another (Or maybe I am too paranoid, it would be good if we could have
> the opinion of a btrfs developer on this)

No claim to be a dev, btrfs or otherwise, here, but I believe in this 
case you /are/ "being too paranoid."

Both btrfs send and receive only deal with data/metadata they know how to 
deal with.  If it's corrupt in some way or if they don't understand it, 
they don't send/write it, they fail.

IOW, if it works without error it's as guaranteed to be golden as these 
things get.  The problem is that it doesn't always work without error in 
the first place, sometimes it /does/ fail.  In that instance you can 
always try again as the existing data/metadata shouldn't be damaged, but 
if it keeps failing you may have to try something else, rsync, etc.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

