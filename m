Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36392 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752589AbeA3Nux (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 08:50:53 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 505EAAC7E
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 13:50:52 +0000 (UTC)
Date: Tue, 30 Jan 2018 14:48:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Add chunk allocation ENOSPC debug message for
 enospc_debug mount option
Message-ID: <20180130134840.GE19355@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180115061352.13799-1-wqu@suse.com>
 <20180122055054.7933-1-wqu@suse.com>
 <3e152104-2a67-5677-dea5-4863de26aa78@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3e152104-2a67-5677-dea5-4863de26aa78@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 22, 2018 at 10:11:44AM +0200, Nikolay Borisov wrote:
> > @@ -4731,6 +4740,12 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
> >  
> >  	if (ndevs < devs_increment * sub_stripes || ndevs < devs_min) {
> >  		ret = -ENOSPC;
> > +		if (btrfs_test_opt(info, ENOSPC_DEBUG)) {
> > +			btrfs_debug(info,
> > +		"%s: not enough devices with free space: have=%d minimal required=%d",
> 
> nit: s/minimal/minimum
> But there is no point in resending just for that, I guess David could
> fix it while merging.

Yes, string updated and added to next, thanks.
