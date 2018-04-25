Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753327AbeDYOti (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 10:49:38 -0400
Subject: Re: [PATCH 0/3] enhance btrfs_raid_array[]
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180425110144.12871-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2cfa9c3a-3140-5532-8898-328373a95419@suse.com>
Date: Wed, 25 Apr 2018 17:49:35 +0300
MIME-Version: 1.0
In-Reply-To: <20180425110144.12871-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 25.04.2018 14:01, Anand Jain wrote:
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
> 
>  fs/btrfs/disk-io.c     |  2 +-
>  fs/btrfs/extent-tree.c | 20 +------------------
>  fs/btrfs/volumes.c     | 54 +++++++++++++++++++++++++++-----------------------
>  fs/btrfs/volumes.h     |  7 +++++--
>  4 files changed, 36 insertions(+), 47 deletions(-)
> 

For the whole series:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
