Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbbIWM7S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 08:59:18 -0400
Date: Wed, 23 Sep 2015 14:58:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: change num_items type from u64 to unsigned
 int
Message-ID: <20150923125822.GY12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150922205915.GA27775@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150922205915.GA27775@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 08:59:15PM +0000, Alexandru Moise wrote:
> The value of num_items that start_transaction() ultimately
> always takes is a small one, so a 64 bit integer is overkill.
> 
> Also change num_items for btrfs_start_transaction() and
> btrfs_start_transaction_lflush() as well.
> 
> Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
