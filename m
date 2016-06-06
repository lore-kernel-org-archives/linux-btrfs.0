Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbcFFGQr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jun 2016 02:16:47 -0400
Subject: Re: [PATCH 07/45] bcache: use op_is_write instead of checking for
 REQ_WRITE
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
 <1465155145-10812-8-git-send-email-mchristi@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <5755154C.7030007@suse.de>
Date: Mon, 6 Jun 2016 08:16:44 +0200
MIME-Version: 1.0
In-Reply-To: <1465155145-10812-8-git-send-email-mchristi@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/05/2016 09:31 PM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> We currently set REQ_WRITE/WRITE for all non READ IOs
> like discard, flush, writesame, etc. In the next patches where we
> no longer set up the op as a bitmap, we will not be able to
> detect a operation direction like writesame by testing if REQ_WRITE is
> set.
> 
> This has bcache use the op_is_write helper which will do the right
> thing.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/md/bcache/io.c      | 2 +-
>  drivers/md/bcache/request.c | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
(Could probably folded together with the two previous patches)

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
