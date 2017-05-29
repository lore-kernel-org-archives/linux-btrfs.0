Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56633 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751141AbdE2OYi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 10:24:38 -0400
Date: Mon, 29 May 2017 16:23:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 2/2] Btrfs: compression must free at least one sector
 size
Message-ID: <20170529142336.GG14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170525181220.24692-1-nefelim4ag@gmail.com>
 <20170525181220.24692-3-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170525181220.24692-3-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 25, 2017 at 09:12:20PM +0300, Timofey Titovets wrote:
> Btrfs already skip store of data where compression didn't
> free at least one byte. Let's make logic better and make check
> that compression free at least one sector size
> because in another case it useless to store this data compressed

Yeah, there's a room for improvement.

Saving at least one sectorsize sounds ok to me. I'm not sure if this
should be implemented inside the compressors (lzo, zlib). There'res the
quick shortcut (the check "if (tot_in > 8192 && tot_in < tot_out)"), but
otherwise the overall decision whether to use the compressed data is
done in compress_file_range.

  601         if (will_compress) {
  602                 /*
  603                  * we aren't doing an inline extent round the compressed size
  604                  * up to a block size boundary so the allocator does sane
  605                  * things
  606                  */
  607                 total_compressed = ALIGN(total_compressed, blocksize);
  608
  609                 /*
  610                  * one last check to make sure the compression is really a
  611                  * win, compare the page count read with the blocks on disk
  612                  */
  613                 total_in = ALIGN(total_in, PAGE_SIZE);
  614                 if (total_compressed >= total_in) {
  615                         will_compress = 0;
  616                 } else {
...

so the check would go to line 614.

There's one case that your patch misses and it's the compressed inline extent.
As we'd never submit more than one sectorsize of data to compression, the
savings would be bigger than one page and thus we'd skip the compression.

This could be fixed easily though, but I'd like to use it as an example why the
decision should be moved upwards in the callchain (ie. to compress_file_range).
