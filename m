Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49339 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751607AbeBWWcm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 17:32:42 -0500
Date: Fri, 23 Feb 2018 23:30:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix endianness in super_copy
Message-ID: <20180223223023.GO1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180222135842.32459-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180222135842.32459-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 22, 2018 at 09:58:42PM +0800, Anand Jain wrote:
> Moving between opposite endianness will report bogus numbers in sysfs,
> and mount may fail as the root will not be restored correctly. If the
> filesystem is always used on a same endian host, this will not be a
> problem.
> Fix this by using the btrfs_set_super...() functions to set
> fs_info::super_copy values, and for the sysfs, use the cached
> fs_info::nodesize,sectorsize values.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Updated changelog and Fixes: tag.
