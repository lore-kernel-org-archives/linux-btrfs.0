Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44465 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752290AbdJPOJc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 10:09:32 -0400
Date: Mon, 16 Oct 2017 16:07:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH] btrfs: fix call to btrfs_end_transaction without a
 transaction handler
Message-ID: <20171016140745.GN3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171012203900.dqdsfcpbfjyl7bea@mwanda>
 <20171013021654.14461-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171013021654.14461-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 13, 2017 at 10:16:54AM +0800, Anand Jain wrote:
> In btrfs_init_new_device() when btrfs_attach_transaction() fails we
> shouldn't call btrfs_end_transaction(). Fix it.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Fixes:
>   btrfs: error out if btrfs_attach_transaction() fails
> ---
> Hi David,
>   Can you pls squash this changes to the patch which it
>   fixes. OR if its better to send the original the with
>   the fix, pls let me know I will do it.

I have squashed the incremental change, thanks.
