Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:60541 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3GEOAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 10:00:30 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 88F8B9A0695
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2013 08:00:30 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>, Liu Bo <bo.li.liu@oracle.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130704040646.GA3577@localhost.localdomain>
CC: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
 <20130703203644.14981.18637@localhost.localdomain>
 <20130704040646.GA3577@localhost.localdomain>
Message-ID: <20130705140028.3855.65835@localhost.localdomain>
Subject: Re: [RFC PATCH 00/12] Btrfs-progs: introduce chunk recover function
Date: Fri, 5 Jul 2013 10:00:28 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Liu Bo (2013-07-04 00:06:47)
> On Wed, Jul 03, 2013 at 04:36:44PM -0400, Chris Mason wrote:
> > Quoting Miao Xie (2013-07-03 09:25:08)
> > > This patchset introduced chunk recover function, which was implemented by
> > > scanning the whoel disks in the filesystem. Now, we can recover Single,
> > > Dup, RAID1 chunks, and RAID0, RAID10, RAID5, RAID6 metadata chunks.
> > 
> > Really nice.  I've integrated this with Liu Bo's btrfs-image fixes and
> > put it into a branch called integration.  I've tested both repair and
> > image here, but if you could please double check the merge I'd
> > appreciate it.
> 
> We still need another patch to make image work(actually we need to initialize
> missing device's uuid to NULL).
> 
> It's the read_one_dev() part in
> 
> https://patchwork.kernel.org/patch/2787291/

Got it, thanks!

-chris
