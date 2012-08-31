Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dub0-omc1-s1.dub0.hotmail.com ([157.55.0.200]:32222 "EHLO
	dub0-omc1-s1.dub0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703Ab2HaOqA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Aug 2012 10:46:00 -0400
Message-ID: <DUB117-W3224DDE372041F789CA47FB5A60@phx.gbl>
From: Ben Wreder <benwreder@hotmail.com>
To: <linux-btrfs@vger.kernel.org>
Subject: Tail packing
Date: Fri, 31 Aug 2012 16:40:36 +0200
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


The disk format description implies that btrfs should be able to support tail packing. I just did some experimentation, and while small files are packed, it seems that files occupying more than one block are not. For example, a lot of 32769-byte files will end up taking over 36KB on average (a small excess due to the metadata itself).

So just to confirm - btrfs does not currently support tail-packing, is that correct?

If so, is it a planned feature?

Thanks.
 		 	   		  