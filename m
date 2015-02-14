Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53643 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbbBNQZI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Feb 2015 11:25:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YMfWh-0005Ga-Ly
	for linux-btrfs@vger.kernel.org; Sat, 14 Feb 2015 17:25:04 +0100
Received: from c-71-202-138-232.hsd1.ca.comcast.net ([71.202.138.232])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Feb 2015 17:25:03 +0100
Received: from brampton by c-71-202-138-232.hsd1.ca.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Feb 2015 17:25:03 +0100
To: linux-btrfs@vger.kernel.org
From: Andrew Brampton <brampton@gmail.com>
Subject: Re: [PATCH] btrfs-progs: fix page align issue for lzo compress in restore
Date: Sat, 14 Feb 2015 16:18:13 +0000 (UTC)
Message-ID: <loom.20150214T171444-780@post.gmane.org>
References: <1411011283-22079-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for this patch! It was needed to correctly restore from a broken file
system. I would appreciate if this was merged, and available with the next
release.



