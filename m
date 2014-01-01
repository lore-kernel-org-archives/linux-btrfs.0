Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35979 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754644AbaAAV6Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jan 2014 16:58:24 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:55526 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1VyTnz-001jKH-Aq
	for linux-btrfs@vger.kernel.org; Wed, 01 Jan 2014 14:58:23 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: coredump in btrfsck
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52C4884F.6040000@gmail.com>
Date: Wed, 1 Jan 2014 14:58:25 -0700
Message-Id: <45E0985F-4F75-47D1-BD6E-2286D5844AE3@colorremedies.com>
References: <52C4884F.6040000@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 1, 2014, at 2:27 PM, Oliver Mangold <o.mangold@gmail.com> wrote:

> I fear, I broke my FS by running btrfsck. I tried 'btrfsck --repair' and it fixed several problems but finally crashed with some debug message from 'extent-tree.c', so I also tried 'btrfsck --repair --init-extent-tree'.

It is sort of a (near) last restort, you know this right? What did you try before btrfsck? Did you set dmesg -n7, then mount -o recovery and if so what was recorded in dmesg?

> 
> produces log messages:
> 
> Jan 01 21:45:09 home kernel: btrfs: device fsid 31a5d433-4f7b-49cc-9bc0-9422471f5194 devid 1 transid 4793 /dev/mapper/primary-home
> Jan 01 21:45:09 home kernel: btrfs: disk space caching is enabled
> Jan 01 21:45:09 home kernel: parent transid verify failed on 2176851968 wanted 4792 found 4793
> Jan 01 21:45:09 home kernel: parent transid verify failed on 2176851968 wanted 4792 found 4793
> Jan 01 21:45:09 home kernel: btrfs: open_ctree failed

If you previously tried -o recovery, before btrfsck did you try btrfs-zero-log and if so what were the results in console and in dmesg?


Chris Murphy

