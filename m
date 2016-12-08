Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24971 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753119AbcLHPTK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 10:19:10 -0500
Date: Thu, 8 Dec 2016 07:19:00 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/6] Btrfs: set single device limit for dax usecase
Message-ID: <20161208151900.GA20111@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
 <1481147110-20048-3-git-send-email-bo.li.liu@oracle.com>
 <20161208133559.GE12522@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161208133559.GE12522@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 08, 2016 at 02:35:59PM +0100, David Sterba wrote:
> On Wed, Dec 07, 2016 at 01:45:06PM -0800, Liu Bo wrote:
> > Dax on btrfs is not ready for multiple device.
> 
> How about DUP? Technically it's not multi-device but still stores
> multiple copies, so I don't know if the implementation is ok with that.

Good question.

For this patch set, meta DUP is OK while data DUP is not, the main
obstacle is that the actual copy-to-device operation happens in iomap
code (iomap_dax_actor), not inside filesystem itself, and it only takes
one <device, blocknum> pair to copy to device.

Thanks,

-liubo
