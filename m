Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52187 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751650AbdKTRQE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 12:16:04 -0500
Date: Mon, 20 Nov 2017 18:14:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: set plug for fsync
Message-ID: <20171120171408.GB3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171110001616.7875-1-bo.li.liu@oracle.com>
 <20171115231028.474-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171115231028.474-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 15, 2017 at 04:10:28PM -0700, Liu Bo wrote:
> Setting plug can merge adjacent IOs before dispatching IOs to the disk
> driver.
> 
> Without plug, it'd not be a problem for single disk usecases, but for
> multiple disks using raid profile, a large IO can be split to several
> IOs of stripe length, and plug can be helpful to bring them together
> for each disk so that we can save several disk access.
> 
> Moreover, fsync issues synchronous writes, so plug can really take
> effect.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
