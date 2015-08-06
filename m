Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60105 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbbHFHXr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Aug 2015 03:23:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZNFWb-0001nI-GG
	for linux-btrfs@vger.kernel.org; Thu, 06 Aug 2015 09:23:37 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Aug 2015 09:23:37 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Aug 2015 09:23:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Why subvolume and not just volume?
Date: Thu, 6 Aug 2015 07:23:30 +0000 (UTC)
Message-ID: <pan$26b5e$81e797b6$ee8aa3f0$e575c51a@cox.net>
References: <CAK4jXzy8OpRMnF=hYEamZVxiumH9Xn_8uDo_xOQhYfLf3cA9dA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin posted on Wed, 05 Aug 2015 09:06:40 +0200 as excerpted:

> [W]hat is the penalty of a subvolume compared to a directory? From a
> design perspective, couldn't all directories just be subvolumes?

In addition to the performance issues mentioned by others, there's at 
least one further practical reason as well.

Snapshots stop at subvolume boundaries.  It's thus quite useful to use 
subvolumes to delineate the limits of the snapshot, saying, in effect, 
snapshot this dir (which happens to be a subvol not just a normal dir) 
recursively, but don't snapshot the subtree starting with this nested 
subdir (which again is a (different) subvol).

Subvols act very much like directories, it is true.  But they have a few 
additional properties and different behaviors, and it is the distinction 
between directories and subvols that makes them valuable /as/ subvols.  
Without a distinction, the whole reason to have subvols as a separate 
feature vanishes.

(FWIW, the first systemd release, v219, to use btrfs subvolume in place 
of directories found out some of the behavior differences the hard way.  
Where it was previously doing mkdir, which returns success if the 
directory is already there, critical for a root filesystem keep read-only 
mounted by default, but with the required directories already created, on 
btrfs it tried to create a subvolume instead, which fails if there's a 
directory already there, particularly if it's a read-only mount.  So the 
behavior creating a subvol differs from that of creating a subdir, and 
systemd's tmpfiles service was failing on read-only btrfs mounts as a 
result, while it previously succeeded, when it was only trying to create 
directories, which already existed.  Oops!  The bug was fixed in v221, 
but the experience does illustrate that while subvolumes behave in /many/ 
ways like subdirs, there are indeed small differences in behavior that 
can leap up and bite the unwary.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

