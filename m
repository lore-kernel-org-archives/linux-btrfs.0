Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48823 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbaIPARE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 20:17:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XTgS6-0002IZ-QI
	for linux-btrfs@vger.kernel.org; Tue, 16 Sep 2014 02:17:02 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 02:17:02 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 02:17:02 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unable to mount, tools segfault
Date: Tue, 16 Sep 2014 00:16:51 +0000 (UTC)
Message-ID: <pan$ddd13$36ab58f1$bd748fc4$b576b26f@cox.net>
References: <CAPDSe6sip7UR3kge=aNedn6T1xhQmcEQHFCSm=JGDEibtRkOLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tony Murray posted on Mon, 15 Sep 2014 21:41:37 +0000 as excerpted:

> Pretty much all tools fail similarly.  Is there anyway to recover this? 
> I just spent several days getting this computer set up and would not
> like to spend that much time a second time.  If I could pull some files
> from the fs, that could speed up my reinstall siginificantly.

I don't have time to look at the detail ATM, but take a look at btrfs 
restore.  That allowed me to restore from a bad filesystem at one point.

Note that the filesystem won't be mounted and you'll be restoring the 
files to some other location.  File ownership and perms won't be 
restored, and symlinks aren't restored, but normal file data should be.

There's more on the wiki.  (Gotta run now...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

