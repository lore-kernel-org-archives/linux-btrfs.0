Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44909 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab3ESRfE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 May 2013 13:35:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ue7Vf-0008G9-5J
	for linux-btrfs@vger.kernel.org; Sun, 19 May 2013 19:35:03 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 May 2013 19:35:03 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 May 2013 19:35:03 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: btrfs pseudo-drbd
Date: Sun, 19 May 2013 18:32:09 +0100
Message-ID: <knb2ak$p9p$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Devs,

Would there be any problem to use nbd (/dev/ndX) devices to gain
btrfs-raid across multiple physical hosts across a network? (For a sort
of btrfs-drbd! :-) )


Regards,
Martin


http://en.wikipedia.org/wiki/Network_block_device

http://www.drbd.org/

