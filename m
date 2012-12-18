Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:44572 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab2LRBbP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 20:31:15 -0500
Date: Mon, 17 Dec 2012 20:31:11 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Alexander Block <ablock84@gmail.com>
CC: Martin =?utf-8?B?S8WZw63FvmVr?= <martin.krizek@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "lczerner@redhat.com" <lczerner@redhat.com>
Subject: Re: Online Deduplication for Btrfs (Master's thesis)
Message-ID: <20121218013111.GB22912@shiny>
References: <CAMiUzp95BXF8fcNb9EQQsrz1NpDtX9qr=FdC9C=+r3KYkYxgzw@mail.gmail.com>
 <CAB9VWqCjoFGdZVx0Uup2zmvuqS2PHiQO=h2EKawH-dZiGqvfDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAB9VWqCjoFGdZVx0Uup2zmvuqS2PHiQO=h2EKawH-dZiGqvfDQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 17, 2012 at 06:33:24AM -0700, Alexander Block wrote:
> I did some research on deduplication in the past and there are some
> problems that you will face. I'll try to list some of them (for sure
> not all).

Thanks Alexander for writing all of this up.  There are a lot of great
points here, but I'll summarize with:

[ many challenges to online dedup ]

[ offline dedup is the best way ]

So, the big problem with offline dedup is you're suddenly read bound.  I
don't disagree that offline makes a lot of the dedup problems easier,
and Alexander describes a very interesting system here.

I've tried to avoid features that rely on scanning though, just because
idle disk time may not really exist.  But with scrub, we have the scan
as a feature, and it may make a lot of sense to leverage that.

online dedup has a different set of tradeoffs, but as Alexander says the
hard part really is the data structure to index the hashes.  I think
there are a few different options here, including changing the file
extent pointers to point to a sha instead of a logical disk offset.

So, part of my answer really depends on where you want to go with your
thesis.  I expect the data structure work for efficient hash lookup is
going to be closer to what your course work requires?

-chris
