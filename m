Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47674 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbaCaVMJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 17:12:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WUjUb-0007dJ-PA
	for linux-btrfs@vger.kernel.org; Mon, 31 Mar 2014 23:11:41 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 23:11:41 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 23:11:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [Help] Errors found in extent allocation tree or chunk
 allocation
Date: Mon, 31 Mar 2014 21:10:08 +0000 (UTC)
Message-ID: <pan$774c7$e614b226$9647279d$10098a0d@cox.net>
References: <ac786c9023364c699d8212b42da536f2-mfwitten@gmail.com>
	<pan$6d267$8b0a867f$c580cca9$4eb55f7b@cox.net>
	<20b782af1cb448c39cce358cd6d37e8c-mfwitten@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael Witten posted on Mon, 31 Mar 2014 20:33:39 +0000 as excerpted:

> Just as an aside, I find it odd that the default for such a small system
> would be to duplicate user data.

I've wondered at that "logical accident" too, but the problem was that 
data chunks default to a gig in size and metadata to a quarter gig (but 
two chunks allocated at once since it's default-dup, so a half-gig).  
While allocations can and do get smaller to use the last bit of space 
left, at under a gig size, separate data/metadata blocks simply weren't 
flexible enough, and a shared data/metadata block type eliminated the 
separate data/metadata block flexibility issues at those tiny sizes.

Of course that did result in data being duped by default as well, since 
it was now sharing metadata chunks and metadata rules were applied to the 
shared chunks, but I guess that was figured to be the less bothersome 
problem, compared to the flexibility issues of separate data/metadata and 
the seriously increased risk of single metadata.

Of course one can specify single mode for shared/mixed too, if the extra 
metadata risk of just the single copy is considered less of an issue than 
the space usage of dup mode, but given the available tradeoffs, while I 
certainly appreciate the irony in the smallest btrfs being the only ones 
getting dup-data by default, I still agree with the choice and consider 
it the most sane one available for the general case, given the domain 
constraints they were working with.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

