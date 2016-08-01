Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45693 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbcHALst (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 07:48:49 -0400
Date: Mon, 1 Aug 2016 04:47:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shaun Tancheff <shaun@tancheff.com>
Cc: linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Jens Axboe <axboe@fb.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        Mike Christie <mchristi@redhat.com>
Subject: Re: Fixup direct bi_rw modifiers
Message-ID: <20160801114713.GA16806@infradead.org>
References: <1469915148-20452-1-git-send-email-shaun@tancheff.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1469915148-20452-1-git-send-email-shaun@tancheff.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 30, 2016 at 04:45:48PM -0500, Shaun Tancheff wrote:
> bi_rw should be using bio_set_op_attrs to set bi_rw.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Jens,

what do you think about renaming bi_rw?  There aren't too many users
left, and any old code that would keep using it is alsmost guranteed
to be broken, so sending a post-rc1 patch to rename it might make
everyone else life easier.  Especially as it's also grossly misnamed
now.
