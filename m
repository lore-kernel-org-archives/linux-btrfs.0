Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53655 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbbAHKSm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Jan 2015 05:18:42 -0500
Received: from merkaba.localnet (ppp-88-217-110-99.dynamic.mnet-online.de [88.217.110.99])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 94DFA62C
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Jan 2015 11:17:29 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again (no complete lockups, "just" tasks stuck for some time)
Date: Thu, 08 Jan 2015 11:18:40 +0100
Message-ID: <27859486.yaddXGu9UI@merkaba>
In-Reply-To: <pan$75d3b$ee534480$97e113aa$a8796b2d@cox.net>
References: <3738341.y7uRQFcLJH@merkaba> <1499386.KVI6lPzt8j@merkaba> <pan$75d3b$ee534480$97e113aa$a8796b2d@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 8. Januar 2015, 05:45:56 schrieben Sie:
> Martin Steigerwald posted on Wed, 07 Jan 2015 20:08:50 +0100 as excerpted:
> > No BTRFS developers commented yet on this, neither in this thread nor in
> > the bug report at kernel.org I made.
> 
> Just a quick general note on this point...
> 
> There has in the past (and I believe referenced on the wiki) been dev 
> comment to the effect that on the list they tend to find particular 
> reports/threads and work on them until they find and either fix the issue 
> or (when not urgent) decide it must wait for something else, first.  
> During the time they're busy pursuing such a report, they don't read 
> others on the list very closely, and such list-only bug reports may thus 
> get dropped on the floor and never worked on.
> 
> The recommendation, then, is to report it to the list, and if not picked 
> up right away and you plan on being around in a few weeks/months when 
> they potentially get to it, file a bug on it, so it doesn't get dropped 
> on the floor.

Duncan, I *did* file a bug.

[Bug 90401] New: btrfs kworker thread uses up 100% of a Sandybridge core for 
minutes on random write into big file

https://bugzilla.kernel.org/show_bug.cgi?id=90401

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
