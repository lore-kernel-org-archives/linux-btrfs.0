Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37929 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751757AbeCNULG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 16:11:06 -0400
Date: Wed, 14 Mar 2018 21:08:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Document parameters of btrfs_reserve_extent
Message-ID: <20180314200842.GS32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1520936552-11586-1-git-send-email-nborisov@suse.com>
 <21852f3c-f330-ecc8-543d-62c0cc4b66bb@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <21852f3c-f330-ecc8-543d-62c0cc4b66bb@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 13, 2018 at 09:56:23PM +0800, Anand Jain wrote:
> 
> 
> On 03/13/2018 06:22 PM, Nikolay Borisov wrote:
> > This function is the entry to the extent allocator and as such has
> > quite a number of parameters. Some of those have subtle effects on the
> > allocation algorithm. Document the parameters.
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
>   Reviewed-by: Anand Jain <anand.jain@oracle.com>

Added to next, thanks.
