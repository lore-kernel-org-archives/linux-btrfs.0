Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43311 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750975AbdFGGqe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 02:46:34 -0400
Subject: Re: [PATCH 1/8] btrfs: bioset allocations will never fail, adapt our
 helpers
To: Christoph Hellwig <hch@lst.de>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>
References: <cover.1496422340.git.dsterba@suse.com>
 <559a7bd7acc20ab9eb967dd205e41a4a3f2cdb97.1496422340.git.dsterba@suse.com>
 <0fb07221-b538-ccc3-c910-296d97ea64aa@oracle.com>
 <20170606104431.GA24297@lst.de>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <377590f2-ff26-3fc3-7c38-d91d44b503db@oracle.com>
Date: Wed, 7 Jun 2017 14:52:36 +0800
MIME-Version: 1.0
In-Reply-To: <20170606104431.GA24297@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> #define __GFP_RECLAIM ((__force gfp_t)(___GFP_DIRECT_RECLAIM|___GFP_KSWAPD_RECLAIM))
> 
> 
> #define GFP_NOFS        (__GFP_RECLAIM | __GFP_IO)

   Ah. Thanks.
