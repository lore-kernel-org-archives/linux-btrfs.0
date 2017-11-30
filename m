Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36435 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752442AbdK3Rej (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 12:34:39 -0500
Date: Thu, 30 Nov 2017 18:32:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: drop btrfs_device::can_discard to query directly
Message-ID: <20171130173241.GN3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171129105343.23176-1-anand.jain@oracle.com>
 <b37c23ae-6941-c2f2-ef1a-b00a1997392a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b37c23ae-6941-c2f2-ef1a-b00a1997392a@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 01:53:29PM +0200, Nikolay Borisov wrote:
> 
> 
> On 29.11.2017 12:53, Anand Jain wrote:
> > We can query the bdev directly when needed at btrfs_discard_extent()
> > so drop btrfs_device::can_discard.
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > Suggested-by: Nikolay Borisov <nborisov@suse.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Added to next, thanks.
