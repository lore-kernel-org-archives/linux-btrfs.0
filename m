Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35367 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342AbcDFH0v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Apr 2016 03:26:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anhrP-0003Vr-Jg
	for linux-btrfs@vger.kernel.org; Wed, 06 Apr 2016 09:26:43 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Apr 2016 09:26:43 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Apr 2016 09:26:43 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: [PATCH] Btrfs: fix missing s_id setting
Date: Wed, 6 Apr 2016 09:26:35 +0200
Message-ID: <20160406092635.05f6c857@jupiter.sol.kaishome.de>
References: <201604050008.AA00001@WIN-5MHF4RKU941.jp.fujitsu.com>
	<57036FB8.5060409@oracle.com>
	<57037CD8.2020804@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 5 Apr 2016 17:52:40 +0900
schrieb Tsutomu Itoh <t-itoh@jp.fujitsu.com>:

> On 2016/04/05 16:56, Anand Jain wrote:
> > On 04/05/2016 08:08 AM, Tsutomu Itoh wrote:  
> >> When fs_devices->latest_bdev is deleted or is replaced, sb->s_id
> >> has not been updated.
> >> As a result, the deleted device name is displayed by btrfs_printk.
> >>
> >> [before fix]
> >>   # btrfs dev del /dev/sdc4 /mnt2
> >>   # btrfs dev add /dev/sdb6 /mnt2
> >>
> >>   [  217.458249] BTRFS info (device sdc4): found 1 extents
> >>   [  217.695798] BTRFS info (device sdc4): disk deleted /dev/sdc4
> >>   [  217.941284] BTRFS info (device sdc4): disk added /dev/sdb6
> >>
> >> [after fix]
> >>   # btrfs dev del /dev/sdc4 /mnt2
> >>   # btrfs dev add /dev/sdb6 /mnt2
> >>
> >>   [   83.835072] BTRFS info (device sdc4): found 1 extents
> >>   [   84.080617] BTRFS info (device sdc3): disk deleted /dev/sdc4
> >>   [   84.401951] BTRFS info (device sdc3): disk added /dev/sdb6  
> >
> >
> >   [PATCH 05/13] Btrfs: fix fs logging for multi device
> >
> >   any comments ?
> >
> >   We would want to maintain the logging prefix as constant, so that
> >   troubleshooters with filters/scripts will find it helpful.  
> 
> I think it is good to make the identifier constant for the
> troubleshooting. However, fsid(uuid) is a little long for the print
> purpose, I think. (But an appropriate value isn't found...)

How about setting this to a CRC16 of the fsid(uuid)?

Or a value which is increased at every new mount, then logging which
devices belong to this value if the devices change?

Like:

BTRFS info: pool id 1 has (/dev/sdc4, /dev/sdb6)
BTRFS info (pool 1): found 1 extents
...
 
I think the way btrfs magically assigns any member device to the pool
somehow feels uncomfortable anyways. Btrfs better should expose the
compound devices as single device nodes like maybe /dev/btrfs/pool0
etc.

Every time I boot my multi-device btrfs, according to mount, the
associated device changes (sometimes mount says /dev/sda1 is mounted,
the next time it's /dev/sdb1). This is not deterministic - and that is
almost always bad some way or another.

-- 
Regards,
Kai

Replies to list-only preferred.

