Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58545 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753089AbeBBRUN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 12:20:13 -0500
Date: Fri, 2 Feb 2018 18:17:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au
Subject: Re: [PATCH 2/2] btrfs: Remove custom crc32c init code
Message-ID: <20180202171758.GT18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1515404705-490-1-git-send-email-nborisov@suse.com>
 <1515404705-490-3-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515404705-490-3-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 08, 2018 at 11:45:05AM +0200, Nikolay Borisov wrote:
> The custom crc32 init code was introduced in
> 14a958e678cd ("Btrfs: fix btrfs boot when compiled as built-in") to
> enable using btrfs as a built-in. However, later as pointed out by
> 60efa5eb2e88 ("Btrfs: use late_initcall instead of module_init") this
> wasn't enough and finally btrfs was switched to late_initcall which
> comes after the generic crc32c implementation is initiliased. The
> latter commit superseeded the former. Now that we don't have to
> maintain our own code let's just remove it and switch to using the
> generic implementation.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> Despite touching a lot of files the patch is really simple. Here is the gist 
> of the changes: 
> 
> 1. Select LIBCRC32C rather than the low-level modules. 
> 2. s/btrfs_crc32c/crc32c/g
> 3. replace hash.h with linux/crc32c.h
> 4. Move the btrfs namehash funcs to ctree.h and change the tree accordingly. 
> 
> I've tested this with btrfs being both a module and a built-in and xfstest
> doesn't complain. 

This text could be also part of the changelog, it's useful to understand
how the change is done.

So this patches looks good to me and does seem to fix the longstanding
problem of not automatically selectiong the crc32c module when btrfs is
used. IIRC this has some workaround in dracut.

The modinfo confirms that now all the module dependencies are there:

before:
depends:        zstd_compress,zstd_decompress,raid6_pq,xor,zlib_deflate

after:
depends:        libcrc32c,zstd_compress,zstd_decompress,raid6_pq,xor,zlib_deflate
