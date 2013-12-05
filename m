Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:36118 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab3LEGQM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Dec 2013 01:16:12 -0500
Received: from [192.168.100.50] (cpe-024-088-095-145.sc.res.rr.com [24.88.95.145])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: jim@jrs-s.net)
	by mail.jrs-s.net (Postfix) with ESMTPSA id 446C4D2A4
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Dec 2013 01:16:10 -0500 (EST)
Message-ID: <52A01A29.3020005@jrs-s.net>
Date: Thu, 05 Dec 2013 01:16:09 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: ERROR: send ioctl failed with -12: Cannot allocate memory
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sending a 585G snapshot from box1 to box2:

     # ionice -c3 btrfs send daily*2013-12-01* | pv -L40m -s585G | ssh 
-c arcfour 10.0.0.40 btrfs receive /data/.snapshots/data/images
     At subvol daily_[1385956801]_2013-12-01_23:00:01
     At subvol daily_[1385956801]_2013-12-01_23:00:01
     ERROR: send ioctl failed with -12: Cannot allocate 
memory=======================================> ]     59% ETA 2:04:01
      347GB 3:00:12 [32.8MB/s]
[=====================================================================> ]
     59%
     ERROR: unexpected EOF in stream.

Send failed a little over halfway through with "Cannot allocate memory" 
error.  Which is surprising, given that this is a relatively lightly 
loaded 32G server.  Output of free -m, taken immediately after seeing 
the error above:

     root@gwa-virt1:/data/.snapshots/data/images# free -m
                  total       used       free     shared buffers     cached
     Mem:         32158      31798        360          0 0      22092
     -/+ buffers/cache:       9705      22453
     Swap:            0          0          0

Anybody got any suggestions?


