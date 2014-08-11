Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35108 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751841AbaHKDH4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 23:07:56 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [BUG] btrfs send/receive, page allocation failure
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAL3q7H591BbVenxFn_EiBDyqmJEcwgOKjw0Xv2J+jkgic+3dxQ@mail.gmail.com>
Date: Sun, 10 Aug 2014 21:07:54 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <16C9BBD0-FD7B-488B-A77F-E937007F292F@colorremedies.com>
References: <2BBB0EBF-DD55-45B4-8BF5-F8DAA9398A4F@colorremedies.com> <CF539008-5930-447D-B26C-2A2BBE9337EA@colorremedies.com> <CAL3q7H591BbVenxFn_EiBDyqmJEcwgOKjw0Xv2J+jkgic+3dxQ@mail.gmail.com>
To: fdmanana@gmail.com
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 
> 
> Can you try the following patch and confirm if it helps?
> https://patchwork.kernel.org/patch/4705171/

This one applies without problems, I didn't build it because I saw v4. The v4 patch I get:

+ patch -p1 -F1 -s
4 out of 4 hunks FAILED -- saving rejects to file fs/btrfs/send.c.rej

Should v4 alone be applied over 3.16.0? Or each version in succession?


Chris Murphy