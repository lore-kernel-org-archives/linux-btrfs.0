Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47883 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab3BVKbU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 05:31:20 -0500
Date: Fri, 22 Feb 2013 18:30:04 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Norbert Scheibner <scno@gmx.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Snapshot Cleaner not Working with inode_cache
Message-ID: <20130222103003.GF12835@liubo.cn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <CAKcLGm-Zk_8mZZUwz3Y-rsM-_ySFOSSR0OYcK2VU=2iYFQ=ZWA@mail.gmail.com>
 <20130220011431.GA4757@liubo.jp.oracle.com>
 <op.wswj5k0xr07q8e@tron.scheibner.rb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <op.wswj5k0xr07q8e@tron.scheibner.rb>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 22, 2013 at 11:16:22AM +0100, Norbert Scheibner wrote:
> Am 20.02.2013, 02:14 Uhr, schrieb Liu Bo <bo.li.liu@oracle.com>:
> 
> >I think I know why inode_cache keeps us from freeing space,
> >inode_cache adds
> >a cache_inode in each btrfs root, and this cache_inode will be
> >iput at the very
> >last of stage during umount, ie. after we do cleanup work on old
> >snapshot/subvols, where we free the space.
> >
> >A remount will force btrfs to do cleanup work on old snapshots
> >during mount.
> >
> >This may explain the situation.
> >
> >thanks,
> >liubo
> 
> I don't know how long the code behaves that way, but this is
> exactly what I see here on debian kernel 3.2.35.

A patch to fix it is now in btrfs-next, so we may not be bitten any more.

thanks,
liubo
