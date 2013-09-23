Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51733 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab3IWJ35 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 05:29:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VO2Sp-0003hS-Uy
	for linux-btrfs@vger.kernel.org; Mon, 23 Sep 2013 11:29:55 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 11:29:55 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 11:29:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 0/9] enhance btrfs qgroup show command
Date: Mon, 23 Sep 2013 09:29:38 +0000 (UTC)
Message-ID: <pan$a3bb6$bcc83f63$430b22dd$bd36c43d@cox.net>
References: <50C068D4.6020105@cn.fujitsu.com>
	<loom.20130922T170658-776@post.gmane.org> <523F95C4.1080404@cn.fujitsu.com>
	<CAFfJ-R46gqeMOH3bKPPnghmPZ7CziTmYghXJhgOzEoQ_vTJ6Pw@mail.gmail.com>
	<523FA4EB.3060201@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wang Shilong posted on Mon, 23 Sep 2013 10:18:19 +0800 as excerpted:

> On 09/23/2013 09:53 AM, Dusty Mabe wrote:

>> There is one other thing I have noticed while playing around
>> with quota and qgroups. If I delete subvolumes I can manage to get some
>> of the qgroup information to be reported as a negative number. If you
>> are interested check out my steps at
>> http://dustymabe.com/2013/09/22/btrfs-how-big-are-my-snapshots/ . The
>> system I was using was Fedora 19 (so not the latest stuff so this may
>> be a known issue already).

> I will take a look at this issue.

FWIW, I remember seeing discussion of the negative qgroup numbers on-
list, but as I don't use quotas I didn't track resolution.   So it should 
indeed be a known issue, but I'm not sure if it's fixed or someone's at 
least working on it yet or not.

But that might give you a duplicating instance if you need one, anyway.  
(Unless of course Dusty reported it earlier too and that's what I'm 
remembering.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

