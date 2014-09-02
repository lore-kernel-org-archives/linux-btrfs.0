Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60578 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbaIBLd2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 07:33:28 -0400
Date: Tue, 2 Sep 2014 07:31:04 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Nikolai Grigoriev <ngrigoriev@gmail.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: ext4 vs btrfs performance on SSD array
Message-ID: <20140902113104.GD5049@thunk.org>
References: <CAEp=YLgzsLbmEfGB5YKVcHP4CQ-_z1yxnZ0tpo7gjKZ2e1ma5g@mail.gmail.com>
 <20140902000822.GA20473@dastard>
 <20140902012222.GA21405@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140902012222.GA21405@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>  - the very small max readahead size

For things like the readahead size, that's probably something that we
should autotune, based the time it takes to read N sectors.  i.e.,
start N relatively small, such as 128k, and then bump it up based on
how long it takes to do a sequential read of N sectors until it hits a
given tunable, which is specified in milliseconds instead of kilobytes.

>  - replacing cfq with deadline (or noop)

Unfortunately, that will break ionice and a number of other things...

      	       	     		     		  - Ted

