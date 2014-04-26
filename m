Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:36894 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaDZCfS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 22:35:18 -0400
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Received: from [192.168.2.90]
 (modemcable211.176-81-70.mc.videotron.ca [70.81.176.211])
 by VL-VM-MR005.ip.videotron.ca
 (Oracle Communications Messaging Exchange Server 7u4-22.01 64bit (built Apr 21
 2011)) with ESMTPA id <0N4M00ANM9UT4Z10@VL-VM-MR005.ip.videotron.ca> for
 linux-btrfs@vger.kernel.org; Fri, 25 Apr 2014 22:35:17 -0400 (EDT)
Message-id: <535B1B53.80807@polymtl.ca>
Date: Fri, 25 Apr 2014 22:34:59 -0400
From: Christian Robert <christian.robert@polymtl.ca>
To: linux-btrfs@vger.kernel.org
Subject: btrfsck is using far too much memory
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfsck is using far too much memory !

I tryed a btrfsck on my /dev/md127 (13T) and had to kill it
because btrfsck used 7.8 Gigs of ram ( machine have 8 Gigs of ram, plus four Gigs on swap when I killed it)

btrfsck should not try to bring "in memory" the whole metadata, etc.

my 2 cents, (will reformat /dev/md127 tomorrow, actually saving what can be saved on the old readonly fs)


Xtian.
