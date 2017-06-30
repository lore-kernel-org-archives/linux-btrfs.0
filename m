Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57939 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751494AbdF3IJE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 04:09:04 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 003D8AD30
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Jun 2017 08:09:01 +0000 (UTC)
Date: Fri, 30 Jun 2017 10:07:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: remove unused sectorsize member
Message-ID: <20170630080752.GQ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170627171325.GC2866@twin.jikos.cz>
 <1498637122-5200-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1498637122-5200-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 28, 2017 at 11:05:22AM +0300, Nikolay Borisov wrote:
> The sectorsize member of btrfs_block_group_cache is unused. So remove it, this
> reduces the number of holes in the struct.
> 
> With patch:
> /* size: 856, cachelines: 14, members: 40 */
> /* sum members: 837, holes: 4, sum holes: 19 */
> /* bit holes: 1, sum bit holes: 29 bits */
> /* last cacheline: 24 bytes */
> 
> Without patch:
> /* size: 864, cachelines: 14, members: 41 */
> /* sum members: 841, holes: 5, sum holes: 23 */
> /* bit holes: 1, sum bit holes: 29 bits */
> /* last cacheline: 32 bytes */
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.com>

Strange that the error appeared just now, the code hasn't been modified
recently.

  CC [M]  fs/btrfs/tests/free-space-tree-tests.o
fs/btrfs/tests/free-space-tree-tests.c: In function ‘__check_free_space_extents’:
fs/btrfs/tests/free-space-tree-tests.c:84:20: error: ‘struct btrfs_block_group_cache’ has no member named ‘sectorsize’
     offset += cache->sectorsize;
                    ^~
make[1]: *** [scripts/Makefile.build:302: fs/btrfs/tests/free-space-tree-tests.o] Error 1
make: *** [Makefile:1684: fs/btrfs/] Error 2

I'll fix it.
