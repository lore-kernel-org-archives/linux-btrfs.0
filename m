Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34317 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759730AbbBIUIE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:08:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YKuck-00004z-HI
	for linux-btrfs@vger.kernel.org; Mon, 09 Feb 2015 21:08:02 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 21:08:02 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 21:08:02 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs performance, sudden drop to 0 IOPs
Date: Mon, 09 Feb 2015 20:56:29 +0100
Message-ID: <d0gnqb-u59.ln1@hurikhan77.spdns.de>
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

P. Remek <p.remek1@googlemail.com> schrieb:

> Hello,
> 
> I am benchmarking Btrfs and when benchmarking random writes with fio
> utility, I noticed following two things:
> 
> 1) On first run when target file doesn't exist yet, perfromance is
> about 8000 IOPs. On second, and every other run, performance goes up
> to 70000 IOPs. Its massive difference. The target file is the one
> created during the first run.
> 
> 2) There are windows during the test where IOPs drop to 0 and stay 0
> about 10 seconds and then it goes back again, and after couple of
> seconds again to 0. This is reproducible 100% times.
> 
> Can somobody shred some light on what's happening?

I'm not an expert or dev but it's probably due to btrfs doing some 
housekeeping under the hood. Could you check the output of "btrfs filesystem 
usage /mountpoint" while running the test? I'd guess there's some pressure 
on the global reserve during those times.

> Command: fio --randrepeat=1 --ioengine=libaio --direct=1
> --gtod_reduce=1 --name=test9 --filename=test9 --bs=4k --iodepth=256
> --size=10G --numjobs=1 --readwrite=randwrite
> 
> Environment:
> CPU: dual socket: E5-2630 v2
>    RAM: 32 GB ram
>    OS: Ubuntu server 14.10
>    Kernel: 3.19.0-031900rc2-generic
>    btrfs tools: Btrfs v3.14.1
>    2x LSI 9300 HBAs - SAS3 12/Gbs
>    8x SSD Ultrastar SSD1600MM 400GB SAS3 12/Gbs
> 
> Regards,
> Premek

-- 
Replies to list only preferred.

