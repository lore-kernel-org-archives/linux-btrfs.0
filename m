Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46219 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab3FXRyD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 13:54:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UrAxl-0007lP-Ij
	for linux-btrfs@vger.kernel.org; Mon, 24 Jun 2013 19:54:01 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jun 2013 19:54:01 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jun 2013 19:54:01 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: help: btrfs bad tree block start
Date: Mon, 24 Jun 2013 17:53:45 +0000 (UTC)
Message-ID: <pan$148b6$94cb1909$349c5f6c$33902e96@cox.net>
References: <CAK-xaQaP7-wvzd62GyydjJO2qeW3u9HGjE4Q9f013YpSmMV5vA@mail.gmail.com>
	<20130624162848.GK4288@localhost.localdomain>
	<CAK-xaQY3ZFTpreYdLjzz8-14tAbwSgdAMFNU4ijrksGHS6kSXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andrea Gelmini posted on Mon, 24 Jun 2013 18:45:39 +0200 as excerpted:

> 2013/6/24 Josef Bacik <jbacik@fusionio.com>:
>> Could you make an image of this fs for me and upload it somewhere so I
>> can pull it down and run some stuff on it?  I've
> 
> n.b.: I've got a lot of sensible/private data in my home, but maybe we
> could find a way to give all to you. I'm not so afraid to trust you.

FWIW, I just updated btrfs-progs from git, and one of the new commits 
allows anonymizing filenames (actual file data/content hasn't been in the 
image, which I believe is meta-data only, either ever or at least for 
some time, but filenames can be sensitive too).  There's even two 
different modes that can be used to do it, a fast "random name of the 
same length" mode, and a much, MUCH slower "find a crc32c hash collision 
of the same length and use it" mode.  (The commit noted that on new Intel 
hardware with hardware crc accel, it took two plus minutes to find a 
collision for a single text string, three-plus minutes without that 
hardware accel, so doing the math, on a filesystem with even moderate 
thousands of files, the long one's likely to take days to generate.  
Obviously this will only be used on relatively small filesystems 
troubleshooting problems where the fast method doesn't give a useful 
result.) 

So if you can build a current git btrfs-progs, you should be able to try 
at least the fast version, and reasonably anonymize even the filenames. 
=:^)

If filenames aren't a problem, then certainly anything even reasonably 
current should deliver an image with in-the-clear filenames, but no 
content to worry about.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

