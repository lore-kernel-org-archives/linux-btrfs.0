Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53852 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbaEBRzV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 May 2014 13:55:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WgHg8-00087t-9c
	for linux-btrfs@vger.kernel.org; Fri, 02 May 2014 19:55:20 +0200
Received: from 5ED60B40.cm-7-7a.dynamic.ziggo.nl ([94.214.11.64])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 May 2014 19:55:20 +0200
Received: from jaap by 5ED60B40.cm-7-7a.dynamic.ziggo.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 May 2014 19:55:20 +0200
To: linux-btrfs@vger.kernel.org
From: Jaap Pieroen <jaap@pieroen.nl>
Subject: Re: "csum failed" that was not detected by scrub
Date: Fri, 2 May 2014 17:55:10 +0000 (UTC)
Message-ID: <loom.20140502T195018-784@post.gmane.org>
References: <CAOwjQU4GP5PjdPZx8HPihS7GQOA74M+DexwMWoh1FOQP0tCTcw@mail.gmail.com> <CAP9B-Q=GBUSx-MAwx=QQ5hMwAcCAS3GJCZ3g_u5snDkWfaq-Hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shilong Wang <wangshilong1991 <at> gmail.com> writes:

> 
> Hello,
> 
> There is a known RAID5/6 bug, i sent a patch to address this problem.
> Could you please double check if your kernel source includes the
> following commit:
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?
id=3b080b2564287be91605bfd1d5ee985696e61d3c
> 
> RAID5/6 should detect checksum mismatch, it can not fix errors now.
> 
> Thanks,
> Wang

Your patch seems to be in 3.15rc1:
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.15-rc1-trusty/CHANGES

I tried rc3 but that made my system crash on boot.. I'm having bad luck

