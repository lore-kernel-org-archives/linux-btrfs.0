Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34556 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753038AbdLEX5K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Dec 2017 18:57:10 -0500
Date: Tue, 5 Dec 2017 15:55:02 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] Btrfs: make raid6 rebuild retry more
Message-ID: <20171205225501.GC18865@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20171204224037.7556-1-bo.li.liu@oracle.com>
 <20171204224037.7556-4-bo.li.liu@oracle.com>
 <1ab2da20-6294-67a4-2ef3-6a65afed0fc6@gmx.com>
 <20171205180925.GO3553@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171205180925.GO3553@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 05, 2017 at 07:09:25PM +0100, David Sterba wrote:
> On Tue, Dec 05, 2017 at 04:07:35PM +0800, Qu Wenruo wrote:
> > > @@ -2166,11 +2166,21 @@ int raid56_parity_recover(struct btrfs_fs_info *fs_info, struct bio *bio,
> > >  	}
> > >  
> > >  	/*
> > > -	 * reconstruct from the q stripe if they are
> > > -	 * asking for mirror 3
> > > +	 * Loop retry:
> > > +	 * for 'mirror == 2', reconstruct from all other stripes.
> > 
> > What about using macro to makes the reassemble method more human readable?
> 
> Yeah, that's definetelly needed and should be based on
> BTRFS_MAX_MIRRORS, not just hardcoded to 3.

OK.

In case of raid5/6, BTRFS_MAX_MIRRORS is an abused name, it's more a
raid1/10 concept, either BTRFS_RAID56_FULL_REBUILD or
BTRFS_RAID56_FULL_CHK is better to me, which one do you guys like?

Thanks,

-liubo
