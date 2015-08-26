Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58146 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbbHZTKD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 15:10:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZUg59-0001vc-OB
	for linux-btrfs@vger.kernel.org; Wed, 26 Aug 2015 21:10:00 +0200
Received: from wifi-ls-74-104.resnet.wisc.edu ([146.151.74.104])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 21:09:59 +0200
Received: from jhe by wifi-ls-74-104.resnet.wisc.edu with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 21:09:59 +0200
To: linux-btrfs@vger.kernel.org
From: Jun He <jhe@cs.wisc.edu>
Subject: Re: btrfs -o discard bug in latest dev branches
Date: Wed, 26 Aug 2015 19:09:50 +0000 (UTC)
Message-ID: <loom.20150826T205442-520@post.gmane.org>
References: <20150826040442.GC10927@Juns-MacBook-Pro.local> <pan$a3d06$a94167e8$2a203b5d$1ff3d7f1@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the info. In the attached reproducer, I don't do sync after running
the workload (but I've tried that before.). Just to be sure, I ran again with
sync and waited for 60 seconds before collecting data. The behavior was the
same. 

Then I tried one more thing, which corrected btrfs behavior. I sync-ed after
each write, which produced the following space-time graph: 

https://gist.githubusercontent.com/junhe/b6ce39eeb6de8887e66a/raw/d31ac85559f83c
d86aef8e4250b3d3d859226c8d/sync-after-each-write.png

Each time a write is finished, the extent of the last write is discarded. 





