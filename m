Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34107 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756318AbcIUNqE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 09:46:04 -0400
Date: Wed, 21 Sep 2016 15:44:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: improve check_node to avoid reading corrupted
 nodes
Message-ID: <20160921134403.GE16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1473899004-29697-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1473899004-29697-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 14, 2016 at 05:23:24PM -0700, Liu Bo wrote:
> We need to check items in a node to make sure that we're reading
> a valid one, otherwise we could get various crashes while processing
> delayed_refs.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
