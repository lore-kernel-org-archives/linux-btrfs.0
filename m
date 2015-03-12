Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34215 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbbCLUP3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Mar 2015 16:15:29 -0400
Date: Fri, 13 Mar 2015 04:15:08 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] Revert "Btrfs: allow superblock mismatch from older mkfs"
Message-ID: <20150312201508.GB10724@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1426138847-10851-1-git-send-email-bo.li.liu@oracle.com>
 <550127E1.4050606@cn.fujitsu.com>
 <20150312173414.GE20767@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150312173414.GE20767@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 12, 2015 at 06:34:15PM +0100, David Sterba wrote:
> On Thu, Mar 12, 2015 at 01:45:05PM +0800, Qu Wenruo wrote:
> > I sent such patch some time ago but was rejected by Chris,
> > hopes this time it can be accepted.
> 
> http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg34937.html
> 
> I'm OK with removing the special case now because there are additional
> supreblock checks merged (3.19) that were motivated by your previous
> attempt to remove it.

So David, are you going to take the above patch instead?

I'm okay with that since they're exactly same, but it'd be good that Qu has its commit log updated.

Thanks,

-liubo

> 
> o btrfs: add more checks to btrfs_read_sys_array
> o btrfs: cleanup, rename a few variables in btrfs_read_sys_array
> o btrfs: add checks for sys_chunk_array sizes
> o btrfs: more superblock checks, lower bounds on devices and sectorsize/nodesize
> 
> 
