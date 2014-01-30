Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpksrv1.mitre.org ([198.49.146.77]:52179 "EHLO
	smtpksrv1.mitre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbaA3ViH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 16:38:07 -0500
Received: from smtpksrv1.mitre.org (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 59DD41F0467
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 16:27:56 -0500 (EST)
Received: from IMCCAS02.MITRE.ORG (imccas02.mitre.org [129.83.29.79])
	by smtpksrv1.mitre.org (Postfix) with ESMTP id 37C301F045C
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 16:27:56 -0500 (EST)
From: "Maziarz, Jeremy M." <jmaziarz@mitre.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Stop using btrfs
Date: Thu, 30 Jan 2014 21:27:55 +0000
Message-ID: <CC0E5F0A-26F9-46B9-9C24-1DDD1FF72004@mitre.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Everyone, here is a noob question: how do completely delete a btrfs filesystem (RAID10)?

$ sudo btrfs filesystem show
Label: none  uuid: 0ee72c25-9169-4836-873d-468ebdea8c1a
	Total devices 4 FS bytes used 92.00KB
	devid    1 size 1.82TB used 76.02GB path /dev/sda
	devid    2 size 1.82TB used 76.00GB path /dev/sdb
	devid    3 size 1.82TB used 76.01GB path /dev/sdd
	devid    4 size 1.82TB used 76.01GB path /dev/sde

Btrfs Btrfs v0.19

Thanks,
Jeremy