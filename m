Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:44780 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751158AbaEVSUp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 14:20:45 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:65233 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WnXbe-004FPA-Kj
	for linux-btrfs@vger.kernel.org; Thu, 22 May 2014 12:20:43 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: mount hangs after disk crash (RAID-1)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140522185025.4c72aab9@s9>
Date: Thu, 22 May 2014 12:20:41 -0600
Message-Id: <69656C71-5797-4D86-88FD-E254C4667305@colorremedies.com>
References: <20140522032258.234aaab7@s9> <20140522095101.107b62e8@s9> <20140522161634.054ec95f@s9> <20140522185025.4c72aab9@s9>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 22, 2014, at 11:50 AM, Tomasz Chmielewski <tch@virtall.com> wrote:

>> Try -o recovery,degraded
>> 
>> I would drop the other options for now, since they aren't necessary
>> to recover from a \ device failure.
> 
> Yes I've tried that as well, and it ends in the similar "hang" - high
> IO for a while, then no IO at all, mount does not return.
> 
> 
> It *does* mount as ro,degraded, but then, it's not possible to add a
> disk and recover to a functioning RAID-1.
> Also, when I try to remount rw, the mount command hangs as well.
> 
> Is there anything else I can try?

It sounds like it's able to read the file system but in the course of repairing whatever problems it has, it's getting stuck. 

I'd mount it ro and make sure its backup is updated. Then take a btrfs image btrfs-image -c 9 -t <cores> in case a dev wants to look at the fs at some point it its current state.

Then you can try some other things if you want: btrfs-next is one direction, and also regression testing with older kernels is also reasonable.

Last you could try btrfs-zero-log, but this doesn't look like the typical case for it, and probably will make things worse so it's not the next thing to try. Also I don't expect btrfs check or even --repair to work. I've not yet had any luck with it working on degraded volumes, and even rejoined volumes (no longer degraded) but not yet manually balanced the btrfs check crashes. After a manual balance then the btrfs check is OK.


Chris Murphy