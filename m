Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33390 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753985AbeEWGhQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 02:37:16 -0400
Date: Tue, 22 May 2018 23:37:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chris Mason <clm@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>, robbieko <robbieko@synology.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: implement unlocked buffered write
Message-ID: <20180523063713.GA18285@infradead.org>
References: <1526442757-7167-1-git-send-email-robbieko@synology.com>
 <20180522180828.GA8340@infradead.org>
 <D87124BA-3EEC-480F-8520-EBD3B5A33C04@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <D87124BA-3EEC-480F-8520-EBD3B5A33C04@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 02:31:36PM -0400, Chris Mason wrote:
> > And what protects two writes from interleaving their results now?
> 
> page locks...ish, we at least won't have results interleaved in a single
> page.  For btrfs it'll actually be multiple pages since we try to do more
> than one at a time.

I think you are going to break just about every assumption people
have that any single write is going to be atomic vs another write.

E.g. this comes from the posix read definition reference by the
write definition:

"I/O is intended to be atomic to ordinary files and pipes and FIFOs.
Atomic means that all the bytes from a single operation that started out
together end up together, without interleaving from other I/O
operations. It is a known attribute of terminals that this is not
honored, and terminals are explicitly (and implicitly permanently)
excepted, making the behavior unspecified. The behavior for other device
types is also left unspecified, but the wording is intended to imply
that future standards might choose to specify atomicity (or not).
"

Without taking the inode lock (or some sort of range lock) you can
easily interleave data from two write requests.

> But we're not avoiding the inode lock completely, we're just dropping it for
> the expensive parts of writing to the file.  A quick guess about what the
> expensive parts are:

The way I read the patch it basically 'avoids' the inode lock for almost
the whole write call, just minus some setup.
