Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:38757 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752629AbaGTBLE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jul 2014 21:11:04 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: ENOSPC errors during balance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140719225810.7a28d13b@marcec>
Date: Sat, 19 Jul 2014 19:11:00 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <CE7F2F5A-8807-44B1-BD4E-F6BF02D88F9C@colorremedies.com>
References: <20140719221051.57378a41@marcec> <20140719225810.7a28d13b@marcec>
To: Marc Joliet <marcec@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm seeing this also in the 2nd dmesg:

[  249.893310] BTRFS error (device sdg2): free space inode generation (0) did not match free space cache generation (26286)


So you could try umounting the volume. And doing a one time mount with the clear_cache mount option. Give it some time to rebuild the space cache.

After that you could umount again, and mount with enospc_debug and try to reproduce the enospc with another balance and see if dmesg contains more information this time.


Chris Murphy