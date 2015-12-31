Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.mail.nexica.com ([217.13.116.85]:43375 "EHLO
	relay1.mail.nexica.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbbLaKlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 05:41:55 -0500
Received: from relay1.mail.nexica.com (zeus02nex.noc.nexica.com [10.2.0.151])
	by batchmail1.noc.nexica.com (Postfix) with ESMTP id 981FDFB085
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 10:52:22 +0100 (CET)
Received: from cl3-smtp.mail.nexica.com (zeus02nex.noc.nexica.com [10.2.0.151])
	by relay1.noc.nexica.com (Postfix) with ESMTP id 85160133390
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 10:52:17 +0100 (CET)
Received: from vnxbcnex02.bcn.nexica.com (unknown [212.92.38.69])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: relay.nexica.com)
	by cl3-smtp.mail.nexica.com (Postfix) with ESMTP id 8676912B454
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 10:52:17 +0100 (CET)
From: Xavier Romero <XRomero@nexica.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RAID10 question
Date: Thu, 31 Dec 2015 09:52:16 +0000
Message-ID: <47770e1d8a804d31994eebaf733adf55@nex-exchng-01-v.bcn.nexica.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have 2 completely independent set of 12 disks each, let's name them A1, A2, A3... A12 for first set, and B1, B2, B3...B12 for second set. For availability purposes I want disks to be paired that way:
A1 <--> B1: RAID1
A2 <--> B2: RAID1
...
A12 <--> B12: RAID1

And then I want a RAID0 out of all these RAID1.

I know I can achieve that by doing all the RAID1 with MD and then build the RAID0 with BTRFS. But my question is: can I achieve that directly with BTRFS RAID10?

Best regards,
Xavier Romero
