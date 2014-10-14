Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32774 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaJNWfe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 18:35:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XeAgj-0000Ua-V5
	for linux-btrfs@vger.kernel.org; Wed, 15 Oct 2014 00:35:29 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 00:35:29 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 00:35:29 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Random file system corruption in 3.17 (not BTRFS related...?)
Date: Tue, 14 Oct 2014 22:35:14 +0000 (UTC)
Message-ID: <pan$ce890$598bb3af$d0bcd705$e79f1b9b@cox.net>
References: <543D555B.50708@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Tue, 14 Oct 2014 09:54:51 -0700 as excerpted:

> On the BTRFS system much of my browser settings for firefox were
> trashed, particularly the cookies and saved conifigurations for add-ons
> (like which sites had scripts enabled/disabled in no-script) etc.

FWIW, this reply is more toward the firefox corruption than the
why-particulars of the crash.

The prefs.js file in the profile dir holds addon settings and seems to be 
particularly sensitive to corruption.  At least here, firefox has created 
several backups, prefs-1.js thru prefs-7.js, I suppose at upgrade.  The 
first time I lost settings I restored prefs-7.js (the newest/largest of 
the backups) as prefs.js, and only lost a few settings that I had changed 
since the last upgrade, which had changed the firefox interface so I had 
to change my settings accordingly.  The time or two since then that I 
hard-crashed and lost my addons, I was able to replace the prefs.js file 
from a recent /home backup.

Anyway, it's the prefs.js file that you want to restore.  Whether it's 
from the last prefs-N.js backup that firefox did, or from your own 
backup, prefs.js is it.

As for cookies, history, etc.  I didn't notice them going corrupt.  I do 
run raid1 btrfs and after a crash, do a scrub, which may recover some 
files.  And I run tight enough security that most cookies are session-
only (and no third-party), so that file won't be written to much, which 
probably saves it.  I don't know about history.  Maybe it was corrupted 
and I simply didn't notice it, as I don't use history that often.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

