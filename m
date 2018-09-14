Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728050AbeINVmW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 17:42:22 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7D637AFB2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 16:27:08 +0000 (UTC)
Date: Fri, 14 Sep 2018 18:27:08 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: don't attempt to trim devices that don't
 support it
Message-ID: <20180914162707.GT5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180906211816.12121-1-jeffm@suse.com>
 <20180906211816.12121-3-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180906211816.12121-3-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 06, 2018 at 05:18:15PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> We check whether any device the file system is using supports discard
> in the ioctl call, but then we attempt to trim free extents on every
> device regardless of whether discard is supported.  Due to the way
> we mask off EOPNOTSUPP, we can end up issuing the trim operations
> on each free range on devices that don't support it, just wasting time.
> 
> Fixes: 499f377f49f08 (btrfs: iterate over unused chunk space in FITRIM)
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
