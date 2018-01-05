Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53408 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751469AbeAEOQx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 09:16:53 -0500
Date: Fri, 5 Jan 2018 15:14:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: misc cleanup btrfs_scan_one_device()
Message-ID: <20180105141444.GN3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171215074016.26461-1-anand.jain@oracle.com>
 <20171215074016.26461-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171215074016.26461-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 15, 2017 at 03:40:16PM +0800, Anand Jain wrote:
> Assign ret = -EINVAL where actually its required.
> Remove { } around single line if else code.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Added to next, thanks.
