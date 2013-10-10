Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34101 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264Ab3JJS1m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Oct 2013 14:27:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VUKxX-0006my-Jf
	for linux-btrfs@vger.kernel.org; Thu, 10 Oct 2013 20:27:39 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Oct 2013 20:27:39 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Oct 2013 20:27:39 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Will "btrfs scrub" clear corrupt filesystem trees?
Date: Thu, 10 Oct 2013 19:27:28 +0100
Message-ID: <l36ri7$uvg$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have 1.5TB of data on a single disk formatted with defaults. There
appears to be only two directory trees of a few MBytes that have
suffered corruption (due to in the past too high a sata speed causing
corruption).

The filesystem mounts fine. But how to clear out the corrupt trees?

At the moment, I have running:

btrfsck --repair --init-extent-tree /dev/sdc

parent transid verify failed on 911904604160 wanted 17448 found 17449
parent transid verify failed on 911904604160 wanted 17448 found 17449
parent transid verify failed on 911904604160 wanted 17448 found 17449
parent transid verify failed on 911904604160 wanted 17448 found 17449
Ignoring transid failure

... And it is still running after over two days now. Looped?


Would a:

btrfs scrub start

clear out the corrupt trees?

Must I wait for the btrfsck to complete if it is recreating an extents
tree?...


Suggestions welcomed...

Martin

