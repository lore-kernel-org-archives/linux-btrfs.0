Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41734 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbbCTEeZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 00:34:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YYodY-00040f-V2
	for linux-btrfs@vger.kernel.org; Fri, 20 Mar 2015 05:34:20 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 05:34:20 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 05:34:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: nube trying to backup my systems
Date: Fri, 20 Mar 2015 04:34:15 +0000 (UTC)
Message-ID: <pan$e1cc0$a6e97544$c3eaa670$f3bcb382@cox.net>
References: <550B5C63.6010401@comcast.net>
	<CAJCQCtRj6MWc=YzvEepjiZTQYrN7CKbO0EivotZNjS218Gz56Q@mail.gmail.com>
	<550B7CAC.6030005@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

don fisher posted on Thu, 19 Mar 2015 18:49:32 -0700 as excerpted:

> Any thoughts on stability of the IDs across boots?

Btrfs subvolIDs are a property of the btrfs and thus stable across boots.

(They're actually the root-tree ID, with ID=5 the main root tree for the 
entire filesystem, various other low-digit IDs being the root trees for 
various sets of filesystem metadata like the chunk tree and the free-
space tree, and IDs above 256 being subvolumes, with snapshots being a 
particular type of subvolume and thus having IDs above 256 as well.  Were 
these numbers to randomly change, therefore, btrfs would be in a world of 
hurt as it couldn't find various critical root trees it needs to parse in 
ordered to function!  So rest assured, if those numbers start changing 
and it's not because you deliberately decided to put a different subvolume 
there and forgot to change your fstab, it's a serious bug in btrfs!)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

