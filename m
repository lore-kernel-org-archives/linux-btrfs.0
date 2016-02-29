Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43700 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbcB2SCG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Feb 2016 13:02:06 -0500
Subject: Re: [PATCH 00/35 v4] separate operations from flags in the
 bio/request structs
To: Christoph Hellwig <hch@infradead.org>, mchristi@redhat.com
References: <1456343292-14535-1-git-send-email-mchristi@redhat.com>
 <20160229171339.GA17755@infradead.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        konrad.wilk@oracle.com, drbd-dev@lists.linbit.com,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
From: Mike Christie <michaelc@cs.wisc.edu>
Message-ID: <56D4802E.3090507@cs.wisc.edu>
Date: Mon, 29 Feb 2016 11:30:22 -0600
MIME-Version: 1.0
In-Reply-To: <20160229171339.GA17755@infradead.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/29/2016 11:13 AM, Christoph Hellwig wrote:
> Any reason you've dropped my ACK for the previous version?

Sorry. I think I accidentally dropped it when I rebased back over to
linux-next. It looks like it only got stuck on the first patch. I will
fix that up on the resend for those kbuild errors.
