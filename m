Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41599 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbcDSJqP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Apr 2016 05:46:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1asSES-0000W1-On
	for linux-btrfs@vger.kernel.org; Tue, 19 Apr 2016 11:46:08 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2016 11:46:08 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2016 11:46:08 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID5 Unable to remove Failing HD
Date: Tue, 19 Apr 2016 09:45:59 +0000 (UTC)
Message-ID: <pan$15255$6fcb2fe6$40daca28$6df14af1@cox.net>
References: <CAKUFzr8gm-yN01CY=H_j6jdEXJL5b0A_vS6gJ5iH1YN1+ZJAvg@mail.gmail.com>
	<56BAFC15.6080106@oracle.com> <5714A1F7.3050509@bouton.name>
	<pan$d96e4$2cb56bbb$1d5f6612$721cfc21@cox.net>
	<5715F6A0.7030707@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain posted on Tue, 19 Apr 2016 17:13:04 +0800 as excerpted:

>>> # btrfs device delete 3 /mnt/store/
>>> ERROR: device delete by id failed: Inappropriate ioctl for device
>>>
>>> Were the patch sets above for btrfs-progs or for the kernel ?
>>
>> Looks like you're primarily interested in the concern2 patches, device
>> delete by devid.
>>
>> A quick search of the list back-history reveals that an updated patch
>> set, 00/15 now (look for [PATCH 00/15] Device delete by id ), was
>> posted by dserba on the 15th of February.  It was the kernel patches
>> and was slated for the kernel 4.6 dev cycle.  However, the patch set
>> was pulled at that time due to test failures, tho they were suspected
>> to actually be from something else.
> 
>   Thanks Duncan. Yep the reported issue did not point to any of the
>   patch in that set. But I am keeping a tab open for new users /test
>   cases, anything that is found will help.
> 
>   By the way, For Lionel issue, delete missing should work ?
>   which does not need any additional patch.

Were the issues with btrfs delete missing fixed?  There were some issues 
with it actually trying to delete a device literally named "missing" or 
something the like, and of course not finding it to delete, a kernel 
cycle or two ago, and AFAIK delete by ID was originally proposed as a fix 
for that.  If I was reading the comments correctly, however, I think the 
problem there was introduced with the switch to libblockdev or some such, 
however, so he might be able to get around that by using older releases, 
as long as the filesystem isn't using newer features that would block 
that.

So delete missing may or may not work now, I've lost track.  But he was 
reluctant to unmount and reboot, and of course with btrfs not yet 
offlining failed devices, it doesn't know it's actually missing, yet.  So 
even if delete missing does work for him, it's not going to work until a 
reboot and remount degraded, and he was hoping to avoid that with the 
delete by ID.




-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

