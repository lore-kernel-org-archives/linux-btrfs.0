Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48454 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753484AbdIFMvg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 08:51:36 -0400
Date: Wed, 6 Sep 2017 14:50:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use wait_event instead of a single function
Message-ID: <20170906125007.GJ31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170901221430.10131-4-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170901221430.10131-4-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 01, 2017 at 04:14:29PM -0600, Liu Bo wrote:
> Since TASK_UNINTERRUPTIBLE has been used here, wait_event() can do the
> same job.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
