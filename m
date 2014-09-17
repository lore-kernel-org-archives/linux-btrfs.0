Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42102 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295AbaIQUHz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 16:07:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XULW2-0004t6-UG
	for linux-btrfs@vger.kernel.org; Wed, 17 Sep 2014 22:07:50 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Sep 2014 22:07:50 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Sep 2014 22:07:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Problem with unmountable filesystem.
Date: Wed, 17 Sep 2014 20:07:34 +0000 (UTC)
Message-ID: <pan$7ad6e$263e56a5$f2bf0e6d$c264643b@cox.net>
References: <54184BD2.7000300@gmail.com>
	<2A2CB71A-7516-43CD-94E1-BCB2198F5FC4@colorremedies.com>
	<54196F42.4030101@gmail.com>
	<22B49628-3659-4D83-BE99-A173CAFF23F9@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Wed, 17 Sep 2014 12:57:59 -0600 as excerpted:

> But I think you're onto something, that a good superblock can point to a
> corrupt tree root, and then not have a straight forward way to mount the
> good tree root. If I understand this correctly.

This is what I ran into myself a couple months ago.

I ended up doing a restore as the simplest recovery I could do, then 
recreated the affected filesystems.  It happened on two  filesystems 
(separate, I don't trust subvolumes precisely because it's the same 
filesystem underneath and that's too many eggs in one basket for my 
comfort), /var/log and /home.  I was able to restore nearly all of /home 
(enough that I wasn't aware of anything missing except symlinks that 
restore doesn't work with), but lost about half of /var/log, which I did 
first and made a couple mistakes on that I didn't repeat on /home.

I figured there was a way to fix the filesystems as they were, but these 
threads about deliberately corrupting the first superblock in ordered to 
use the others hadn't appeared yet, and between restore and backups I got 
enough back not to be worried about the rest, so restore was "good 
enough".

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

