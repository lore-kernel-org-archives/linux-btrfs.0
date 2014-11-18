Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40921 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754126AbaKRTDn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 14:03:43 -0500
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:51187 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.84)
	(envelope-from <lists@colorremedies.com>)
	id 1Xqo3w-001mL0-Rb
	for linux-btrfs@vger.kernel.org; Tue, 18 Nov 2014 12:03:41 -0700
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: raid 10 drive replacement on old raid6 btrfs volume
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52C9C8E2-8618-44FE-85E0-E8FE499268B7@gmail.com>
Date: Tue, 18 Nov 2014 12:03:39 -0700
Message-Id: <5BF7C839-8BBF-4F4E-90EE-FCCCEECE0B3B@colorremedies.com>
References: <52C9C8E2-8618-44FE-85E0-E8FE499268B7@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 18, 2014, at 11:22 AM, Craig Yoshioka <craigyk@gmail.com> wrote:

> I started experimenting with an 8 drive BTRFS RAID6, but rebalanced it a while ago as RAID10.  Recently though I’ve run into problems when trying to replace a drive.
> 
>> Nov 18 10:18:44 ganymede kernel: BTRFS warning (device sdk): dev_replace cannot yet handle RAID5/RAID6
> 
> Even though df shows RAID10:
> 
>> Data, RAID10: total=4.65TiB, used=4.62TiB
>> System, RAID10: total=64.00MiB, used=432.00KiB
>> Metadata, RAID10: total=34.00GiB, used=31.36GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> Am I out of luck and need to copy everything off and start over?

Interesting, seems like a bug.

Anyway you should be able to do one of two things: ‘btrfs device add’ to add new device, and ‘btrfs device delete’ the old device; OR
you can physically remove the old device, connect the new device, and then ‘btrfs device add’ new, and ‘btrfs device delete missing’ since you won’t be able to designate the disconnected old device.

Chris Murphy