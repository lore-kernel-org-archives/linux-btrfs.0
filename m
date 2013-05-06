Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55311 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971Ab3EFUjZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 16:39:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZSBv-0004YD-P2
	for linux-btrfs@vger.kernel.org; Mon, 06 May 2013 22:39:23 +0200
Received: from host-091-097-225-022.ewe-ip-backbone.de ([91.97.225.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 06 May 2013 22:39:23 +0200
Received: from hurikhan77+btrfs by host-091-097-225-022.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 06 May 2013 22:39:23 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: [RFC 0/5] BTRFS hot relocation support
Date: Mon, 06 May 2013 22:36:03 +0200
Message-ID: <gqgl5a-4s5.ln1@hurikhan.ath.cx>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

zwu.kernel@gmail.com <zwu.kernel@gmail.com> schrieb:

>   The patchset is trying to introduce hot relocation support
> for BTRFS. In hybrid storage environment, when the data in
> HDD disk get hot, it can be relocated to SSD disk by BTRFS
> hot relocation support automatically; also, if SSD disk ratio
> exceed its upper threshold, the data which get cold can be
> looked up and relocated to HDD disk to make more space in SSD
> disk at first, and then the data which get hot will be relocated
> to SSD disk automatically.

How will it compare to bcache? I'm currently thinking about buying an SSD 
but bcache requires some efforts in migrating the storage to use. And after 
all those hassles I am even not sure if it would work easily with a dracut 
generated initramfs.

Bcache seems to be quite clever with its approach. This one looks completely 
different and more targetted to relocate data which is used often instead of 
trying to reduce head movement. I'm quite happy with the throuput of my 3x 
HDD btrfs pool (according to bootchart up to 600 MB/s during boot). A single 
SSD would be slower since head movement seems not to be the issue during 
boot. Will this patch relocate such data? Or does it try to relocate only 
data which requires random head movement?

Thanks,
Kai

