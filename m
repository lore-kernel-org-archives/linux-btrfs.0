Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030450AbcCQMty (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 08:49:54 -0400
Date: Thu, 17 Mar 2016 13:49:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: use btrfs-debugfs to fetch block group
 information
Message-ID: <20160317124926.GT21722@suse.cz>
Reply-To: dsterba@suse.cz
References: <1452543022-9224-1-git-send-email-bo.li.liu@oracle.com>
 <20160316093649.GG21722@twin.jikos.cz>
 <20160317035925.GA29904@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160317035925.GA29904@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 16, 2016 at 08:59:26PM -0700, Liu Bo wrote:
> On Wed, Mar 16, 2016 at 10:36:49AM +0100, David Sterba wrote:
> > On Mon, Jan 11, 2016 at 12:10:22PM -0800, Liu Bo wrote:
> > > This aims to decide whether a balance can reduce the number of
> > > data block groups and if it is, this shows the '-dvrange' block
> > > group's objectid.
> > Applied. I consider btrfs-debugfs as a debugging utility only, without
> > guarantees of a stable output or commandline arugments.
> Yeah, one thing about this is that the debugfs is using
> btrfs_ioctl_search_args_v2, which may not be supported in old kernels,
> so it cannot be used before backporting struct
> btrfs_ioctl_search_args_v2, do we need to change it to
> btrfs_ioctl_search_args_v1?

V2 is available since 3.16, I don't think we need to update it to v1,
but would be nice of course.
