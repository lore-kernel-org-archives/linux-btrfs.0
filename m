Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51418 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754874AbcK1UMS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 15:12:18 -0500
Date: Mon, 28 Nov 2016 12:12:11 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>, Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: btrfs: still lockdep splat for 4.9-rc5+ (btrfs_log_inode)
Message-ID: <20161128201211.GB5005@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <b9063be2-8c01-2c15-ca2d-8460594128cf@de.ibm.com>
 <20161126134638.GA79987@clm-mbp.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161126134638.GA79987@clm-mbp.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 26, 2016 at 08:46:38AM -0500, Chris Mason wrote:
> On Fri, Nov 25, 2016 at 10:03:25AM +0100, Christian Borntraeger wrote:
> > FWIW, I still see the lockdep splat in btrfs in 4.9-rc5+
> 
> Filipe reworked the code to avoid taking the same lock twice.  As far as I
> can tell, this just needs some annotation.

Besides this log_mutex, we have another false lockdep warning around
block_group_cache->data_rwsem, we can use down_read_nested() to get rid
of it.

Thanks,

-liubo
