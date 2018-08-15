Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36666 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727141AbeHOOnj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 10:43:39 -0400
Date: Wed, 15 Aug 2018 13:51:38 +0200
From: David Sterba <dsterba@suse.cz>
To: zhong jiang <zhongjiang@huawei.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs:free-space-cache: remove unneeded NULL check
 before kfree
Message-ID: <20180815115137.GJ24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1534140369-11578-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534140369-11578-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 13, 2018 at 02:06:08PM +0800, zhong jiang wrote:
> Kfree has taken the null pointer into account. So remove the check
> before kfree.
> 
> The issue is detected with the help of Coccinelle.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Added to misc-next, thanks.
