Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout3.netcologne.de ([89.1.8.213]:39650 "EHLO
	cc-smtpout3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbaD1L5G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Apr 2014 07:57:06 -0400
Received: from cc-smtpin1.netcologne.de (cc-smtpin1.netcologne.de [89.1.8.201])
	by cc-smtpout3.netcologne.de (Postfix) with ESMTP id 74CF8122DA
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Apr 2014 13:57:03 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by cc-smtpin1.netcologne.de (Postfix) with ESMTP id 6E34F11DCA
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Apr 2014 13:57:03 +0200 (CEST)
Received: from [87.78.83.178] (helo=cc-smtpin1.netcologne.de)
	by localhost with ESMTP (eXpurgate 4.0.2)
	(envelope-from <s.schumacher@netcologne.de>)
	id 535e420f-0bb0-7f0000012729-7f0000018df7-1
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Apr 2014 13:57:03 +0200
Received: from mars.solar.net (xdsl-87-78-83-178.netcologne.de [87.78.83.178])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by cc-smtpin1.netcologne.de (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Apr 2014 13:57:03 +0200 (CEST)
Date: Mon, 28 Apr 2014 13:57:02 +0200
From: Stefan Malte Schumacher <s.schumacher@netcologne.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Confusing output of btrfs fi df
Message-ID: <20140428115702.GA26444@mars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> So try this one:
> btrfs balance start -musage=0 -v

I fear that didn't work too. 

mars:/mnt # btrfs balance start -musage=0 -v btrfs/
Dumping filters: flags 0x6, state 0x0, force is off
  METADATA (flags 0x2): balancing, usage=0
  SYSTEM (flags 0x2): balancing, usage=0
  Done, had to relocate 1 out of 2708 chunks
  
mars:/mnt # btrfs fi df btrfs/
Data, RAID1: total=2.64TiB, used=2.22TiB
System, RAID1: total=8.00MiB, used=380.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=4.00GiB, used=2.94GiB


>If that fails to remove the extra system chunk, then we have a mystery
>indeed.  What's different on your system and why isn't it working?

I have no idea. Its just a plain openSUSE 13.1 and they consider btrfs
support stable enough to use it as default filesystem in the upcoming
13.2. I could create the filesystem again and restore the data but of
course I would actually need to know what went wrong the first time in
order to avoid doing it again. Is there anything you need to know
about my system which would be of use? (Controller, Disks, Mainboard
etc. ?)  

Yours sincerely
Stefan

   
