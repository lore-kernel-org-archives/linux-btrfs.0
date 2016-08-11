Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53677 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbcHKTNo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Aug 2016 15:13:44 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bXvQD-0007qA-VS
	for linux-btrfs@vger.kernel.org; Thu, 11 Aug 2016 21:13:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs quota issues
Date: Thu, 11 Aug 2016 19:13:35 +0000 (UTC)
Message-ID: <pan$302f2$7d1c6375$718b454d$bb3a6a2@cox.net>
References: <CAGj_d3D2OZt2nY622rp9NzxgAfKZ2iN1kLSQ2Ras-0fM+1+-ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rakesh Sankeshi posted on Thu, 11 Aug 2016 10:32:03 -0700 as excerpted:

> I set 200GB limit to one user and 100GB to another user.
> 
> as soon as I reached 139GB and 53GB each, hitting the quota errors.
> anyway to workaround quota functionality on btrfs LZO compressed
> filesystem?

The btrfs quota subsystem remains somewhat buggy and unstable.  A lot of 
work has gone into it to fix the problems, including rewrites of the 
entire subsystem, and it's much better than it used to be, but it's still 
a feature that I would recommend not using on btrfs.

My general position is this.  Either you need quotas for your use-case or 
you don't.  If you truly need them, you're far better off using a more 
mature filesystem with proven quota subsystem reliability.  If you don't 
really need them, simply keep the feature off for now, and for however 
long it takes to stabilize the feature, which could be some time.

Of course if you're specifically testing quotas in ordered to report 
issues and test bugfixes, that's a specific case of needing quota 
functionality, and your work is greatly appreciated as it'll help to 
eventually make that feature stable and workable for all. =:^)



-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

