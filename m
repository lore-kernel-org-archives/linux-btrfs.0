Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57736 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727750AbeIFWOq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Sep 2018 18:14:46 -0400
Date: Thu, 6 Sep 2018 19:37:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: set leave_spinning in btrfs_get_extent
Message-ID: <20180906173757.GG24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1534981265-97557-1-git-send-email-bo.liu@linux.alibaba.com>
 <1535176029-77767-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1535176029-77767-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 25, 2018 at 01:47:09PM +0800, Liu Bo wrote:
> Unless it's going to read inline extents from btree leaf to page,
> btrfs_get_extent won't sleep during the period of holding path lock.
> 
> This sets leave_spinning at first and sets path to blocking mode right
> before reading inline extent if that's the case.  The benefit is that a
> path in spinning mode typically has less impact (faster) on waiters
> rather than that in blocking mode.
> 
> Also fixes the misalignment of the prototype, which is too trivial for
> a single patch.

^^^ removed as it refers to the hunks from v2.

> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: David Sterba <dsterba@suse.com>
