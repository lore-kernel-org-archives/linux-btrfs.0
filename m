Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:59999 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924AbcAGDLk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jan 2016 22:11:40 -0500
Date: Thu, 7 Jan 2016 14:11:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: mchristi@redhat.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        konrad.wilk@oracle.com, drbd-dev@lists.linbit.com,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 13/35] xfs: set bi_op to REQ_OP
Message-ID: <20160107031131.GB32200@dastard>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
 <1452027218-32303-14-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1452027218-32303-14-git-send-email-mchristi@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 05, 2016 at 02:53:16PM -0600, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> This patch has xfs set the bio bi_op to a REQ_OP, and
> rq_flag_bits to bi_rw.
> 
> Note:
> I have run xfs tests on these btrfs patches. There were some failures
> with and without the patches. I have not had time to track down why
> xfstest fails without the patches.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  fs/xfs/xfs_aops.c |  3 ++-
>  fs/xfs/xfs_buf.c  | 27 +++++++++++++++------------
>  2 files changed, 17 insertions(+), 13 deletions(-)

Not sure which patches your note is refering to here.

The XFS change here looks fine.

Acked-by: Dave Chinner <dchinner@redhat.com>

-Dave.
-- 
Dave Chinner
david@fromorbit.com
