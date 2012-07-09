Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:60961 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab2GISQ2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Jul 2012 14:16:28 -0400
Date: Mon, 9 Jul 2012 14:16:24 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Shawn Landden <shawnlandden@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] fix unaligned memory accesses (Closes: #656955)
Message-ID: <20120709181624.GU7159@shiny>
References: <1341625062-13044-1-git-send-email-shawnlandden@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1341625062-13044-1-git-send-email-shawnlandden@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 06, 2012 at 07:37:42PM -0600, Shawn Landden wrote:
> From: Shawn Landen <shawnlandden@gmail.com>
> 
> Fix creation of volumes using mkfs.btrfs on armv5.

[ use memcpy instead of direct structure accesses ]

Thanks for the patch.  This should be a problem in the way gcc is run.
The kernel uses the same functions without memcpy, so there must be a
way to get gcc to turn the unaligned access into something arch safe.

-chris
