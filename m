Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53171 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab3KVRxB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 12:53:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VjuuV-0008Hu-M6
	for linux-btrfs@vger.kernel.org; Fri, 22 Nov 2013 18:52:55 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 18:52:55 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 18:52:55 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Nagios probe for btrfs RAID status?
Date: Fri, 22 Nov 2013 17:52:35 +0000 (UTC)
Message-ID: <pan$aedd2$55675d23$87b751ab$aaf09e6d@cox.net>
References: <528F6085.4020603@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Daniel Pocock posted on Fri, 22 Nov 2013 14:47:49 +0100 as excerpted:

> I just did a search and couldn't find any probe for btrfs RAID status
> 
> The "check_raid" plugin seems to recognise mdadm and various other types
> of RAID but not btrfs
> 
> Has anybody seen a plugin for Nagios or could anybody comment on how it
> should work if somebody wants to make one?
> 
> For example, would the command
> 
>     btrfs filesystem show --all-devices
> 
> give a non-zero error status or some other clue if any of the devices
> are at risk?

[btrfs personal user/sysadmin, not a dev, not anything large enough to 
have personal nagios experience...]

AFAIK, btrfs raid modes currently switch the filesystem to read-only on 
any device-drop error.  That has been deemed the simplest/safest policy 
during development, tho at some point as stable approaches the behavior 
could theoretically be made optional.

So detection could watch for read-only and act accordingly, either 
switching back to read-write or rebooting or simply logging the event, as 
deemed appropriate.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

