Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42581 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaA2RJA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 12:09:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W8YdH-0007rK-81
	for linux-btrfs@vger.kernel.org; Wed, 29 Jan 2014 18:08:59 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 18:08:59 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 18:08:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS corrupted by combination of mistreatment of hiberantion
 and accidental power loss.
Date: Wed, 29 Jan 2014 17:08:34 +0000 (UTC)
Message-ID: <pan$61221$cee0f38$2abb0854$b763409f@cox.net>
References: <52E91535.8090306@statystyka.net>
	<CAE5mzvhEMKBkJCzeB-NAAgdGjzidh9adkxF-ytW5K_vNZcxJOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cwillu posted on Wed, 29 Jan 2014 09:13:44 -0600 as excerpted:

> That said, have you tried mounting with -o recovery yet?  I wouldn't be
> surprised if btrfs-restore was also able to retrieve most of everything.
> Either way, I'd be suspicious of the filesystem, and would look to
> restore from backup to a fresh fs.

What he said, plus try mounting with the nospace_cache option.  I've had 
crashes kill that tree... only, and sometimes...  If that works, try 
clear_spacecache (not sure on the _s and I'm headed for work so look that 
bit up).



-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

