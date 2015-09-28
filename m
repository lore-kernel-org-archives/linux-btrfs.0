Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33611 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbbI1XZs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 19:25:48 -0400
Received: by igbkq10 with SMTP id kq10so67861189igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 16:25:48 -0700 (PDT)
Message-ID: <1443482745.12614.5.camel@kepstin.ca>
Subject: Re: btrfs: obtain block checksums from user space
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org
Date: Mon, 28 Sep 2015 19:25:45 -0400
In-Reply-To: <20150928231612.GB25907@carfax.org.uk>
References: <mu1e38$io1$1@ger.gmane.org> <5604427D.1000708@gmail.com>
	 <CAJs94EbJV+VX16dnkFqH21OMV=uLYSCKnG9KNUCrs7B=rULYLg@mail.gmail.com>
	 <1443481911.12614.4.camel@kepstin.ca>
	 <20150928231612.GB25907@carfax.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2015-09-28 at 23:16 +0000, Hugo Mills wrote:
> On Mon, Sep 28, 2015 at 07:11:51PM -0400, Calvin Walton wrote:

> > 
> > The problem with trying to use btrfs checksums to compare two
> > different
> > files is that the blocks might not match up, if only due to
> > fragmentation. E.g., the same 1gb file might be stored like this on
> > one
> > machine:
> > 
> > [ 256MB ][    512 MB    ][ 256MB ]
> > 
> > And like this on the other:
> > [     512MB     ][     512MB     ]
> > 
> > Since the checksums are per block, and the blocks can be different
> > arrangements on different machines, they're not really all that
> > useful
> > for doing comparisons like you want.
> 
>    No, those are extents, not blocks, and the FS doesn't checksum in
> extents. :) Blocks are 4 KiB in size.

Oh, wow, btrfs is storing a lot more checksums than I thought it was...

Thanks for clearing up my misconception.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

