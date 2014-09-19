Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s22.hotmail.com ([65.55.116.33]:50257 "EHLO
	BLU004-OMC1S22.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756107AbaISSPW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 14:15:22 -0400
Message-ID: <BLU406-EAS1974279D81BF03735D65B479AB40@phx.gbl>
Content-Type: text/plain; charset="us-ascii"
Subject: Single disk parrallelization
From: Jeb Thomson <jet00159@outlook.com>
Date: Fri, 19 Sep 2014 13:10:10 -0500
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0 (1.0)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the advanced features of btrfs, it would be an additional simple task to make different platters run in parallel. 

In this case, say a disk has three platters, and so three seek heads as well. If we can identify that much, and what offsets they are at, it then becomes a trivial matter to place the reads and writes to different platters at the same time. 

In affect, this means each platter should be operating as a single virtualized unit, instead of one single unit...

Regards,
