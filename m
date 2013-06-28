Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38675 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab3F1OAA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Jun 2013 10:00:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UsZDS-0007oT-UP
	for linux-btrfs@vger.kernel.org; Fri, 28 Jun 2013 15:59:58 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 15:59:58 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 15:59:58 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: raid1 inefficient unbalanced filesystem reads
Date: Fri, 28 Jun 2013 14:59:45 +0100
Message-ID: <kqk4sc$t5d$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On kernel 3.8.13:

Using two equal performance SATAII HDDs, formatted for btrfs raid1 for
both data and metadata and:

The second disk appears to suffer about x8 the read activity of the
first disk. This causes the second disk to quickly get maxed out whilst
the first disk remains almost idle.

Total writes to the two disks is equal.

This is noticeable for example when running "emerge --sync" or running
compiles on Gentoo.


Is this a known feature/problem or worth looking/checking further?

Regards,
Martin

