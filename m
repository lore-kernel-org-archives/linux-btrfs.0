Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56419 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759873Ab2EQOpj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 10:45:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SV1xR-00056Z-BU
	for linux-btrfs@vger.kernel.org; Thu, 17 May 2012 16:45:37 +0200
Received: from cpc4-stap10-2-0-cust490.12-2.cable.virginmedia.com ([217.137.143.235])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2012 16:45:37 +0200
Received: from m_btrfs by cpc4-stap10-2-0-cust490.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2012 16:45:37 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: SSD format/mount parameters questions
Date: Thu, 17 May 2012 15:45:27 +0100
Message-ID: <jp32u7$vlc$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For using SSDs:

Are there any format/mount parameters that should be set for using btrfs
on SSDs (other than the "ssd" mount option)?


General questions:

How long is the 'delay' for the delayed alloc?

Are file allocations aligned to 4kiB boundaries, or larger?

What byte value is used to pad unused space?

(Aside: For some, the erased state reads all 0x00, and for others the
erased state reads all 0xff.)


Background:

I've got a mix of various 120/128GB SSDs to newly set up. I will be
using ext4 on the critical ones, but also wish to compare with btrfs...

The mix includes some SSDs with the Sandforce controller that implements
its own data compression and data deduplication. How well does btrfs fit
with those compared to other non-data-compression controllers?


Regards,
Martin

