Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54142 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbcB2RNo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Feb 2016 12:13:44 -0500
Date: Mon, 29 Feb 2016 09:13:39 -0800
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
Subject: Re: [PATCH 00/35 v4] separate operations from flags in the
 bio/request structs
Message-ID: <20160229171339.GA17755@infradead.org>
References: <1456343292-14535-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456343292-14535-1-git-send-email-mchristi@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any reason you've dropped my ACK for the previous version?

Jens, is this something you're fine with?  Would be great to figure
out a way to get this into 4.6.  There's probably going to be
plenty of conflicts, so having some sort of stable base tree
would be nice..

(Talking about conflicts, seems like the block for-linus and for-next
trees already conflict quite a bit..)
