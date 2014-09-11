Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37306 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaIKSMC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 14:12:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XS8qe-0002xA-9F
	for linux-btrfs@vger.kernel.org; Thu, 11 Sep 2014 20:12:00 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 20:12:00 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 20:12:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs listing is wrong
Date: Thu, 11 Sep 2014 18:11:48 +0000 (UTC)
Message-ID: <pan$84b37$6431c22$f05e1b59$2186100a@cox.net>
References: <5411B5A6.50103@intellasoft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mark Murawski posted on Thu, 11 Sep 2014 10:45:58 -0400 as excerpted:

> Label: 'Root'  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
>          Total devices 2 FS bytes used 7.46GiB
>          devid    1 size 9.31GiB used 8.06GiB path /dev/sdh6
>          devid    3 size 9.31GiB used 8.06GiB path
> /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa
> 
> # ls -al /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa
> lrwxrwxrwx 1 root root 10 Sep 11 10:43
> /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa -> ../../sdh6
> 
> devid 3 should really  be showing /dev/sde6

I believe that's an instance of a known bug (or depending on how you look 
at it possibly two) with a recently posted patch, but I doubt it has made 
it to mainline just yet.

What they're going to do is resolve to the canonical paths.  They don't 
do that at this point, and the paths can change, sometimes showing the 
wrong one for certain devices.

I'm not sure the fix will make it into this kernel cycle, however.  It 
should make it into 3.18 in any case, and will likely be stable-backported 
after that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

