Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:57470 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaDYPHA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 11:07:00 -0400
Date: Fri, 25 Apr 2014 08:57:33 -0600 (MDT)
From: Steve Leung <sjleung@shaw.ca>
To: linux-btrfs@vger.kernel.org
Subject: safe/necessary to balance system chunks?
Message-ID: <alpine.DEB.2.10.1404250842350.2320@cubia.leung>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi list,

I've got a 3-device RAID1 btrfs filesystem that started out life as 
single-device.

btrfs fi df:

  Data, RAID1: total=1.31TiB, used=1.07TiB
  System, RAID1: total=32.00MiB, used=224.00KiB
  System, DUP: total=32.00MiB, used=32.00KiB
  System, single: total=4.00MiB, used=0.00
  Metadata, RAID1: total=66.00GiB, used=2.97GiB

This still lists some system chunks as DUP, and not as RAID1.  Does this 
mean that if one device were to fail, some system chunks would be 
unrecoverable?  How bad would that be?

Assuming this is something that needs to be fixed, would I be able to fix 
this by balancing the system chunks?  Since the "force" flag is required, 
does that mean that balancing system chunks is inherently risky or 
unpleasant?

Thanks,

Steve
