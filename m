Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46033 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbcEQUbF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 16:31:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b2ldv-0008I6-9B
	for linux-btrfs@vger.kernel.org; Tue, 17 May 2016 22:31:03 +0200
Received: from 87-127-16-100.static.enta.net ([87.127.16.100])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 22:31:03 +0200
Received: from 6401e46d by 87-127-16-100.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 22:31:03 +0200
To: linux-btrfs@vger.kernel.org
From: al <6401e46d@opayq.com>
Subject: [SOLVED] Re: Scrub status regression (repost kinda)
Date: Tue, 17 May 2016 20:30:57 +0000 (UTC)
Message-ID: <loom.20160517T220619-555@post.gmane.org>
References: <loom.20160517T032830-349@post.gmane.org> <pan$6d12d$fd423a5a$1e7bec76$feebee26@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:

> That's almost certainly due to the state of the location where btrfs 
> stores scrub status information, /var/lib/btrfs, which should be a 
> directory that's both writable by btrfs during the scrub, and readable at 
> the time btrfs scrub status is run.
> 
> It appears that (as expected for such commands) you're running btrfs as 
> root, so normal file permissions shouldn't matter.
> 
> However, if you have that filesystem mounted read-only at the time, or if 
> you or your distro has configured additional security restrictions like 
> SE Linux and they're preventing access to that dir, that would explain 
> the problem.
> 
> Additionally, I'm not sure whether btrfs scrub will create that directory 
> (and its parents /var/lib and /var) dynamically if needed, or if the 
> package is supposed to do that at installation, so btrfs scrub itself 
> doesn't do it.  In the latter case, if the directory simply doesn't 
> exist, that would prevent the status files from being written, and thus 
> read, as well.




Thank you, sir, for taking the time to post at length.

The (need to) repost gives it away as something I'd done/not done; rather
than a generic problem.

I think I've always run some btrfs commands as root, because they've not
allowed themselves to run with lower priv. It sounds to me like I have
hamstrung myself somewhere/somewhat as the directory is only for root user
(only).

$ la /var/lib/btrfs
total 8.0K
-rw------- 1 root root  360 Jan 26 11:45
scrub.status.caf3bccc-6061-44bc-9726-96a87cfdb9eb
-rw------- 1 root root 1.4K May 17 02:12
scrub.status.fdd6a335-6edf-4a74-a909-03c8102cc8f5

The two files represent two file systems scrubbed (a RAID6 4device and a DUP
single). Both are effectively 'zero'.

So it only remains to go find the directory correct permissions and if the
directory is recreated. I'll come crying back if I can't find it!

Been running btrfs from quite early on, early linux three I think, and have
only had it self-implode once. Every other problem has been of my own making
I think: damn you 'dd'.

