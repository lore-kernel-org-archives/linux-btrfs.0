Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:64300 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754599Ab2G3VmT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 17:42:19 -0400
Date: Tue, 31 Jul 2012 07:42:13 +1000
From: Dave Chinner <david@fromorbit.com>
To: majianpeng <majianpeng@gmail.com>
Cc: axboe <axboe@kernel.dk>, "konrad.wilk" <konrad.wilk@oracle.com>,
        "chris.mason" <chris.mason@fusionio.com>,
        viro <viro@ZenIV.linux.org.uk>, tytso <tytso@mit.edu>,
        "adilger.kernel" <adilger.kernel@dilger.ca>,
        shaggy <shaggy@kernel.org>, mfasheh <mfasheh@suse.com>,
        jlbec <jlbec@evilplan.org>, bpm <bpm@sgi.com>,
        elder <elder@kernel.org>,
        jfs-discussion <jfs-discussion@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [PATCH 0/8] Set bi_rw when alloc bio before call bio_add_page.
Message-ID: <20120730214213.GF2877@dastard>
References: <201207301514247032532@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201207301514247032532@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 30, 2012 at 03:14:28PM +0800, majianpeng wrote:
> When exec bio_alloc, the bi_rw is zero.But after calling bio_add_page,
> it will use bi_rw.
> Fox example, in functiion __bio_add_page,it will call merge_bvec_fn().
> The merge_bvec_fn of raid456 will use the bi_rw to judge the merge.
> >> if ((bvm->bi_rw & 1) == WRITE)
> >> return biovec->bv_len; /* always allow writes to be mergeable */

So if bio_add_page() requires bi_rw to be set, then shouldn't it be
set up for every caller? I noticed there are about 50 call sites for
bio_add_page(), and you've only touched about 10 of them. Indeed, I
notice that the RAID0/1 code uses bio_add_page, and as that can be
stacked on top of RAID456, it also needs to set bi_rw correctly.
As a result, your patch set is nowhere near complete, not does it
document that bio_add_page requires that bi_rw be set before calling
(which is the new API requirement, AFAICT).

So, my question is whether the RAID456 code is doing something
valid.  That write optimisation is clearly not enabled for a
significant amount of code and filesystems, so the first thing to do
is quantify the benefit of the optimisation. I can't evalute the
merit of this change without data telling me it is worthwhile, and
it's a lot of code to churn for no benefit....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
