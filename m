Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60905 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753014AbdEQRy5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 13:54:57 -0400
Date: Wed, 17 May 2017 19:53:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/6] Btrfs: use bio_clone_fast to clone our bio
Message-ID: <20170517175358.GK4065@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
 <1492478187-24875-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1492478187-24875-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 17, 2017 at 06:16:22PM -0700, Liu Bo wrote:
> For raid1 and raid10, we clone the original bio to the bios which are then
> sent to different disks.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
