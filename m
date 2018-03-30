Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46953 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752639AbeC3URq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 16:17:46 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DDACDAD4A
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 20:17:45 +0000 (UTC)
Date: Fri, 30 Mar 2018 22:15:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs-progs: Enhance btrfs-image to handle missing
 device
Message-ID: <20180330201518.GW30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180330073528.20650-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180330073528.20650-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 30, 2018 at 03:35:25PM +0800, Qu Wenruo wrote:
> Can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/btrfs_image_fix
> 
> Bug report:
> https://github.com/kdave/btrfs-progs/issues/118
> 
> In short, the problem is caused by some old code (read_extent_data()
> from ancient btrfs check code) and offset-by-one from btrfs-image.
> Which makes btrfs-image can only read from the first stripe of RAID1.
> 
> And if device of the first stripe is missing, btrfs-image will fail.
> 
> Fix the problem and add test case for it.
> 
> Qu Wenruo (3):
>   btrfs-progs: disk-io: Fix read_extent_data() error handler for missing
>     device
>   btrfs-progs: convert: Fix offset-by-one error in read_data_extent()
>   btrfs-progs: tests/misc: Test if btrfs-image can handle RAID1 missing
>     device

1-3 applied, thanks. I'll reorder the uuid tree patch after those
patches so the test does not fail.
