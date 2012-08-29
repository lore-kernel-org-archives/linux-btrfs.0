Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:32957 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab2H2NWU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Aug 2012 09:22:20 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail1.trendhosting.net (Postfix) with ESMTP id 4613F1512F
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2012 15:12:18 +0100 (BST)
Received: from mail1.trendhosting.net ([127.0.0.1])
	by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id eSHHCffE7EGY for <linux-btrfs@vger.kernel.org>;
	Wed, 29 Aug 2012 15:12:09 +0100 (BST)
Message-ID: <503E1780.1000707@pocock.com.au>
Date: Wed, 29 Aug 2012 15:22:08 +0200
From: Daniel Pocock <daniel@pocock.com.au>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Debian 7 (wheezy) support for btrfs RAID
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




I've been able to run the Debian 7 installer (beta1) and get a working
Debian system on btrfs RAID1 root FS.

A few manual steps and patches required - it would be useful to get
feedback about this process.  I might have a go at patching partman to
fully support this through the installer menu.

I've written up the process as an install report bug:

  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=686130

Any feedback is welcome.
