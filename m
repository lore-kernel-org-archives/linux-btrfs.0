Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43703 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752539AbaEVWIC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 18:08:02 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:51622 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Wnb9b-0022rj-Vr
	for linux-btrfs@vger.kernel.org; Thu, 22 May 2014 16:08:01 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: mount hangs after disk crash (RAID-1)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140522185025.4c72aab9@s9>
Date: Thu, 22 May 2014 16:07:58 -0600
Message-Id: <ED54B94A-528B-4382-9D1F-EE8D234F55D6@colorremedies.com>
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

How much metadata is there on the volume? And how much memory does the system have? This might also be a case where it might take hours, or longer, for it sort things out, and isn't actually permanently hung up. Worth a shot to leave it overnight and see what happens.

I agree trying skip_balance is worth a shot also.


Chris Murphy