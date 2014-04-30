Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54034 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933552AbaD3RZq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 13:25:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WfYGO-0004UM-NQ
	for linux-btrfs@vger.kernel.org; Wed, 30 Apr 2014 19:25:44 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 19:25:44 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 19:25:44 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 00/14] Enhanced df - followup
Date: Wed, 30 Apr 2014 17:25:32 +0000 (UTC)
Message-ID: <pan$c60c5$f81c6a24$3cc19892$c799d54a@cox.net>
References: <cover.1398786620.git.dsterba@suse.cz>
	<pan$274e8$4b1540e1$e4bc4fe0$2126c4cf@cox.net>
	<20140430130134.GL5988@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Wed, 30 Apr 2014 15:01:34 +0200 as excerpted:

> On Tue, Apr 29, 2014 at 05:10:31PM +0000, Duncan wrote:
>> To users familiar with Unix/POSIX/Linux CLI, "usage" (as --usage) is
>> most often seen as a rather less common and generally briefer form of
>> --help
> 
> I did a quick check of ~20 randomly chosen binaries in /usr/bin and none
> of them had --usage among options, unlike --help.

Yes, it wasn't nearly as common as I had the impression it was (I would 
have guessed about a third coverage, now it looks like a tenth at best), 
when I went to check, as well.  But I did find some.

> Though adding a command alias is trivial, I'd rather not do that right
> now. Let's see if we can live with 'btrfs fi us'. I worked for me during
> developing the patch series.

Actually, that suggests a nice, short, non-conflicting alternative, 
"use". =:^)

"Use" doesn't conflict with other (not-so) common usage like "usage", 
doesn't have the hard to type implications of a compound device_usage or 
the like, either, and is nice and short on its own. =:^)


Regardless, I don't feel particularly strongly about it, and as both you 
and I found, the other use of "usage" is less common than I had at first 
thought.  It might be slightly confusing here, that's all.  As others 
don't seem to have that problem I'm now happy either way and the existing 
patches use usage, so leaving them as they are is fine by me. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

