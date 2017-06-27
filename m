Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57791 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751547AbdF0ROg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 13:14:36 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6CA03AB1E
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 17:14:35 +0000 (UTC)
Date: Tue, 27 Jun 2017 19:13:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: remove unused sectorsize member
Message-ID: <20170627171325.GC2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1498488155-9941-1-git-send-email-nborisov@suse.com>
 <1498569952-672-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1498569952-672-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 27, 2017 at 04:25:52PM +0300, Nikolay Borisov wrote:
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

Signed-off-by: ...

otherwise ok,

Reviewed-by: David Sterba <dsterba@suse.com>
