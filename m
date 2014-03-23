Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns2.netmagic.net ([206.14.125.20]:45900 "EHLO ns2.netmagic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaCWUia (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 16:38:30 -0400
Received: from [10.42.42.100] (adsl-69-236-76-33.dsl.pltn13.pacbell.net [69.236.76.33])
	(authenticated bits=0)
	by ns2.netmagic.net (8.14.4/8.14.4) with ESMTP id s2NKcLCJ001001
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 13:38:29 -0700
Message-ID: <1395607101.4607.0.camel@spike.sunnydale.homeip.net>
Subject: Improve btrfs man page
From: Per Nystrom <pnystrom@netmagic.net>
To: linux-btrfs@vger.kernel.org
Date: Sun, 23 Mar 2014 13:38:21 -0700
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am going through the process of replacing a bad drive in a RAID 1
mirror.  The filesystem wouldn't mount because of the missing device,
and the btrfs man pages were not helpful in resolving it.  Specifically,
it would have been very useful to me if this part of the wiki were
included somewhere:

https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Replacing_failed_devices

There is no mention in the man pages of the -o degraded mount option,
which is needed to even manipulate the filesystem; nor is there any
mention of the special option "missing" for device delete.

I'm sure I'm not the only one who would turn to man btrfs first when
facing a failed drive.

Thanks,
Per

