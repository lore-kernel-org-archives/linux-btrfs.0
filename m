Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37228 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728140AbeGMNEa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 09:04:30 -0400
Date: Fri, 13 Jul 2018 14:49:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/7] btrfs: restore uuid_mutex in btrfs_open_devices
Message-ID: <20180713124953.GT3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1529516226.git.dsterba@suse.com>
 <953899caf13686e1f128748ef3220281a1b9a47e.1529516228.git.dsterba@suse.com>
 <e439cf5c-df8f-dbbb-736d-c07a03d34e83@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e439cf5c-df8f-dbbb-736d-c07a03d34e83@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2018 at 04:09:50PM +0800, Anand Jain wrote:
> On 06/21/2018 01:51 AM, David Sterba wrote:
> > Commit 542c5908abfe84f7b4c1 ("btrfs: replace uuid_mutex by
> > device_list_mutex in btrfs_open_devices") switched to device_list_mutex
> > as we need that for the device list traversal, but we also need
> > uuid_mutex to protect access to fs_devices::opened to be consistent with
> > other users of that item.
> > 
> > CC: Anand Jain <anand.jain@oracle.com>
> > Signed-off-by: David Sterba <dsterba@suse.com>
> 
>   I am optimize the uuid_mutex for fsids concurrency on top these set of 
> patches, so.
> 
>   Reviewed-by: Anand Jain <anand.jain@oracle.com>

So this should go to 4.18, instead of reverting 542c5908abfe8.
