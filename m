Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48007 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbbJaLOJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Oct 2015 07:14:09 -0400
Received: from merkaba.localnet (ppp-62-216-209-156.dynamic.mnet-online.de [62.216.209.156])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 24303202
	for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2015 12:14:08 +0100 (CET)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Unclear error message when running btrfs check on a mountpoint
Date: Sat, 31 Oct 2015 12:14:07 +0100
Message-ID: <1773354.pT4juS7CCv@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

With kernel 4.3-rc7 and btrfs-progs 4.2.2 I get:

merkaba:~> btrfs check /daten
Superblock bytenr is larger than device size
Couldn't open file system


It took me a moment to see that I used a mountpoint and that this may be the
reason for the error message.

Maybe check for a device file as argument and give a clearer error message
in this case?

Thanks,
-- 
Martin
