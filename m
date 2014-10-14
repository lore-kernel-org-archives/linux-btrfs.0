Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:38172 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754241AbaJNTPd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 15:15:33 -0400
Received: from cablepool1-225.stoweaccess.com ([199.188.178.225]:59612 helo=[192.168.2.7])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Xe7ZE-003wAs-IF
	for linux-btrfs@vger.kernel.org; Tue, 14 Oct 2014 13:15:32 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: what is the best way to monitor raid1 drive failures?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAPF83mtWrTRyfT34nNm7yjLDq+6uRegNJStkDK6+n_7fpmRTDQ@mail.gmail.com>
Date: Tue, 14 Oct 2014 15:15:28 -0400
Message-Id: <3E469DA1-1744-4AFC-9C56-04AE2CB6BA4F@colorremedies.com>
References: <CAPF83msBVh_EqHAFxzmicnQjZKe7k4ioNEd8q3vwTxLNDx5prA@mail.gmail.com> <543B372F.10509@oracle.com> <CAPF83mufgJvTKscpAS_SwFdSrA+1dK3T89A2UiuSHArr5wDn8A@mail.gmail.com> <543C86C3.7040804@oracle.com> <CAPF83mtWrTRyfT34nNm7yjLDq+6uRegNJStkDK6+n_7fpmRTDQ@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 14, 2014, at 10:48 AM, Suman C <schakrava@gmail.com> wrote:
> 
> mounted the filesystem with ro,degraded
> 
> tried adding the "new" sdb drive which results in the following error.
> (-f because the new drive has a fs from past)
> 
> # btrfs device add -f /dev/sdb /mnt2/raid1pool
> /dev/sdb is mounted
> 
> Unless I am missing something, this looks like a bug.

Strange message. I expect a device can't be added to a volume mounted ro. If the device add command works on a volume mounted rw, then the bug is the message '/dev/sdb is mounted' when adding device to ro mounted volume.


Chris Murphy

