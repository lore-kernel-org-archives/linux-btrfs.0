Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49347 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbbELFgw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 01:36:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ys2s4-0004HB-VV
	for linux-btrfs@vger.kernel.org; Tue, 12 May 2015 07:36:49 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2015 07:36:48 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2015 07:36:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Are there plans for full btrfs filesystem backups?
Date: Tue, 12 May 2015 05:36:43 +0000 (UTC)
Message-ID: <pan$36707$3012e0dd$1583d9f5$5883c3f4@cox.net>
References: <20150510164944.GI16535@merlins.org>
	<pan$2bd31$990b002e$ebe891e2$76d0f14f@cox.net>
	<CAJCQCtTszNWB-XpBZs=Fah-J5NBsuOEbLC2pBFtFujUZnNWQ4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 10 May 2015 22:57:24 -0600 as excerpted:

> On Sun, May 10, 2015 at 9:55 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Marc MERLIN posted on Sun, 10 May 2015 09:49:44 -0700 as excerpted:
>>
>>> Are there any plans for a full filesystem send/receive, not just a
>>> subvolume send/receive?
>>
>> Recent discussion suggests yes, tho it's a relatively new plan.
>>
>> More specifically, the recent discussion seemed to settle around the
>> need for a send/receive --recursive option, which would recurse into
>> nested subvolumes.  IIRC, the systemd folks requested that for their
>> container management, among other things.
> 
> That was for snapshot creation and destruction, not send receive.

I believe that was it, yes.

But of course recursive snapshot creation/deletion would be a practical 
prerequisite to recursive send/receive, since in that case read-only 
snapshots would need to be created in ordered to be sent, and similarly 
created on the receive side to recreate the nested snapshot tree on the 
send side.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

