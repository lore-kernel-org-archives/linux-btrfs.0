Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34444 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbbDWDnu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 23:43:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yl83I-0001Xq-3n
	for linux-btrfs@vger.kernel.org; Thu, 23 Apr 2015 05:43:48 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 05:43:48 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 05:43:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs subvolume diff
Date: Thu, 23 Apr 2015 03:43:35 +0000 (UTC)
Message-ID: <pan$5278$86c57e90$b5f9efb5$e578b832@cox.net>
References: <201504221808.30242.thomas@koch.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thomas Koch posted on Wed, 22 Apr 2015 18:08:30 +0200 as excerpted:

> for incremental backups it would be useful to know the files that
> changed between two snapshots. I found a paper about such a tool[1] that
> adds the "btrfs subvolue diff" command, but it's not yet implemented in
> btrfs-tools in Debian Jessie.
> 
> Is it in Git? Or somewhere else?
> 
> [1] https://www.kernel.org/doc/ols/2014/ols2014-pimpale.pdf

[Note that I'm just a btrfs user and list regular, not a dev, and that my 
own use-case doesn't involve subvolumes, tho I played with them a bit 
when I first got into btrfs, so my practical subvolume management 
knowledge is limited.  But based on current git's manpages...]

The closest thing in git-master, based on my build from a few days ago, 
is btrfs subvolume find-new.  That lists the recently modified files 
since <generation>, where generation is fed to the command, with a 
subvolume's current generation obtainable btrfs subvolume list using its
-g option.  (btrfs subvolume show might also list current gen, the manpage 
is vague on what information it shows, and without local subvolumes to 
test it with...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

