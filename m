Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35315 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965371AbeAJPvx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 10:51:53 -0500
Received: by mail-qt0-f196.google.com with SMTP id u10so22547946qtg.2
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 07:51:53 -0800 (PST)
Date: Wed, 10 Jan 2018 10:51:51 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] btrfs: make btrfs_free_stale_device() to match the
 path
Message-ID: <20180110155150.7ig6ftno4ct2p2ac@destiny>
References: <20180110051523.3681-1-anand.jain@oracle.com>
 <20180110051523.3681-7-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180110051523.3681-7-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 10, 2018 at 01:15:23PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> The btrfs_free_stale_device() is updated to match for the given
> device path and delete it. (It searches for only unmounted list of
> devices.) Also drop the comment about different path being used
> for the same device, since now we will have cli to clean any
> device that's not a concern any more.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
