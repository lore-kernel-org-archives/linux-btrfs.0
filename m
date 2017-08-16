Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59686 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751569AbdHPOyi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 10:54:38 -0400
Date: Wed, 16 Aug 2017 16:53:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/7] add sanity check for extent inline ref type
Message-ID: <20170816145315.GI2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170807215531.12423-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170807215531.12423-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 07, 2017 at 03:55:24PM -0600, Liu Bo wrote:
> An invalid extent inline ref type could be read from a btrfs image and
> it ends up with a panic[1], this set is to deal with the insane value
> gracefully in patch 1-2 and clean up BUG() in the code in patch 3-6.
> 
> Patch 7 adds one more check to see if the ref is a valid shared one.
> 
> I'm not sure in the real world what may result in this corruption, but
> I've seen several reports on the ML about __btrfs_free_extent saying
> something was missing (or simply wrong), while testing this set with
> btrfs-corrupt-block, I found that switching ref type could end up that
> situation as well, eg. a data extent's ref type
> (BTRFS_EXTENT_DATA_REF_KEY) is switched to (BTRFS_TREE_BLOCK_REF_KEY).
> Hopefully this can give people more sights next time when that
> happens.
> 
> [1]:https://www.spinics.net/lists/linux-btrfs/msg65646.html

The series looks good to me overall, there are some minor comments. The
use of WARN(1, ...) will lack the common message prefix identifying the
filesystem, so I suggest to use the btrfs_err helper and consider if the
WARN_ON(1) is really useful in the place. Most of them look like that.

in patch btrfs_inline_ref_types, rename it to btrfs_inline_ref_type, so
it's in line with other similar definitions.
