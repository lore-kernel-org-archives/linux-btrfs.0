Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailcloud.dogado.de ([37.218.251.62]:42095 "EHLO
	mailcloud.dogado.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbcAWTur (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 14:50:47 -0500
Received: from turboconrad.planet-school.de (mail.planet-school.de [194.116.187.5])
	by mailcloud.dogado.de (Postfix) with ESMTPS id 0EA965C2D5A
	for <linux-btrfs@vger.kernel.org>; Sat, 23 Jan 2016 20:44:14 +0100 (CET)
Received: from chaos-desktop.localnet (dslb-178-002-044-004.178.002.pools.vodafone-ip.de [178.2.44.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: stephan@albapasser.de)
	by turboconrad.planet-school.de (Postfix) with ESMTPSA id 2AC15C889C
	for <linux-btrfs@vger.kernel.org>; Sat, 23 Jan 2016 20:44:14 +0100 (CET)
From: Stephan Olbrich <stephan@albapasser.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs receive fails
Date: Sat, 23 Jan 2016 20:44:12 +0100
Message-ID: <2928754.CoMICLlXAW@chaos-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have three btrfs volumes. I do daily snapshots and transfer them to another 
drive. This works fine for two of the volumes, for the 3. one the send works 
fine but the receive sometimes fails with the following output:

ERROR: unlink o128782-4421-0 failed. No such file or directory

The o128782-4421-0 is different each time but it is always "o" and then some 
numbers.
My current workaround is to do the send with another parent (-p)

The problematic volume is my data partition and usually not much happening 
there besides the owncloud-client writing some status files (sqlite database).

# uname -a
Linux chaos-desktop 4.2.1-040201-generic #201509211431 SMP Mon Sep 21 18:34:44 
UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.0

Regards,
Stephan

