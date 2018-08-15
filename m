Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44576 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728811AbeHOPpx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 11:45:53 -0400
Date: Wed, 15 Aug 2018 14:53:40 +0200
From: David Sterba <dsterba@suse.cz>
To: zhong jiang <zhongjiang@huawei.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/3] change some function to be void function
Message-ID: <20180815125340.GN24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1533736075-8691-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1533736075-8691-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 08, 2018 at 09:47:52PM +0800, zhong jiang wrote:
> v3->v2:
>  - Repost the patches with detailed changelog.
> v1->v2:
>  - Fix v1 issue that forget to return after remove the variable "ret".
> 
> zhong jiang (3):
>   fs/btrfs/disk-io: change btrfs_destroy_delayed_refs to be void
>     function
>   fs/btrfs/extent-tree: change btrfs_free_reserved_bytes to be void
>     funtion
>   fs/btrfs/tree-log: change btrfs_pin_log_trans to be void function

The patches 2 and 3 can be applied, but please update che subject and
put just "btrfs: " there, not the full file path. That we can find in
the diff. The changelogs can be still improved to be clear about callers
vs callees. Please update and resend.
