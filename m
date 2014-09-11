Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40716 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbaIKXvj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 19:51:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XSE9J-0002DV-Mb
	for linux-btrfs@vger.kernel.org; Fri, 12 Sep 2014 01:51:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 01:51:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 01:51:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: how long should "btrfs device delete missing ..."  take?
Date: Thu, 11 Sep 2014 23:51:26 +0000 (UTC)
Message-ID: <pan$a2cc2$dc8ad02$d35780a0$4fefc791@cox.net>
References: <84a98bc5f667c04ca74ff77b56f537d9@admin.virtall.com>
	<pan$2d5ba$86c3ebd8$b81abab$13e892ea@cox.net>
	<4A9B52AD-8104-4C31-9BA4-13D329D2F952@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 11 Sep 2014 15:25:51 -0600 as excerpted:

> On Sep 11, 2014, at 1:31 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> 
>> I wouldn't try defragging now, but it might be worthwhile to stop the
>> device delete (rebooting to do so since I don't think there's a cancel)
> 
> 'btrfs replace cancel' does exist, although I haven't tried it.

Btrfs replace cancel exists, yes, but does it work for btrfs device 
delete, which is what the OP used?

> Something isn't right though, because it's clearly neither reading nor
> writing at anywhere close to 1/2 the drive read throughput. I'm curious
> what 'iotop -d30 -o' shows (during the replace, before cancel), which
> should be pretty consistent by averaging 30 seconds worth of io. And
> then try 'iotop -d3 -o' and see if there are spikes. I'm willing to bet
> there's a lot of nothing going on, with occasional spikes, rather than a
> constant trickle.
> 
> And then the question is to find out what btrfs is thinking about while
> nothing is reading or writing. Even though it's not 5000+ snapshots, I
> wonder if the balance code (and hence btrfs replace) makes extensive use
> of fiemap that's causing this to go catatonic.
> http://comments.gmane.org/gmane.comp.file-systems.btrfs/35724

Not sure (some of that stuff's beyond me), but one thing we /do/ know is 
that btrfs has so far been focused mostly on features and debugging, not 
on optimization beyond the worst-cases, which themselves remain a big 
enough problem, tho it's slowly getting better.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

