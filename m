Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56534 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbbFASCF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Jun 2015 14:02:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YzU2F-0003nV-JV
	for linux-btrfs@vger.kernel.org; Mon, 01 Jun 2015 20:02:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 20:02:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 20:02:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: howto create subvolume at top level?
Date: Mon, 1 Jun 2015 18:01:58 +0000 (UTC)
Message-ID: <pan$2fa54$a3a0c7f9$fa61118f$2f8df70c@cox.net>
References: <mki4j1$vvo$1@ger.gmane.org>
	<pan$bc8b8$574d5213$341e3921$d2025f4a@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Mon, 01 Jun 2015 17:51:19 +0000 as excerpted:

>> This created home2 under root.  How do I create home2 with top level as
>> top level 5, at the same level as root?
>> 
>> IOW:
>> 
>> ID 257 gen 66376 top level 5 path root ID 316 gen 66376 top level 5
>> path home2
> 
> Briefly stated, you don't.  Just like / is the top of a Unix style
> directory tree, the root subvolume is the top of a btrfs subvolume tree.
> You can't go higher than that, and that's what the top level /is/.

OK, I see now, you already have a subvolume called root, that's not ID5, 
the root (aka top level ID5) subvolume.  Thus it's ID 257.  Fine 
distinction.

Calvin W is correct.  Mount the top level subvolume and create there.  
What you're doing now is actually what I suggested with the nesting, and 
your "root" subvolume <> the top-level ID5 subvolume.  I'll claim just 
waking up and not having my caffeine yet. =:^)



-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

