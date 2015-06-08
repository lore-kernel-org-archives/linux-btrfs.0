Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extern.sonoring.de ([212.23.155.200]:43252 "EHLO
	cmail.imagmbh.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751158AbbFHRTj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jun 2015 13:19:39 -0400
Received: from localhost (localhost [127.0.0.1])
	by cmail.imagmbh.de (Postfix) with ESMTP id 81F69B4BF7
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2015 19:10:35 +0200 (CEST)
Received: from cipher1 ([10.1.33.12])
	by localhost (cmail.imagmbh.de [10.1.33.15]) (amavisd-new, port 10028)
	with ESMTP id gk5v6YB9eeas for <linux-btrfs@vger.kernel.org>;
	Mon,  8 Jun 2015 19:10:35 +0200 (CEST)
Received: from cmail.imagmbh.de ([127.0.0.1])
	by localhost (cmail.imagmbh.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XCuclSKJ_WHm for <linux-btrfs@vger.kernel.org>;
	Mon,  8 Jun 2015 19:10:34 +0200 (CEST)
Received: from malu-aspire-v3-771.localnet (b2b-94-79-178-150.unitymedia.biz [94.79.178.150])
	(Authenticated sender: martin.h.ludwig@imagmbh.de)
	by cmail.imagmbh.de (Postfix) with ESMTPSA id 73EDAB4BF7
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2015 19:10:34 +0200 (CEST)
From: Martin <develop@imagmbh.de>
To: linux-btrfs@vger.kernel.org
Subject: rw-mount-problem after raid1-failure
Date: Mon, 08 Jun 2015 19:10:33 +0200
Message-ID: <2227931.EqpnWnc32X@malu-aspire-v3-771>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I have a raid1-btrfs-system (Kernel 3.19.0-18-generic, Ubuntu Vivid Vervet, 
btrfs-tools 3.17-1.1). One disk failed some days ago. I could remount the 
remaining one with "-o degraded". After one day and some write-operations 
(with no errrors) I had to reboot the system. And now I can not mount "rw" 
anymore, only "-o degraded,ro" is possible.

In the kernel log I found BTRFS: too many missing devices, writeable mount is 
not allowed. 

I read about https://bugzilla.kernel.org/show_bug.cgi?id=60594 but I did no 
conversion to a single drive.

How can I mount the disk "rw" to remove the "missing" drive and add a new one? 
Because there are many snapshots of the filesystem, copying the system would 
be only the last alternative ;-)

Thanks

Martin
