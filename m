Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout.artfiles.de ([80.252.97.80]:43793 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934643AbaEFKKC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 06:10:02 -0400
Received: from [132.230.80.54] (helo=discus.localnet)
	smtp-after-pop=wir@brain-frog.de
	by mailout.artfiles.de with esmtps (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80.1)
	id 1Whc3X-0003Af-GJ
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 11:52:59 +0200
From: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
To: linux-btrfs@vger.kernel.org
Subject: Scrub status: no stats available
Date: Tue, 06 May 2014 11:52:58 +0200
Message-ID: <1839807.xjkknF9CU6@discus>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list,

I am running btrfs on Arch Linux ARM (Linux 3.14.2, Btrfs v3.14.1). I can run 
scrub w/o errors, but I never get stats from scrub status

What I get is
   btrfs scrub status /pools/dataPool
   
   scrub status for b5f082e2-2ce0-4f91-b54b-c2d26185a635
           no stats available
           total bytes scrubbed: 694.13GiB with 0 errors

Please mind the line "no stats available". Where can I start digging?

Thank you,
Wolfgang


