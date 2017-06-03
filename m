Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57094 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750759AbdFCFKp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 3 Jun 2017 01:10:45 -0400
Date: Sat, 3 Jun 2017 07:10:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH 1/8] btrfs: bioset allocations will never fail, adapt
        our helpers
Message-ID: <20170603051043.GA7004@lst.de>
References: <cover.1496422340.git.dsterba@suse.com> <559a7bd7acc20ab9eb967dd205e41a4a3f2cdb97.1496422340.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <559a7bd7acc20ab9eb967dd205e41a4a3f2cdb97.1496422340.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 02, 2017 at 06:58:30PM +0200, David Sterba wrote:
> Christoph pointed out that bio allocations backed by a bioset will never
> fail.  As we always use a bioset for all bio allocations, we can skip
> the error handling.  This patch adjusts our low-level helpers, the
> cascaded changes to all callers will come next.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
