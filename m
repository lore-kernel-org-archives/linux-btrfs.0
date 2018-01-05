Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46956 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751759AbeAENKb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 08:10:31 -0500
Date: Fri, 5 Jan 2018 14:08:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: rename btrfs_device::scrub_device to scrub_ctx
Message-ID: <20180105130823.GJ3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180103080830.20971-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180103080830.20971-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 03, 2018 at 04:08:30PM +0800, Anand Jain wrote:
> btrfs_device::scrub_device is not a device which is being scrubbed,
> but it holds the scrub context, so rename to reflect the same. No
> functional changes here.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
