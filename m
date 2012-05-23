Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40031 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2EWETm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 00:19:42 -0400
Received: by qcro28 with SMTP id o28so4491621qcr.19
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2012 21:19:41 -0700 (PDT)
Message-ID: <1337746777.2479.9.camel@ayu>
Subject: Re: SSD erase state and reducing SSD wear
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Date: Wed, 23 May 2012 00:19:37 -0400
In-Reply-To: <jph1hu$2tq$1@dough.gmane.org>
References: <jph1hu$2tq$1@dough.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2012-05-22 at 22:47 +0100, Martin wrote:
> I've got two recent examples of SSDs. Their pristine state from the
> manufacturer shows:

> Device Model:     OCZ-VERTEX3
> 00000000  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

> Device Model:     OCZ VERTEX PLUS
> 00000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

> What's a good way to test what state they get erased to from a TRIM
> operation?

This pristine state probably matches up with the result of a trim
command on the drive. In particular, a freshly erased flash block is in
a state where the bits are all 1, so the Vertex Plus drive is showing
you the flash contents directly. The Vertex 3 has substantially more
processing, and the 0s are effectively generated on the fly for unmapped
flash blocks (similar to how the missing portions of a sparse file
contains 0s).

> Can btrfs detect the erase state and pad unused space in filesystem
> writes with the same value so as to reduce SSD wear?

On the Vertex 3, this wouldn't actually do what you'd hope. The firmware
in that drive actually compresses, deduplicates, and encrypts all the
data prior to writing it to flash - and as a result the data that hits
the flash looks nothing like what the filesystem wrote.
(For best performance, it might make sense to disable btrfs's built-in
compression on the Vertex 3 drive to allow the drive's compression to
kick in. Let us know if you benchmark it either way.)

The benefit to doing this on the Vertex Plus is probably fairly small,
since to rewrite a block - even if the block is partially unwritten - is
still likely to require a read-modify-write cycle with an erase step.
The granularity of the erase blocks is just too big for the savings to
be very meaningful.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

