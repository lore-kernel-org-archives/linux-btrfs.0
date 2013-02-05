Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:44951 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab3BEOWl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2013 09:22:41 -0500
Date: Tue, 5 Feb 2013 15:22:36 +0100
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: experimental raid5/6 code in git
Message-ID: <20130205142236.GA6619@mother.jarsat.pl>
References: <20130202160212.GB4694@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130202160212.GB4694@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

  I believe XOR_BLOCKS must be selected, otherwise build fails with:
ERROR: "xor_blocks" [fs/btrfs/btrfs.ko] undefined!
 

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 4f5dc93..5f583c8 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -7,6 +7,7 @@ config BTRFS_FS
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	select RAID6_PQ
+	select XOR_BLOCKS
 
 	help
 	  Btrfs is a new filesystem with extents, writable snapshotting,

-- 
Tomasz   .. oo o.   oo o. .o   .o o. o. oo o.   ..
Torcz    .. .o .o   .o .o oo   oo .o .. .. oo   oo
o.o.o.   .o .. o.   o. o. o.   o. o. oo .. ..   o.

