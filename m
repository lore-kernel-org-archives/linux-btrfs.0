Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55720 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbcAFTGD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 14:06:03 -0500
Message-ID: <1452107160.26125.39.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 25/35] target: set bi_op to REQ_OP
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
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
Date: Wed, 06 Jan 2016 11:06:00 -0800
In-Reply-To: <1452027218-32303-26-git-send-email-mchristi@redhat.com>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
	 <1452027218-32303-26-git-send-email-mchristi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mike,

On Tue, 2016-01-05 at 14:53 -0600, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> This patch has the target modules set the bio bi_op to a REQ_OP, and
> rq_flag_bits to bi_rw.
> 
> This patch is compile tested only.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/target_core_iblock.c | 38 ++++++++++++++++++++++---------------
>  drivers/target/target_core_pscsi.c  |  2 +-
>  2 files changed, 24 insertions(+), 16 deletions(-)
> 

Nice work to clean this long standing abuse.  ;)

For the target/iblock bit:

Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>

