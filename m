Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49787 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943145AbcJaSAY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 14:00:24 -0400
Date: Mon, 31 Oct 2016 11:00:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chris Mason <clm@fb.com>, Christoph Hellwig <hch@infradead.org>,
        Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 26/60] btrfs: set NO_MP for request queues behind BTRFS
Message-ID: <20161031180023.GA18428@infradead.org>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
 <1477728600-12938-27-git-send-email-tom.leiming@gmail.com>
 <20161031153644.GK30919@infradead.org>
 <20161031175828.GB48277@clm-mbp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161031175828.GB48277@clm-mbp.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 31, 2016 at 11:58:29AM -0600, Chris Mason wrote:
> Yeah, I'd rather make us less special.  The direct access was a short term
> fix to adjust to the new bio interfaces, we should clean it up.

I've got patches for a few areas in progress, I'll send them your way
once I've finished testing.  There will be a few more areas left where
I'll need a little help, though.
