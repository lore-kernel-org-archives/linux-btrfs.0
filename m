Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43503 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbbLPLK7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 06:10:59 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a99yv-0003b9-VT
	for linux-btrfs@vger.kernel.org; Wed, 16 Dec 2015 12:10:54 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 12:10:53 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 12:10:53 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v3] btrfs: Introduce new mount option to disable tree
 log replay
Date: Wed, 16 Dec 2015 11:10:48 +0000 (UTC)
Message-ID: <pan$ecec5$9f9ca76c$f1c4eebd$1e31c111@cox.net>
References: <1449714846-18174-1-git-send-email-quwenruo@cn.fujitsu.com>
	<20151214173200.GO4227@twin.jikos.cz> <5670C017.5010104@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Wed, 16 Dec 2015 09:36:23 +0800 as excerpted:

> David Sterba wrote on 2015/12/14 18:32 +0100:
>> On Thu, Dec 10, 2015 at 10:34:06AM +0800, Qu Wenruo wrote:
>>> Introduce a new mount option "nologreplay" to co-operate with "ro"
>>> mount option to get real readonly mount, like "norecovery" in ext* and
>>> xfs.
>>>
>>> Since the new parse_options() need to check new flags at remount time,
>>> so add a new parameter for parse_options().
>>>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>>> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>>
>> I've read the discussions around the change and from the user's POV I'd
>> suggest to add another mount option that would be just an alias for any
>> mount options that would implement the 'hard-ro' semantics.
>>
>> Say it's called 'nowr'. Now it would imply 'nologreplay', but may cover
>> more options in the future.
>>
>>   mount -o ro,nowr /dev/sdx /mnt
>>
>> would work when switching kernels.
>>
>>
> That would be nice.
> 
> I'd like to forward the idea/discussion to filesystem ml, not only btrfs
> maillist.
> 
> Such behavior should better be coordinated between all(at least xfs and
> ext4 and btrfs) filesystems.
> 
> One sad example is, we can't use 'norecovery' mount option to disable
> log replay in btrfs, as there is 'recovery' mount option already.
> 
> So I hope we can have a unified mount option between mainline
> filesystems.

FWIW, I was just reading the mount manpage in connection with a reply for 
a different thread, and noticed...

mount (8) (from util-linux 2.27.1) says noload and norecovery are the 
same option, for ext3/4 at least.  It refers to the xfs (5) manpage, from 
xfsprogs, for xfs mount options, and that's not installed here, so I 
can't confirm noload for it, but it's there for ext3/4.

And noload doesn't have the namespace collision problem norecovery does 
on btrfs, so I'd strongly suggest using it, at least as an alias for 
whatever other btrfs-specific name we might choose.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

