Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53072 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966552AbbFJQEp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 12:04:45 -0400
Date: Wed, 10 Jun 2015 18:04:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: Re: block: add a bi_error field to struct bio
Message-ID: <20150610160443.GA14268@lst.de>
References: <1433338959-24808-1-git-send-email-hch@lst.de> <1433338959-24808-2-git-send-email-hch@lst.de> <20150604153106.GA31567@redhat.com> <20150610081138.GA3841@lst.de> <20150610152649.GA31140@redhat.com> <20150610160112.GB31140@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150610160112.GB31140@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 10, 2015 at 12:01:12PM -0400, Mike Snitzer wrote:
> > I'll queue a patch to rename 'error' to 'error_bits' where appropriate.
> 
> See: https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=f368f463e4cef696ad6b102dbaf5c10dfca7cc63

Can we wait with this until we're done with bi_error?
