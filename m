Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37672 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab3HEEvH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 00:51:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V6Cl8-0005eL-19
	for linux-btrfs@vger.kernel.org; Mon, 05 Aug 2013 06:51:06 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Aug 2013 06:51:06 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Aug 2013 06:51:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unable to unmount filesystem (bug in kernel reported in
 kern.log)
Date: Mon, 5 Aug 2013 04:50:48 +0000 (UTC)
Message-ID: <pan$5dead$acb36a7f$5d0e094f$bd2b0353@cox.net>
References: <CAKZ=RP88hT4w5am-nU7ftEQdswxLvkw7dZ7dFasTKjn0vji8hQ@mail.gmail.
	com> <51FF0D93.80207@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jeff Mahoney posted on Sun, 04 Aug 2013 22:27:31 -0400 as excerpted:

> On 8/4/13 6:58 PM, Alfredo Esteban wrote:
>> I tried to unmount a btrfs filesystem located in a external usb hard
>> drive. This belonged to a raid1 data and metadata filesystem mounted in
>> degraded mode.
>> 
>> Unfortunately, I couldn't save the image of filesystem but I could see
>> this error in kern.log:

[snip]

>> Aug  4 02:26:06 rohan kernel: [ 3878.947184] kernel BUG at
>> /build/buildd/linux-3.2.0/fs/btrfs/inode.c:806!
> 
> This is against the 3.2 kernel, which is now 19 months old and ancient
> in terms of btrfs support. Please see if you can reproduce with a more
> recent kernel. Otherwise, file a bug report with Ubuntu if they are
> doing substantial btrfs backports.

Seconded.

Also, if you're not aware of the btrfs wiki yet, you probably want to 
read up on btrfs there.  It stresses btrfs' development nature and the 
importance of running a current kernel for btrfs testing in several 
places, so the fact that you're not doing so indicates that you probably 
hadn't read the wiki, and are thus likely missing out on other 
potentially very useful information, as well.

https://btrfs.wiki.kernel.org/


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

