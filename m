Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57705 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753578AbaHVALN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 20:11:13 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:56778 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XKcRk-000n6Y-Ot
	for linux-btrfs@vger.kernel.org; Thu, 21 Aug 2014 18:11:12 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: mkfs.btrfs vs fstrim on an SD Card (not SSD)
Message-Id: <3CE6F328-8757-4B7F-858F-E820DFDF97E8@colorremedies.com>
Date: Thu, 21 Aug 2014 18:11:11 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Short version:
When I mkfs.btrfs either an SD Card or an SSD, I get a response back to the effect the whole device specified is trimmed. However, when I use fstrim on an SD Card, I get an error that trim isn't supported. So I'm wondering if anyone knows the difference between how fstrim is trimming, and how mkfs.btrfs is trimming. 

Long version:
It does seem like the mkfs.btrfs one has worked because using dd to read an LBA with known information returns zeros after mkfs.

And then I found the SD Card association has their own formatting tool for Windows and OS X, with the warning "Using generic formatting utilities may result in less than optimal performance for your memory cards."
https://www.sdcard.org/downloads/formatter_4/

So I downloaded the Physical Layer Simplified Specification Version 4.10 spec, and on page 38 it describes an erase command.

4.3.5 Erase
It is desirable to erase many write blocks simultaneously in order to enhance the data throughput. Identification of these write blocks is accomplished with the ERASE_WR_BLK_START (CMD32), ERASE_WR_BLK_END (CMD33) commands.
The host should adhere to the following command sequence: ERASE_WR_BLK_START, ERASE_WR_BLK_END and ERASE (CMD38).

So I'm going to guess that mkfs.btrfs is leveraging something that ends up using these SD Card specific commands on SD Cards, but mkfs.btfs itself isn't aware of this distinction. Whereas fstrim is maybe using something else?

Chris Murphy