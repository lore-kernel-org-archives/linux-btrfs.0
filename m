Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33078 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbbEFOBc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 May 2015 10:01:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ypzt6-00015G-4a
	for linux-btrfs@vger.kernel.org; Wed, 06 May 2015 16:01:24 +0200
Received: from 168.159.160.53 ([168.159.160.53])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 16:01:24 +0200
Received: from toyours_sridhar by 168.159.160.53 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 16:01:24 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: btrfs send using with copied snapshot
Date: Wed, 6 May 2015 14:01:02 +0000 (UTC)
Message-ID: <loom.20150506T155438-123@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs send has option -p to compare 2 snapshots and genereate output of 
diff and if btrfs receive is there it will get the diff.

lets say i have done my first backup 
/b1/s1 is my subvolume and snap1_s1 is first snapshot

ran command:

btrfse send /b1/snap1_s1 | btrfs receive /backup


then I will get my backup /backup/snap1_s1

next I have created 2nd snapshot /b1/snap2_s1

why cannot i do below

btrfs send -p /backup/snap1_s1 /b1/snap2_s1 |btrfs receive /backup

both sanp1_s1 and snap2_s2 are readonly

why there is a restriction of all snapshots should be under same root? 
can't I get the diff of copied snapshot i.e /backup/snap1_s1 (never 
changed) to new snapshot /b1/snap2_s1 ??

My case, i may not always keep previous snapshot but i have copied to 
backup using the snapshot.

In this case is there a way to backup only incrementals using backedup 
snapshot subvolume ?

