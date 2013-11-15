Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55403 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab3KOJhx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 04:37:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VhFqZ-00039o-1Q
	for linux-btrfs@vger.kernel.org; Fri, 15 Nov 2013 10:37:51 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 10:37:51 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 10:37:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Mixed and raid [was Re: BUG: btrfsRe: Does btrfs "raid1"
 actually provide any resilience?]
Date: Fri, 15 Nov 2013 09:37:30 +0000 (UTC)
Message-ID: <pan$58137$7ab22078$cda28ab5$22b51eac@cox.net>
References: <l62akc$ujc$1@ger.gmane.org> <528514CA.8080903@libero.it>
	<528536F7.6030503@libero.it> <52853ED2.8040606@libero.it>
	<pan$afa55$861f820e$b8e2b567$4f5d324c@cox.net>
	<5285CDA9.3020208@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Fri, 15 Nov 2013 08:30:49 +0100 as
excerpted:

> On 2013-11-15 08:12, Duncan wrote:
>> 
> [...]
>> 
>> You're saying data+metadata DUP wouldn't be possible here either, which
>> would make me pretty unhappy too.
> 
> The problem should be in mkfs.btrfs not in the btrfs kernel code. So if
> the filesystem was created, there should be not problem.

Yes.  Thanks.

>> Fortunately I did those mkfs.btrfs on an earlier btrfs-tools so wasn't
>> affected by this bug, but bug I would indeed call it, for sure!
> 
> Anand posted a patch few hours ago (which worked for me). I think that
> this bug could be addressed quickly.

His patch crossed with my reply.  Quick work, indeed!  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

