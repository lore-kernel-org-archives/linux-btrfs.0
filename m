Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33790 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751906AbaKCSig convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Nov 2014 13:38:36 -0500
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:55353 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XlMWQ-003Ge9-Ui
	for linux-btrfs@vger.kernel.org; Mon, 03 Nov 2014 11:38:35 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Can't mount: open_ctree failed!
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <m35i04$u5p$1@ger.gmane.org>
Date: Mon, 3 Nov 2014 11:38:35 -0700
Message-Id: <55F19B93-4AF2-4A43-82D5-425433DF006B@colorremedies.com>
References: <m35i04$u5p$1@ger.gmane.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 2, 2014, at 8:18 AM, Florian Lindner <mailinglists@xgm.de> wrote:

> Hello,
> 
> all after sudden I can't mount my btrfs home partition anymore. System is 
> Arch with kernel 3.17.2, but I use snapper which does snapshopts regularly 
> and I had 3.17.1 before, which afaik had some problems with snapshops.

It was with creating read-only snapshots. I forget if snapper's snapshots are ro. If they are then you need to use 3.17 btrfs-progs to fix it.


> # btrfsck --init-extent-tree /dev/sdb1
> root 3377 has a root item with a more recent gen (8589934592) compared to 
> the found root node (49443)
> 
> # btrfsck --init-csum-tree /dev/sdb1
> Creating a new CRC tree
> root 3377 has a root item with a more recent gen (8589934592) compared to 
> the found root node (49443)

Did you use btrfs-image before using --repair?

Once you've done an init-extent-tree and it still won't mount, you're almost certainly in btrfs restore territory. Get the data out while you still can. And then you can check the recent patches from Josef for fsck that aren't yet in btrfs-progs 3.17. I'm not sure if they're in David's master branch, worth checking. There's a good chance it won't make things worse, might even fix the file system, but there's a fair chance it'll totally toast it. So definitely btrfs restore important stuff first.



Chris Murphy