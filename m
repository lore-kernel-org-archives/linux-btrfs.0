Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58937 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751374AbdJ3Ol3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 10:41:29 -0400
Date: Mon, 30 Oct 2017 15:39:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: match btrfs_device->mode same as it used
 for open
Message-ID: <20171030143938.GW3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171020103325.9595-1-anand.jain@oracle.com>
 <20171020140715.3110-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171020140715.3110-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 20, 2017 at 10:07:15PM +0800, Anand Jain wrote:
> We aren't setting the FMODE_WRITE when initializing btrfs_device
> structure and when calling blkdev_put, however we are setting it
> only when calling blkdev_get_by_path().

But this still does not say why this is a problem worth fixing. Nikolay
asked for it, and I would do the same, but why do we even have to ask
for that?

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes
