Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48200 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbcEQGjX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 02:39:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b2Yf3-00075j-6K
	for linux-btrfs@vger.kernel.org; Tue, 17 May 2016 08:39:21 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 08:39:21 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 08:39:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scrub status regression (repost kinda)
Date: Tue, 17 May 2016 06:39:13 +0000 (UTC)
Message-ID: <pan$6d12d$fd423a5a$1e7bec76$feebee26@cox.net>
References: <loom.20160517T032830-349@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

al posted on Tue, 17 May 2016 01:40:19 +0000 as excerpted:

> I'm still getting this regression on scrub. Scrub status no longer
> reports the progress of the scrub. It always used to.
> 
> The scrub itself proceeds normally and using '-B' returns the usual and
> complete output.
> 
> # btrfs scrub start /
> scrub started on /, fsid fdd6a335-6edf-4a74-a909-03c8102cc8f5 (pid=4111)
> 
> <reasonable time passes>
> 
> # btrfs scrub status /
> scrub status for fdd6a335-6edf-4a74-a909-03c8102cc8f5
> 	no stats available total bytes scrubbed: 0.00B with 0 errors


That's almost certainly due to the state of the location where btrfs 
stores scrub status information, /var/lib/btrfs, which should be a 
directory that's both writable by btrfs during the scrub, and readable at 
the time btrfs scrub status is run.

It appears that (as expected for such commands) you're running btrfs as 
root, so normal file permissions shouldn't matter.

However, if you have that filesystem mounted read-only at the time, or if 
you or your distro has configured additional security restrictions like 
SE Linux and they're preventing access to that dir, that would explain 
the problem.

Additionally, I'm not sure whether btrfs scrub will create that directory 
(and its parents /var/lib and /var) dynamically if needed, or if the 
package is supposed to do that at installation, so btrfs scrub itself 
doesn't do it.  In the latter case, if the directory simply doesn't 
exist, that would prevent the status files from being written, and thus 
read, as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

