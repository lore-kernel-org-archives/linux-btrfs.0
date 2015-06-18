Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44609 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbFRCq2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 22:46:28 -0400
Date: Thu, 18 Jun 2015 10:46:09 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, fdmanana@suse.com
Subject: Re: [RFC PATCH v2 1/2] Btrfs: add noi_version option to disable
 MS_I_VERSION
Message-ID: <20150618024607.GA8530@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1434527672-5762-1-git-send-email-bo.li.liu@oracle.com>
 <20150617153306.GY6761@twin.jikos.cz>
 <20150617155234.GB7773@localhost.localdomain>
 <20150617170118.GA6761@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150617170118.GA6761@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 17, 2015 at 07:01:18PM +0200, David Sterba wrote:
> On Wed, Jun 17, 2015 at 11:52:36PM +0800, Liu Bo wrote:
> > On Wed, Jun 17, 2015 at 05:33:06PM +0200, David Sterba wrote:
> > > On Wed, Jun 17, 2015 at 03:54:31PM +0800, Liu Bo wrote:
> > > > MS_I_VERSION is enabled by default for btrfs, this adds an alternative
> > > > option to toggle it off.
> > > 
> > > There's an existing generic iversion/noiversion mount option pair, no
> > > need to extra add it to btrfs.
> > 
> > I know, it doesn't work though.
> 
> Sigh, I see, btrfs forces MS_I_VERSION flag,
> 0c4d2d95d06e920e0c61707e62c7fffc9c57f63a. I read 'enabled by default' as
> that there's a standard way to override the defaults.
> 
> So the right way is not to do that but this will break everyhing that
> relies on that behaviour at the moment. This means to add the exception
> to the upper layers, either VFS or 'mount', which is not very likely to
> happen.
> 
> The generic options do not reach the filesystem specific callbacks, so
> we can't check it.

Ext4 also makes its own "i_version" option, so I think we can do the
same thing until more filesystems require to do it in a generic way.

The performance benefit with no_iversion is obvious for fsync
related workloads since we would avoid some expensive log commits.

Thanks,

-liubo
