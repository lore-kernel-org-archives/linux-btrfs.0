Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35950 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755887AbeDZNEG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 09:04:06 -0400
Date: Thu, 26 Apr 2018 15:01:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] enhance btrfs_raid_array[]
Message-ID: <20180426130129.GR21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180425110144.12871-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180425110144.12871-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 25, 2018 at 07:01:41PM +0800, Anand Jain wrote:
> Cleanup patches as in the individual change log.
> 
> These patches were sent independently as they aren't related as such,
> but as I am updating the 1/3 the 2/3 would endup with conflict. So
> here I am putting all of them together with the conflict fixed at
> my end. And as such there is no change in 2/3 and 3/3 from its v1.
> 
> Anand Jain (3):
>   btrfs: kill btrfs_raid_type_names[]
>   btrfs: kill btrfs_raid_group[]
>   btrfs: kill btrfs_raid_mindev_error[]

Added to misc-next, thanks. I've reordered the mindev_error before the
raid_name for better struct packing.
