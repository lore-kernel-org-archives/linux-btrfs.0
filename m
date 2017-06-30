Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55790 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751744AbdF3Hhx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 03:37:53 -0400
Date: Fri, 30 Jun 2017 09:36:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Nick Terrell <terrelln@fb.com>
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>,
        squashfs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Add xxhash and zstd modules
Message-ID: <20170630073641.GN2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170629194108.1674498-1-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170629194108.1674498-1-terrelln@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 29, 2017 at 12:41:04PM -0700, Nick Terrell wrote:
>  lib/zstd/Makefile          |   18 +
>  lib/zstd/bitstream.h       |  374 +++++
>  lib/zstd/compress.c        | 3479 ++++++++++++++++++++++++++++++++++++++++++++
>  lib/zstd/decompress.c      | 2526 ++++++++++++++++++++++++++++++++
>  lib/zstd/entropy_common.c  |  243 ++++
>  lib/zstd/error_private.h   |   53 +
>  lib/zstd/fse.h             |  575 ++++++++
>  lib/zstd/fse_compress.c    |  795 ++++++++++
>  lib/zstd/fse_decompress.c  |  332 +++++
>  lib/zstd/huf.h             |  212 +++
>  lib/zstd/huf_compress.c    |  771 ++++++++++
>  lib/zstd/huf_decompress.c  |  960 ++++++++++++
>  lib/zstd/mem.h             |  151 ++
>  lib/zstd/zstd_common.c     |   75 +
>  lib/zstd/zstd_internal.h   |  269 ++++
>  lib/zstd/zstd_opt.h        | 1014 +++++++++++++

I don't see patch 2/4 in the mailinglist, probably over the 100kb limit.

The lib/* stuff needs to be merged first, I shouldn't add non-btrfs code
to our regular for-next branch. A testing branch with all the zstd code
can be created, but from the upstream merging process, I don't think we
can avoid two step merging.
