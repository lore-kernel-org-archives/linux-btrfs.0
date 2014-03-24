Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45014 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbaCXTsF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 15:48:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WSAqe-0005Y3-LF
	for linux-btrfs@vger.kernel.org; Mon, 24 Mar 2014 20:47:52 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 20:47:52 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 20:47:52 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Suggestion: Anti-fragmentation safety catch (RFC)
Date: Mon, 24 Mar 2014 19:47:34 +0000
Message-ID: <lgq247$lgk$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just an idea:


btrfs Problem:

I've had two systems die with huge load factors >100(!) for the case
where a user program has unexpected to me been doing 'database'-like
operations and caused multiple files to become heavily fragmented. The
system eventually dies when data cannot be added to the fragmented files
faster than the real time data collection.

My example case is for two systems with btrfs raid1 using two HDDs each.
Normal write speed is about 100MByte/s. After heavy fragmentation, the
cpus are at 100% wait and i/o is a few hundred kByte/s.


Possible fix:

btrfs checks the ratio of filesize versus number of fragments and for a
bad ratio either:

1: Performs a non-cow copy to defragment the file;

2: Turns off cow for that file and gives a syslog warning for that;

3: Automatically defragments the file.



Or?


For my case, I'm not sure "2" is a good idea in case the user is
rattling through a gazillion files and the syslog gets swamped.

Unfortunately, I don't know beforehand what files to mark no-cow unless
I no-cow the entire user/applications.


Thoughts?


Thanks,
Martin

