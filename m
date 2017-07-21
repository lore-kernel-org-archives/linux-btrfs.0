Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40160 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752091AbdGUQCO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 12:02:14 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3C3D4AD82
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jul 2017 16:02:13 +0000 (UTC)
Date: Fri, 21 Jul 2017 18:00:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Remove unused parameters from volume.c
 functions
Message-ID: <20170721160058.GK2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170718160917.GX2866@twin.jikos.cz>
 <1500450522-22086-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500450522-22086-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 19, 2017 at 10:48:42AM +0300, Nikolay Borisov wrote:
> This also adjusts the respective callers in other files. Those were found with
> -Wunused-parameter.
> 
> btrfs_full_stripe_len's mapping_tree - introduced by
> 53b381b3abeb ("Btrfs: RAID5 and RAID6") but it was never really used even in
> that commit
> 
> btrfs_is_parity_mirror's mirror_num - same as above
> 
> chunk_drange_filter's chunk_offset - introduced by 94e60d5a5c4b ("Btrfs: devid
> subset filter") and never used.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
