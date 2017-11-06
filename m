Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40269 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753096AbdKFQyI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 11:54:08 -0500
Date: Mon, 6 Nov 2017 17:52:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/7] btrfs: use i_size_read() instead of open code
Message-ID: <20171106165215.GQ28789@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171106083618.7617-1-anand.jain@oracle.com>
 <20171106083618.7617-4-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171106083618.7617-4-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 06, 2017 at 04:36:14PM +0800, Anand Jain wrote:
> As i_size_read() takes care of 32bit smp or preempt cases as well.

Can bdev->bd_inode->i_size change so that we need to use the
i_size_read()? My answer is 'no'. You haven't provided any reasoning
why it should be otherwise.
