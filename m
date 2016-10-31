Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55500 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944191AbcJaPgr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 11:36:47 -0400
Date: Mon, 31 Oct 2016 08:36:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 26/60] btrfs: set NO_MP for request queues behind BTRFS
Message-ID: <20161031153644.GK30919@infradead.org>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
 <1477728600-12938-27-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1477728600-12938-27-git-send-email-tom.leiming@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 29, 2016 at 04:08:25PM +0800, Ming Lei wrote:
> There are lots of direct access to .bi_vcnt & .bi_io_vec
> of bio, and it isn't ready to support multipage bvecs
> for BTRFS, so set NO_MP for these request queues.

For one bio is an I/O submitter, it has absolutely no business changing
queue flags - if we need to stick to this limitation it simply needs
a version of bio_add_page that doesn't create multi-page bvecs.

Second I don't think making it multipage bvec aware is all that hard,
and we should aim for doing the proper thing.
