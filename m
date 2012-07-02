Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.mathematik.uni-freiburg.de ([132.230.30.5]:36692 "EHLO
	email.mathematik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720Ab2GBLYa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 07:24:30 -0400
Received: from tux00.mathematik.uni-freiburg.de ([132.230.30.32])
	by email.mathematik.uni-freiburg.de with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <ziegler@email.mathematik.uni-freiburg.de>)
	id 1SleZu-0007Cx-Ly
	for linux-btrfs@vger.kernel.org; Mon, 02 Jul 2012 13:14:02 +0200
Received: from ziegler by tux00.mathematik.uni-freiburg.de with local (Exim 4.72)
	(envelope-from <ziegler@email.mathematik.uni-freiburg.de>)
	id 1SleSZ-0005Np-L0
	for linux-btrfs@vger.kernel.org; Mon, 02 Jul 2012 13:06:27 +0200
Date: Mon, 02 Jul 2012 13:06:27 +0200
Reply-To: Martin Ziegler <ziegler@uni-freiburg.de>
To: linux-btrfs@vger.kernel.org
Subject: kmem_cache_destroy called for cache that still has objects
Message-ID: <alpine.DEB.2.02.1207021300430.16800@zertz.mathematik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
From: Martin Ziegler <ziegler@email.mathematik.uni-freiburg.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I umounted my USB-disk today, I got the following 
message:

FSSync '/usb'
=============================================================================
BUG btrfs_transaction_cache (Tainted: G        W   ):
  Objects remaining on kmem_cache_close()
-----------------------------------------------------------------------------

INFO: Slab 0xffffea00001c7580 objects=27 used=1
  fp=0xffff8800071d7e10 flags=0x4000000000004080
INFO: Object 0xffff8800071d6250 @offset=592
SLUB btrfs_transaction_cache: kmem_cache_destroy called for
  cache that still has objects.


This had no bad consequences (I hope), but may interest the 
developers. The kernel is

Linux zertz 3.5.0-rc4+ #278 SMP Thu Jun 28 21:17:37 CEST 
2012 x86_64 GNU/Linux.

Regards,

Martin
