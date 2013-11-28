Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:56774 "EHLO
	postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab3K1UnU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 15:43:20 -0500
Received: from [192.168.0.1] (p4FDF0B8F.dip0.t-ipconnect.de [79.223.11.143])
	by postfix.iai.uni-bonn.de (Postfix) with ESMTP id 988E75C404
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Nov 2013 21:36:33 +0100 (MET)
	(envelope-from ochmann@informatik.uni-bonn.de)
	(envelope-to linux-btrfs@vger.kernel.org) (1)
	(internal use: ta=1, tu=1, te=1, am=P, au=ochmann)
Message-ID: <5297A950.3020100@informatik.uni-bonn.de>
Date: Thu, 28 Nov 2013 21:36:32 +0100
From: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: 2 errors when scrubbing - but I don't know what they mean
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

when I scrubbed one of my btrfs volumes today, the result of the scrub was:

total bytes scrubbed: 1.27TB with 2 errors
error details: super=2
corrected errors: 0, uncorrectable errors: 0, unverified errors: 0

and dmesg said:

btrfs: bdev /dev/mapper/tray errs: wr 0, rd 0, flush 0, corrupt 0, gen 1
btrfs: bdev /dev/mapper/tray errs: wr 0, rd 0, flush 0, corrupt 0, gen 2

Can someone please enlighten me what these errors mean (especially the 
"super" and "gen" values)? As an additional info: The drive is sometimes 
used in a machine with kernel 3.11.6 and sometimes with 3.12.0, could 
this swapping explain the problem somehow?

Best regards
Sebastian
