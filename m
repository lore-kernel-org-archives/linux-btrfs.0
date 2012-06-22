Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42084 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757844Ab2FVKuI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 06:50:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Si1RE-0002Im-Rj
	for linux-btrfs@vger.kernel.org; Fri, 22 Jun 2012 12:50:04 +0200
Received: from 78-32-127-104.static.enta.net ([78-32-127-104.static.enta.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 12:50:04 +0200
Received: from alex by 78-32-127-104.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 12:50:04 +0200
To: linux-btrfs@vger.kernel.org
From: Alex <alex@bpmit.com>
Subject: Debian RT kernel
Date: Fri, 22 Jun 2012 10:49:52 +0000 (UTC)
Message-ID: <loom.20120622T123511-621@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Note to self: if wanting to test btrfsck and give self a scare don't introduce
the RT version of the same kernel into a (working perfectly) but not
backed-up-to-the-minute btrfs install.

Thanks. That is all.

In other news, KVM on btrfs: I'm finding the guests a little slow now I have two
guests (file not LVM) on KVM. Mainly due to heavy fragmentation I think. Still
using default mounts though.

Any ideas when I autodefrag will make it into the default mounts?
Is autodefrag responsible for the corruptions being fixed in 3.5; followed the
commits and I don't think so but I should ask.

Thank you.



