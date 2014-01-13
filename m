Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43910 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbaAMRrq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 12:47:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W2lc1-0000t2-6W
	for linux-btrfs@vger.kernel.org; Mon, 13 Jan 2014 18:47:45 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 18:47:45 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 18:47:45 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: btrfs versions compatibility and updates
Date: Mon, 13 Jan 2014 17:47:31 +0000
Message-ID: <lb18r7$q52$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's the very good idea of releasing the btrfs userspace tools with a
version number that matches the kernel version... Good to see a good
jump for what is considered 'stable'.


What is the policy for maintaining compatibility with whatever range of
kernel versions?

And what is the state of play now for the "Chris Mason" or whatever
latest 'stable' branch of btrfs on git?


In other words: Should we always update the btrfs userspace tools to the
latest even though we may be running one or two kernels behind that?...


Thanks,
Martin

