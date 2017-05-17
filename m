Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34404 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751761AbdEQSdh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 14:33:37 -0400
Date: Wed, 17 May 2017 20:32:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] Btrfs: unify naming of btrfs_io_bio
Message-ID: <20170517183238.GM4065@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
 <1492478187-24875-7-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1492478187-24875-7-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 17, 2017 at 06:16:27PM -0700, Liu Bo wrote:
> All dio endio functions are using io_bio for struct btrfs_io_bio, this
> makes btrfs_submit_direct to follow this convention.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
