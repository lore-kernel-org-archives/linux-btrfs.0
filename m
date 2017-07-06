Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57501 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751914AbdGFBux (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Jul 2017 21:50:53 -0400
Date: Thu, 6 Jul 2017 03:50:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs for 4.13
Message-ID: <20170706015052.GA14129@lst.de>
References: <cover.1499176138.git.dsterba@suse.com> <CA+55aFwFWYtivrNgayV2nhpjv780eWMGRyJA=YwRia6-zvZb_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFwFWYtivrNgayV2nhpjv780eWMGRyJA=YwRia6-zvZb_A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 05, 2017 at 04:45:49PM -0700, Linus Torvalds wrote:
> Ouch, yeah, that was annoying. And yes, I ended up with several
> whitespace differences but other than that it looks the same. Oh well.
> 
> Jens, Christoph, let's not do that stupid thing with status-vs-error
> ever again, ok?

It should be done now :)

Back to serious - this work had to be done as we could not communicate
errors properly in the block layer with people inventing their own
codes all the time.  That being said, in retrospective I should have
tried a gradual approach that first defines the new code to the old
errors and left the fields in place.  I opted for the hard break to
make sure we can catch matching conversions by the compiler as very
few people run sparse for the __bitwise annotations, and some of
the drivers create so many sparse warnings that they would be lost
anyway.

But I've learned and will try to make something like this gradual
if it comes up, and hope we won't have to do something like it again
at all.
