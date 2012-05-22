Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55631 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172Ab2EVVrz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 May 2012 17:47:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SWwvo-0003YN-T3
	for linux-btrfs@vger.kernel.org; Tue, 22 May 2012 23:47:52 +0200
Received: from cpc4-stap10-2-0-cust490.12-2.cable.virginmedia.com ([217.137.143.235])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2012 23:47:52 +0200
Received: from m_btrfs by cpc4-stap10-2-0-cust490.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2012 23:47:52 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: SSD erase state and reducing SSD wear
Date: Tue, 22 May 2012 22:47:42 +0100
Message-ID: <jph1hu$2tq$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got two recent examples of SSDs. Their pristine state from the
manufacturer shows:


Device Model:     OCZ-VERTEX3

# hexdump -C /dev/sdd
00000000  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
|................|
*
1bf2976000


Device Model:     OCZ VERTEX PLUS
(OCZ VERTEX 2E)

# hexdump -C /dev/sdd
00000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
|................|
*
df99e6000



What's a good way to test what state they get erased to from a TRIM
operation?

Can btrfs detect the erase state and pad unused space in filesystem
writes with the same value so as to reduce SSD wear?

Regards,
Martin

