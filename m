Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48517 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbcD0LDw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 07:03:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1avNG2-0001dO-Ji
	for linux-btrfs@vger.kernel.org; Wed, 27 Apr 2016 13:03:50 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Apr 2016 13:03:50 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Apr 2016 13:03:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: empty disk reports full
Date: Wed, 27 Apr 2016 11:03:42 +0000 (UTC)
Message-ID: <pan$3f1aa$2c4fda9$62d32937$323cb4c7@cox.net>
References: <2879842.8EgedBzSUf@anv.localdomain>
	<2288281.DWWvr4SJAK@anv.localdomain>
	<CAJCQCtTdL-AxGRpW3ZmGr4weYz3BUks0FR0NLmV-hsR88tNwvw@mail.gmail.com>
	<17848457.cMlg96Ju9J@anv.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alejandro Vargas posted on Wed, 27 Apr 2016 11:29:31 +0200 as excerpted:

>> Also there are two compress mount options that conflict with each
>> other, is this intentional?
> 
> I did not thought that compress and compress-force are incompatible...
> The intention is to force it to compress the data for using lower disk
> space. Compress-force should be enough?

Yes.  Compress-force simply forces the compression instead of quick-
testing whether the file seems easily/effectively compressed first (tho I 
think it still tests compressed block size and stores it uncompressed if 
the "compressed" block is actually larger, I don't believe it forces 
"compression" in /that/ case).  It will result in better compression when 
the first 4k (I believe that's what the quick-test tests on) of a file 
doesn't compress well but much of the rest will.

The problem with having both compress and compress-force in mount options 
is that I believe it's order-dependent which one ends up being applied, 
and unless you're a mount options guru, remembering whether it's the 
first or the last one that gets applied, or a special case where one 
overrules the other, is hard.  So it's best just to use just the option 
you want and not confuse people, at least others trying to make sense of 
things even if you yourself know which one gets applied, with both.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

