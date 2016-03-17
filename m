Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16885 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbcCQD7i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 23:59:38 -0400
Date: Wed, 16 Mar 2016 20:59:26 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH] Btrfs-progs: use btrfs-debugfs to fetch block group
 information
Message-ID: <20160317035925.GA29904@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1452543022-9224-1-git-send-email-bo.li.liu@oracle.com>
 <20160316093649.GG21722@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160316093649.GG21722@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 16, 2016 at 10:36:49AM +0100, David Sterba wrote:
> On Mon, Jan 11, 2016 at 12:10:22PM -0800, Liu Bo wrote:
> > From: liub.liubo@gmail.com <boliu23@localhost.localdomain>
> > 
> > This aims to decide whether a balance can reduce the number of
> > data block groups and if it is, this shows the '-dvrange' block
> > group's objectid.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Applied. I consider btrfs-debugfs as a debugging utility only, without
> guarantees of a stable output or commandline arugments.

Yeah, one thing about this is that the debugfs is using btrfs_ioctl_search_args_v2, which may not be supported in old kernels, so it cannot be used before backporting struct btrfs_ioctl_search_args_v2, do we need to change it to btrfs_ioctl_search_args_v1?

Thanks,

-liubo
