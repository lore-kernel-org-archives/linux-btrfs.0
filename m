Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41118 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbeEKK6n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 06:58:43 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1FBD3AEA4
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 10:58:42 +0000 (UTC)
Date: Fri, 11 May 2018 12:56:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 3/3] btrfs: Do super block verification before writing
 it to disk
Message-ID: <20180511105603.GW6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180511053527.28378-1-wqu@suse.com>
 <20180511053527.28378-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180511053527.28378-4-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 01:35:27PM +0800, Qu Wenruo wrote:
> +/*
> + * Check the validation of super block at write time.
> + * Some checks like bytenr check will be skipped as their values will be
> + * overwritten soon.
> + * Extra checks like csum type and incompact flags will be executed here.
                                      ^^^^^^^^^

I almost missed it, it's 'incompat', short from 'incompatibility'

> +	if (btrfs_super_incompat_flags(sb) & ~BTRFS_FEATURE_INCOMPAT_SUPP) {
> +		ret = -EUCLEAN;
> +		btrfs_err(fs_info,
> +		"invalid incompact flags, has 0x%llu valid mask 0x%llu",
                         ^^^^^^^^^

Also fixed, as it's in a user visible string.

> +			  btrfs_super_incompat_flags(sb),
> +			  BTRFS_FEATURE_INCOMPAT_SUPP);
