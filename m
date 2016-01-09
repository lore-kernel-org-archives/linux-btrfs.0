Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60629 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbcAIIE3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jan 2016 03:04:29 -0500
Date: Sat, 9 Jan 2016 00:04:26 -0800
From: Christoph Hellwig <hch@infradead.org>
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
Subject: Re: [PATCH 34/35] block: add QUEUE_FLAGs for flush and fua
Message-ID: <20160109080426.GA6207@infradead.org>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
 <1452027218-32303-35-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1452027218-32303-35-git-send-email-mchristi@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 05, 2016 at 02:53:37PM -0600, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> The last patch added a REQ_OP_FLUSH for request_fn drivers
> and the next patch renames REQ_FLUSH to REQ_PREFLUSH which
> will be used by file systems and make_request_fn drivers.
> 
> This leaves REQ_FLUSH/REQ_FUA defined for drivers to tell
> the block layer if flush/fua is supported. The names are
> confusing and I bet will will accidentally be used by
> people to request flushes. To avoid that, this patch adds
> QUEUE_FLAGs for flush and fua which drivers will use to
> indicate what they support.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>

Yes, this was rather confusing before.  Looks great fix the fix for th
kbuild complaint:

Reviewed-by: Christoph Hellwig <hch@lst.de>
