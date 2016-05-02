Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42795 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbcEBAXN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 May 2016 20:23:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ax1dm-0003dg-Fp
	for linux-btrfs@vger.kernel.org; Mon, 02 May 2016 02:23:10 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 02:23:10 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 02:23:10 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: commands like "du", "df", and "btrfs fs sync" hang
Date: Mon, 2 May 2016 00:23:02 +0000 (UTC)
Message-ID: <pan$39a32$2b46fbc1$6cec1$390d6a91@cox.net>
References: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
	<pan$1c3f$713ccc59$ba5354e3$ceefdfd6@cox.net>
	<20160501185418.5a148cdd@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Sun, 01 May 2016 18:54:18 +0200 as excerpted:

> I didn't now about smart-live-rebuild. Interesting. ;-)

Yeah.  I didn't know about it until a few years ago, either, including 
when I first setup kde4-live, tho at that point I was doing the stable-
branch live, not master live, so there were fewer changes.  But I was 
relying only on ccache to speed things up and rebuilding all my live 
packages at every update, at the time.

Once I saw mention of smart-live-rebuild, however, and tried it, I soon 
switched to live-master, and ran it in the kde4 era for a couple years 
until development on kde4 nearly stopped as they focused on the 
frameworks5-based versions.  Then I waited until an actual frameworks5-
based plasma in /release/ versions would install and work for me, before 
working on eliminating the deps for features I wasn't going to use 
anyway, and then finally switching again to now frameworks5-based live-
git versions, only recently.  Only this time I skipped the beta release 
step and the stable-branch step and went directly from working release to 
live-git-master.

But smart-live-rebuild *definitely* makes it easier, as do my helper 
scripts that let me easily follow git logs for every package, and even do 
git bisects when necessary, without having to manually switch into the 
package's git dir first. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

