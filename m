Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s2.hotmail.com ([65.55.116.13]:59669 "EHLO
	BLU004-OMC1S2.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbcFETmj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 15:42:39 -0400
Message-ID: <BLU436-SMTP235FBB8882371723DF217EA925B0@phx.gbl>
To: linux-btrfs@vger.kernel.org
From: Alberto Bursi <alberto.bursi@outlook.it>
Subject: check if hardware checksumming works or not
Date: Sun, 5 Jun 2016 21:37:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi, I'm running Debian ARM on a Marvell Kirkwood-based 2-disk NAS.

Kirkwood SoCs have a XOR engine that can hardware-accelerate crc32c 
checksumming, and from what I see in kernel mailing lists it seems to 
have a linux driver and should be supported.

I wanted to ask if there is a way to test if it is working at all.

How do I force btrfs to use software checksumming for testing purposes?


Thanks


-Albert
