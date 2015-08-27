Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53623 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbbH0C63 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 22:58:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZUnOU-0002EX-1E
	for linux-btrfs@vger.kernel.org; Thu, 27 Aug 2015 04:58:26 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 04:58:26 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 04:58:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Understanding BTRFS storage
Date: Thu, 27 Aug 2015 02:58:13 +0000 (UTC)
Message-ID: <pan$7fd63$2b2fd6ee$53e6fc05$7a0aab72@cox.net>
References: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
	<20150826165024.05af044f@natsu> <55DDAB1C.90406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Wed, 26 Aug 2015 08:03:40 -0400 as
excerpted:

> On 2015-08-26 07:50, Roman Mamedov wrote:
>> On Wed, 26 Aug 2015 10:56:03 +0200 George Duffield
>> <forumscollective@gmail.com> wrote:
>>
>>> I'm looking to switch from a 5x3TB mdadm raid5 array to a Btrfs based
>>> solution that will involve duplicating a data store on a second
>>> machine for backup purposes (the machine is only powered up for
>>> backups).
>>
>> What do you want to achieve by switching? As Btrfs RAID5/6 is not safe
>> yet, do you also plan to migrate to RAID10, losing in storage
>> efficiency?
>>
>> Why not use Btrfs in single-device mode on top of your mdadm RAID5/6?
>> Can even migrate without moving any data if you currently use Ext4, as
>> it can be converted to Btrfs in-place.

Someone (IIRC it was Austin H) posted what I thought was an extremely 
good setup, a few weeks ago.  Create two (or more) mdraid0s, and put 
btrfs raid1 (or raid5/6 when it's a bit more mature, I've been 
recommending waiting until 4.4 and see what the on-list reports for it 
look like then) on top.  The btrfs raid on top lets you use btrfs' data 
integrity features, while the mdraid0s beneath help counteract the fact 
that btrfs isn't well optimized for speed yet, the way mdraid has been.  
And the btrfs raid on top means all is not lost with a device going bad 
in the mdraid0, as would normally be the case, since the other raid0(s), 
functioning as the remaining btrfs devices, let you rebuild the missing 
btrfs device, by recreating the missing raid0.

Normally, that sort of raid01 is discouraged in favor of raid10, with 
raid1 at the lower level and raid0 on top, for more efficient rebuilds, 
but btrfs' data integrity features change that story entirely. =:^)

> As of right now, btrfs-convert does not work reliably or safely.  I
> would strongly advise against using it unless you are trying to help get
> it working again.

Seconded.  Better to use your existing ext4 as a backup, which you should 
have anyway if you value your data, and copy the data from that ext4 
"backup" to the new btrfs you created with mkfs.btrfs using your 
preferred options.  That leaves the existing ext4 in place /as/ a backup, 
while starting with a fresh and clean btrfs, setup with exactly the 
options you want.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

