Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm17-vm4.bullet.mail.ir2.yahoo.com ([212.82.96.219]:48071 "EHLO
	nm17-vm4.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752833AbaETNuL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 09:50:11 -0400
References: 
Message-ID: <1400593810.31610.YahooMailNeo@web172206.mail.ir2.yahoo.com>
Date: Tue, 20 May 2014 14:50:10 +0100 (BST)
From: Astro Xe <astroxeu@yahoo.it>
Reply-To: Astro Xe <astroxeu@yahoo.it>
Subject: btrfs fi df output is not updated in a timely manner after subvolumes have been deleted
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On my box, the "used" value in the output of "btrfs filesystem df" is not updated in a timely manner, after that one or more subvolumes have been deleted. I need to execute "btrfs filesystem sync", in order to update the value.

How do I fix this? Or, could someone fix this in btrfs-progs, please?

I suspect the cause is that subvolumes are marked immediately as deleted, but cleaned up at a later time, is this right?

Thanks,

