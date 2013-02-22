Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36680 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826Ab3BVKTs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 05:19:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1U8pjX-00014a-Or
	for linux-btrfs@vger.kernel.org; Fri, 22 Feb 2013 11:20:03 +0100
Received: from p5dc4a285.dip.t-dialin.net ([93.196.162.133])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 11:20:03 +0100
Received: from scno by p5dc4a285.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 11:20:03 +0100
To: linux-btrfs@vger.kernel.org
From: "Norbert Scheibner" <scno@gmx.net>
Subject: Re: Snapshot Cleaner not Working with inode_cache
Date: Fri, 22 Feb 2013 11:16:22 +0100
Message-ID: <op.wswj5k0xr07q8e@tron.scheibner.rb>
References: <CAKcLGm-Zk_8mZZUwz3Y-rsM-_ySFOSSR0OYcK2VU=2iYFQ=ZWA@mail.gmail.com> <20130220011431.GA4757@liubo.jp.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 20.02.2013, 02:14 Uhr, schrieb Liu Bo <bo.li.liu@oracle.com>:

> I think I know why inode_cache keeps us from freeing space, inode_cache  
> adds
> a cache_inode in each btrfs root, and this cache_inode will be iput at  
> the very
> last of stage during umount, ie. after we do cleanup work on old
> snapshot/subvols, where we free the space.
>
> A remount will force btrfs to do cleanup work on old snapshots during  
> mount.
>
> This may explain the situation.
>
> thanks,
> liubo

I don't know how long the code behaves that way, but this is
exactly what I see here on debian kernel 3.2.35.

Norbert

