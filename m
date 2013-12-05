Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from glockenspiel.complete.org ([78.47.53.23]:39298 "EHLO
	glockenspiel.complete.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767Ab3LERwL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Dec 2013 12:52:11 -0500
Received: from [63.245.179.205] (helo=hephaestus.lan.complete.org)
	by glockenspiel.complete.org with esmtps
	(with TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(TLS peer CN christoph.complete.org, certificate verified)
	(Exim 4.72)
	id 1Vod5s-0007Lc-Bh
	for linux-btrfs@vger.kernel.org; Thu, 05 Dec 2013 11:52:09 -0600
Received: from [::1]
	by hephaestus.lan.complete.org with esmtp (Exim 4.80)
	(envelope-from <jgoerzen@complete.org>)
	id 1Vod5o-0001z6-BA
	for linux-btrfs@vger.kernel.org; Thu, 05 Dec 2013 11:52:04 -0600
Message-ID: <52A0BD44.9030509@complete.org>
Date: Thu, 05 Dec 2013 11:52:04 -0600
From: John Goerzen <jgoerzen@complete.org>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Extremely slow metadata performance
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have observed extremely slow metadata performance with btrfs. This may 
be a bit of a nightmare scenario; it involves untarring a backup of
1.6TB of backuppc data, which contains millions of hardlinks and much
data, onto USB 2.0 disks.

I have run disk monitoring tools such as dstat while performing these
operations to see what's going on.

The behavior I notice is this:

   * When unpacking large files, the USB drives sustain activity in the
     20-40 MB/s range, as expected.
   * When creating vast numbers of hardlinks instead, the activity is
     roughly this:
       o Bursts of output from tar due to -v, sometimes corresponding to
         reads in the 300KB/s range (I suspect this has
         to do with caching)
       o Tar blocked for minutes while writes to the disk occur, in the
         300-600KB/s range.

This occurs even when nobarrier,noatime are specified as mount options. 
  I know the disk is capable of far more, because btrfs gets
far more from it when writing large files.

There are two USB drives in this btrfs filesystem: a 1TB and a 2TB
drive.  I have tried the raid1, raid0, and single metadata profiles.
Anecdotal evidence suggests that raid1 performs the worst, raid0 the
best, and single somewhere in between.  The data is in single mode.

Is this behavior known and expected?

Thanks,

John
