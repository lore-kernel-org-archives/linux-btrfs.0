Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36328 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbbDTKtk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 06:49:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yk9Gk-0008LW-Hs
	for linux-btrfs@vger.kernel.org; Mon, 20 Apr 2015 12:49:38 +0200
Received: from p4ff58503.dip0.t-ipconnect.de ([79.245.133.3])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 12:49:38 +0200
Received: from holger.hoffstaette by p4ff58503.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 12:49:38 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: unable to mount a btrfs file system kernel 3.19.2
Date: Mon, 20 Apr 2015 10:49:31 +0000 (UTC)
Message-ID: <pan.2015.04.20.10.49.31@googlemail.com>
References: <5534D201.7080803@onsd.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 20 Apr 2015 12:16:33 +0200, Némoz Saint-Dizier, Olivier wrote:

> Hello everyone,
> 
> I have an issue with my ssd where a btrfs partition is located. I have a
> /dev/sdb1 in ext4 for the /boot, and the rest of the ssd is /dev/sdb2
> which is the root of my Archlinux. When I boot, it hangs up after
> loading the kernel. So I tried with an Archlinux liveboot, and I have
> the same behavior with the following trace in logs when I try to mount
> the btrfs partition :

[..snip]

> Apr 11 16:25:56 archiso kernel:  [<ffffffff811b5d1a>] ? kmem_cache_alloc+0x16a/0x180
> Apr 11 16:25:56 archiso kernel:  [<ffffffffa043f7ca>] ? btrfs_free_path+0x2a/0x40 [btrfs]
> Apr 11 16:25:56 archiso kernel:  [<ffffffffa04c3213>] ? __btrfs_run_delayed_items+0xf3/0x1d0 [btrfs]
> Apr 11 16:25:56 archiso kernel:  [<ffffffff8155e999>] schedule+0x29/0x70

> Is it a known bug? Or does someone have an idea about how I could fix
> this issue?

This hang on mount was caused by a backported fix to -stable, which you
probably caught after an update to 3.19.2.

The fix is in 3.19.5: commit 0187ad2b69a51a23924cd41f730e2d923535db80 in
https://kernel.org/pub/linux/kernel/v3.x/ChangeLog-3.19.5

So just get a fresh 3.19.5 (or directly 4.0) and it should mount again.

-h


