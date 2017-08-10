Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35185 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752629AbdHJRgx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Aug 2017 13:36:53 -0400
Date: Thu, 10 Aug 2017 10:36:51 -0700
From: Eric Biggers <ebiggers3@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        kernel-team@fb.com, squashfs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5 2/5] lib: Add zstd modules
Message-ID: <20170810173651.GB90916@gmail.com>
References: <20170810023553.3200875-1-terrelln@fb.com>
 <20170810023553.3200875-3-terrelln@fb.com>
 <20170810083017.GA10462@zzz.localdomain>
 <ba64934b-0170-1718-fc1e-0acb462abb20@gmail.com>
 <671b5ffb-0a8b-4e70-e3ac-9754cea54829@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <671b5ffb-0a8b-4e70-e3ac-9754cea54829@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 10, 2017 at 10:57:01AM -0400, Austin S. Hemmelgarn wrote:
> Also didn't think to mention this, but I could see the max level
> being very popular for use with SquashFS root filesystems used in
> LiveCD's. Currently, they have to decide between read performance
> and image size, while zstd would provide both.

The high compression levels of Zstandard are indeed a great fit for SquashFS,
but SquashFS images are created in userspace by squashfs-tools.  The kernel only
needs to be able to decompress them.

(Also, while Zstandard provides very good tradeoffs and will probably become the
preferred algorithm for SquashFS, it's misleading to imply that users won't have
to make decisions anymore.  It does not compress as well as XZ or decompress as
fast as LZ4, except maybe in very carefully crafted benchmarks.)

Eric
