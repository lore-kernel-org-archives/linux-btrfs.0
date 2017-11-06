Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40355 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753096AbdKFQzR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 11:55:17 -0500
Date: Mon, 6 Nov 2017 17:53:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/7] btrfs: rename btrfs_add_device to btrfs_add_dev_item
Message-ID: <20171106165325.GR28789@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171106083618.7617-1-anand.jain@oracle.com>
 <20171106083618.7617-5-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171106083618.7617-5-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 06, 2017 at 04:36:15PM +0800, Anand Jain wrote:
> Function btrfs_add_device() is about adding the device item
> so rename to reflect that in the function. Similarly we have
> btrfs_rm_dev_item().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
