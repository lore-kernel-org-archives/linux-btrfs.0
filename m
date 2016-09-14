Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48811 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753804AbcINJ72 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 05:59:28 -0400
Date: Wed, 14 Sep 2016 11:59:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <Damien.LeMoal@hgst.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>
Subject: Re: [PATCH 3/3] block: Improve bio_set_op_attrs() robustness
Message-ID: <20160914095926.GC21938@lst.de>
References: <35e3cdd6-8983-6c84-cb4c-9a7be15aea55@sandisk.com> <2a6c6cbd-ccc6-ee89-99ca-c0267cf17ec0@sandisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2a6c6cbd-ccc6-ee89-99ca-c0267cf17ec0@sandisk.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 14, 2016 at 10:46:22AM +0200, Bart Van Assche wrote:
> Since REQ_OP_BITS == 3 and __REQ_NR_BITS == 30 it is not that hard
> to pass an op_flags argument to bio_set_op_attrs() that is larger
> than the number of bits reserved for the op_flags argument. Complain
> if this happens. Additionally, ensure that negative arguments trigger
> a complaint (1 << ... is signed while 1U << ... is unsigned; adding
> 0U to an integer expression causes it to be promoted to an unsigned
> type).

And this does the proper check.

Reviewed-by: Christoph Hellwig <hch@lst.de>
