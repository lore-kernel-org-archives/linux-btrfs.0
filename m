Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51211 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbbFJIp4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 04:45:56 -0400
Date: Wed, 10 Jun 2015 10:45:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] block: add a bi_error field to struct bio
Message-ID: <20150610084553.GA5021@lst.de>
References: <1433338959-24808-1-git-send-email-hch@lst.de> <1433338959-24808-2-git-send-email-hch@lst.de> <20150610125054.3da2abcc@home.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150610125054.3da2abcc@home.neil.brown.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 10, 2015 at 12:50:54PM +1000, Neil Brown wrote:
> This introduces a use-after-free.  put_buf(r1_bio) can  result in bio_put on
> 'bio'.
> It is safe to move the put_buf call after the md_done_sync(), but it is
> probably best to leave the 'update' variable as it.  i.e. Just change:
> 
> -	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
> +	int uptodate = !bio->bi_error;
> 
> 
> I can't see any other problems with the md changes.

Thanks, I'll keep the local uptodate variable for now.
