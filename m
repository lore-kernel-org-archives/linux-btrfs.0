Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42500 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751259AbeDERPc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Apr 2018 13:15:32 -0400
Date: Thu, 5 Apr 2018 19:13:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: bail out on error during replay_dir_deletes
Message-ID: <20180405171303.GM2635@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1522691988-127156-2-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522691988-127156-2-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 03, 2018 at 01:59:48AM +0800, Liu Bo wrote:
> If errors were returned by btrfs_next_leaf(), replay_dir_deletes needs
> to bail out, otherwise @ret would be forced to be 0 after 'break;' and
> the caller won't be aware of it.
> 
> Fixes: e02119d5a7b4 ("Btrfs: Add a write ahead tree log to optimize synchronous operations")
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Added to next, thanks.
