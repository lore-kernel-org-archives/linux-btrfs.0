Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbcFFGpl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jun 2016 02:45:41 -0400
Subject: Re: [PATCH 25/45] bcache: use bio op accessors
To: mchristi@redhat.com, linux-f2fs-devel@lists.sourceforge.net,
        linux-ext4@vger.kernel.org, konrad.wilk@oracle.com,
        drbd-dev@lists.linbit.com, philipp.reisner@linbit.com,
        lars.ellenberg@linbit.com, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com,
        ocfs2-devel@oss.oracle.com
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
 <1465155145-10812-26-git-send-email-mchristi@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <57551BF2.6060000@suse.de>
Date: Mon, 6 Jun 2016 08:45:06 +0200
MIME-Version: 1.0
In-Reply-To: <1465155145-10812-26-git-send-email-mchristi@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/05/2016 09:32 PM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> Separate the op from the rq_flag_bits and have bcache
> set/get the bio using bio_set_op_attrs/bio_op.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/md/bcache/btree.c     |  4 ++--
>  drivers/md/bcache/debug.c     |  4 ++--
>  drivers/md/bcache/journal.c   |  7 ++++---
>  drivers/md/bcache/movinggc.c  |  2 +-
>  drivers/md/bcache/request.c   | 14 +++++++-------
>  drivers/md/bcache/super.c     | 24 +++++++++++++-----------
>  drivers/md/bcache/writeback.c |  4 ++--
>  7 files changed, 31 insertions(+), 28 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
