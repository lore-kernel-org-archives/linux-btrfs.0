Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36508 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbcFBQls (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jun 2016 12:41:48 -0400
Date: Thu, 2 Jun 2016 18:41:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: bo.li.liu@oracle.com, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v3 05/22] btrfs-progs: Introduce function to setup
 temporary superblock
Message-ID: <20160602164108.GH29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1454043812-7893-6-git-send-email-quwenruo@cn.fujitsu.com>
 <20160528030459.GA31255@localhost.localdomain>
 <9cd7dc82-184b-e5f0-0b7e-d359820202d2@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9cd7dc82-184b-e5f0-0b7e-d359820202d2@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 29, 2016 at 06:52:41PM +0800, Qu Wenruo wrote:
> >> +	btrfs_set_super_leafsize(super, cfg->nodesize);
> >> +	btrfs_set_super_nodesize(super, cfg->nodesize);
> >> +	btrfs_set_super_stripesize(super, cfg->stripesize);
> >> +	btrfs_set_super_csum_type(super, BTRFS_CSUM_TYPE_CRC32);
> >> +	btrfs_set_super_chunk_root(super, chunk_bytenr);
> >> +	btrfs_set_super_cache_generation(super, -1);
> >> +	btrfs_set_super_incompat_flags(super, cfg->features);
> >> +	if (cfg->label)
> >> +		strncpy(super->label, cfg->label, BTRFS_LABEL_SIZE - 1);
> >
> > Why not use __strncpy_null?
> 
> Good idea, I'll add new patch to use it.

I've updated it in the patch, there was one more that used strncpy and
coverity reported it.
