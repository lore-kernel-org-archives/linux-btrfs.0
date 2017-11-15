Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39320 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754028AbdKOQrj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 11:47:39 -0500
Date: Wed, 15 Nov 2017 17:45:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/7] btrfs: use i_size_read() instead of open code
Message-ID: <20171115164544.GU28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171106083618.7617-1-anand.jain@oracle.com>
 <20171106083618.7617-4-anand.jain@oracle.com>
 <20171106165215.GQ28789@twin.jikos.cz>
 <d16fbeb8-bfb7-58da-4ae0-6dde21a74762@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d16fbeb8-bfb7-58da-4ae0-6dde21a74762@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 07, 2017 at 07:44:59AM +0800, Anand Jain wrote:
> 
> 
> On 11/07/2017 12:52 AM, David Sterba wrote:
> > On Mon, Nov 06, 2017 at 04:36:14PM +0800, Anand Jain wrote:
> >> As i_size_read() takes care of 32bit smp or preempt cases as well.
> > 
> > Can bdev->bd_inode->i_size change so that we need to use the
> > i_size_read()? My answer is 'no'.
> 
>   Hm. Right I was looking at it only from the theoretical point of view.
> 
>   And I presume you mean to say disk resize at the block layer is not
>   really a practically achievable concern.

There are some safety checks, at least if there are bios in flight on
the partition when it's mounted.
