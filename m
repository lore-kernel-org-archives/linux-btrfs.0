Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:57462 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaDFNSN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Apr 2014 09:18:13 -0400
Received: from xev.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 1FE8D20B51
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Apr 2014 23:18:12 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Reply-To: russell@coker.com.au
Subject: confusing snapshot error
Date: Sun, 06 Apr 2014 23:18:10 +1000
Message-ID: <4511581.MJ1MTiboYl@xev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ERROR: cannot snapshot '/home' - Read-only file system

The above error occurs when a read-only snapshot already exists.

I think it would be better if the target name had to be fully qualified and 
gave an error "path already 
exists" or something similar.  While the current behavior mimics the operation 
of mv and is surely 
considered a feature by some people, I don't think that mimicing mv is that 
great a feature and the 
current operation gives misleading errors when a snapshot exists.  I just had 
errors from a bunch of 
systems when daylight savings ended and it would have saved me some time if 
the error was clearer.

If we are going to mimic traditional Unix commands then I think it would be 
good to have functionality 
analogous to "mkdir -p" so that next year my cron jobs just quietly don't try 
to make snapshots twice.


Thanks

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/



