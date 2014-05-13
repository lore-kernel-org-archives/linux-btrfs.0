Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40717 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbaEMSG2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 May 2014 14:06:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WkH5v-0002Ch-EN
	for linux-btrfs@vger.kernel.org; Tue, 13 May 2014 20:06:27 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 13 May 2014 20:06:27 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 13 May 2014 20:06:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: -musage=>0 means always reporting relocation
Date: Tue, 13 May 2014 18:06:15 +0000 (UTC)
Message-ID: <pan$a3b8$51a4e271$bdd12d08$cc38c3c0@cox.net>
References: <201405111943.16913.russell@coker.com.au>
	<201405111952.43458.russell@coker.com.au>
	<536F852C.3000100@swiftspirit.co.za> <2427848.SjNntC7t9e@xev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Tue, 13 May 2014 17:57:00 +1000 as excerpted:

>> The pathological case is where you have a chunk that is 1% full and
>> *every* other in-use chunk on the device is 100% full. In that
>> situation, a balance will simply move that data into a new chunk (which
>> will only ever reach 1% full). Thus, all subsequent balances will
>> relocate that same data again to another new chunk.
> 
> In that pathological case surely the correct thing to do is to not move
> that chunk.  If moving a chunk doesn't achieve filesystem tuning goals
> (EG converting to a different RAID level) and doesn't result in a
> decrease of the number of chunks in use then surely there's no point to
> doing it.

But what balance and the resulting multi-chunk interactions does is 
complex enough, that in general it doesn't know whether it's going to 
decrease the number of chunks used until it actually goes thru the 
motions and tries it.  In theory, a "dry-run" option could be added, but 
it would still take near the same amount of time as it has to check the 
same stuff, just not do the rewrite, and potentially, tracking the dry-
run results would increase memory usage significantly.

Meanwhile, what if an admin is wanting to simply rewrite the data, to 
check the filesystem validity and renew the on-media signal strength to 
avoid bit-rot, defragging in the process?  That's a valid balance use-
case as that's what it actually does.

Someone mentioned trying to use scrub to check filesystem validity, and I 
said that was the wrong tool for the job as all it did was validate 
checksums; it didn't validate internal structure.  But balance obviously 
must validate that internal structure as well as checksums, as it's 
actually reading and rewriting, potentially the entire filesystem, as it 
goes.

So I'd say the correct thing to do *IS* to rewrite that chunk, because 
that's what balance *DOES*.  That it happens to consolidate chunks as it 
goes is one effect, certainly a good one, but it's not the only effect, 
and not rewriting chunks simply because there would be no consolidation 
would both seriously complexify things, and ignore the other reasons one 
might be running the balance.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

