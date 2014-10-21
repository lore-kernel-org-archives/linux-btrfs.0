Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43922 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaJUJ3j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 05:29:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XgVl3-0008Ay-Dq
	for linux-btrfs@vger.kernel.org; Tue, 21 Oct 2014 11:29:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 11:29:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 11:29:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Poll: time to switch skinny-metadata on by default?
Date: Tue, 21 Oct 2014 09:29:25 +0000 (UTC)
Message-ID: <pan$32992$bbc3a80d$ad912ad2$31fcc5ce@cox.net>
References: <20141016113337.GC22943@twin.jikos.cz>
	<20141020163403.GW22943@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Mon, 20 Oct 2014 18:34:03 +0200 as excerpted:

> On Thu, Oct 16, 2014 at 01:33:37PM +0200, David Sterba wrote:
>> I'd like to make it default with the 3.17 release of btrfs-progs.
>> Please let me know if you have objections.
> 
> For the record, 3.17 will not change the defaults. The timing of the
> poll was very bad to get enough feedback before the release. Let's keep
> it open for now.

FWIW my own results agree with yours, I've had no problem with skinny-
metadata here, and it has been my default now for a couple backup-and-new-
mkfs.btrfs generations, now.

As you know there were some problems with it in the first kernel cycle or 
two after it was introduced as an option, and I waited awhile until they 
died down before trying it here, but as I said, no problems since I 
switched it on, and I've been running it awhile now.

So defaulting to skinny-metadata looks good from here. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

