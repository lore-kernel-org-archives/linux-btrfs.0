Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55185 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747Ab3JDPuF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Oct 2013 11:50:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VS7dk-000166-4k
	for linux-btrfs@vger.kernel.org; Fri, 04 Oct 2013 17:50:04 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Oct 2013 17:50:04 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Oct 2013 17:50:04 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: btrfs recovery: What do the commands actually do?
Date: Fri, 04 Oct 2013 16:47:19 +0100
Message-ID: <l2mntu$416$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's ad-hoc comment for various commands to recover from filesystem
errors.

But what do they actually do and when should what command be used?

(The wiki gives scant indication other than to 'blindly' try things...)


There's:

mount "-o recovery,noatime"

btrfsck:
    --repair                    try to repair the filesystem
    --init-csum-tree            create a new CRC tree
    --init-extent-tree          create a new extent tree

And there is "scrub"...


What do they do exactly and what are the indicators to try using them?

Or when should you 'give up' on a filsystem and just retrieve whatever
data can be read and start again?


All that lot sounds good for a wiki page ;-)

Thanks,
Martin


