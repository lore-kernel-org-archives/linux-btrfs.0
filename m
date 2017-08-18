Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49318 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750987AbdHRQKC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 12:10:02 -0400
Date: Fri, 18 Aug 2017 18:08:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Nick Terrell <terrelln@fb.com>
Cc: Adam Borowski <kilobyte@angband.pl>, "dsterba@suse.com" <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH preview] btrfs: allow to set compression level for zlib
Message-ID: <20170818160838.GB2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170724172939.24527-1-dsterba@suse.com>
 <689C76C1-60F4-4F1D-8AFF-C6250B788A49@fb.com>
 <20170805012745.g44pyqgb42z6jvro@angband.pl>
 <336A13CC-78FC-4CAC-9258-0336D7683AE3@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <336A13CC-78FC-4CAC-9258-0336D7683AE3@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 05, 2017 at 02:15:42AM +0000, Nick Terrell wrote:
> Looking at the memory usage of BtrFS zstd, the 128 KB window size keeps the
> memory usage very reasonable up to level 19. The zstd compression levels
> are computed using a tool that selects the parameters that give the best
> compression ratio for a given compression speed target. Since BtrFS has a
> fixed window size, the default compression levels might not be optimal. We
> could compute our own compression levels for a 128 KB window size.
> 
> | Level | Memory |
> |-------|--------|
> | 1     | 0.8 MB |
> | 2     | 1.0 MB |
> | 3     | 1.3 MB |
> | 4     | 0.9 MB |
> | 5     | 1.4 MB |
> | 6     | 1.5 MB |
> | 7     | 1.4 MB |
> | 8     | 1.8 MB |
> | 9     | 1.8 MB |
> | 10    | 1.8 MB |
> | 11    | 1.8 MB |
> | 12    | 1.8 MB |
> | 13    | 2.4 MB |
> | 14    | 2.6 MB |
> | 15    | 2.6 MB |
> | 16    | 3.1 MB |
> | 17    | 3.1 MB |
> | 18    | 3.1 MB |
> | 19    | 3.1 MB |
> 
> The workspace memory usage for each compression level.

That's quite a lot, in kernel. IIRC zlib and lzo use less than 200kb,
zstd wants 800kb for level 1. And this needs to be contiguous memory, so
if we're lucky and get the memory at the mount time, fine. In general
the memory can be fragmented (in the worst case, there are only 4k
chunks available), so we'd have to vmalloc and consume the virtual
mappings in great numbers.
