Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850AbcEFOfs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 May 2016 10:35:48 -0400
Date: Fri, 6 May 2016 16:35:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: bo.li.liu@oracle.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        vegard.nossum@oracle.com, dsterba@suse.com
Subject: Re: [PATCH 1/2] Btrfs: add more valid checks for superblock
Message-ID: <20160506143529.GD29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
 <9fa04dd7-13c4-6c24-dddc-4521eccea65c@cn.fujitsu.com>
 <20160504132329.GT29353@twin.jikos.cz>
 <20160504174436.GB14909@localhost.localdomain>
 <a7811da3-06f5-2ff2-06e4-19be9fd31410@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a7811da3-06f5-2ff2-06e4-19be9fd31410@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 05, 2016 at 09:08:54AM +0800, Qu Wenruo wrote:
> >> An early check can compare against some reasonable value, but the
> >> total_bytes value must be equal to the sum of all device sizes
> >> (disk_total_bytes). I'm not sure if we have enough information to verify
> >> that at this point though.
> >
> > That's what I had in mind, the problem is that only the first device information is recorded in superblock.
> >
> > At this moment We have device_num but we don't know the size of other devices.
> >
> > Thanks,
> >
> > -liubo
> >
> >
> What about error out if we found sb->total_bytes < 
> sb->dev_item->total_bytes?
> 
> As we are just doing early check, no need to be comprehensive, but spot 
> obvious problem.

Ok.

> For exact device_num and sb->total_bytes, we may do post check when 
> device tree are loaded?
> Splitting early_check() and post_check() seems valid for me.
> (Also I prefer post_check() just warning, not forced exit)

Why just warning? Superblock total_bytes and device sizes must be
correct, otherwise all sorts of operations can fail randomly.
