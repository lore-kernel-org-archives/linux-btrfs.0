Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:53003
	"EHLO p3nlsmtpcp01-01.prod.phx3.gdg" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753190AbbKLPWt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 10:22:49 -0500
Received: from [117.201.18.56] (port=44790 helo=giis.domain.name)
	by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:AES128-GCM-SHA256:128)
	(Exim 4.85)
	(envelope-from <lakshmipathi.g@giis.co.in>)
	id 1ZwtEI-0004F9-M9
	for linux-btrfs@vger.kernel.org; Thu, 12 Nov 2015 07:52:03 -0700
Date: Thu, 12 Nov 2015 20:21:58 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: understanding csum tree
Message-ID: <20151112145158.GA13251@giis.domain.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi -

I trying to understand csum tree and its entries.

1) create a filenamed 'ab' with 100KB of data.  I can see csum entry for
this:

item 0 key (EXTENT_CSUM EXTENT_CSUM 4239360) itemoff 3895 itemsize 100

2) created another named 'zb1' with 100KB of data. I can't find csum
entry for this.Looks like item-0 is extended with csum of zb1.

item 0 key (EXTENT_CSUM EXTENT_CSUM 4239360) itemoff 3795 itemsize 200

If I need to read/print only the csum of 'zb1' file - how to achieve
that? thanks!

btrfs-debug-tree output : http://pastebin.com/tzKLX2ZU
after creating zb1 file : http://pastebin.com/WzjJuzFB

Cheers,
Lakshmipathi.G 

