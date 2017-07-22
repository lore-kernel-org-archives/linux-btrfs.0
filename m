Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:52420 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754985AbdGVLf1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Jul 2017 07:35:27 -0400
Date: Sat, 22 Jul 2017 13:35:03 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Yann Collet <cyan@fb.com>, David Sterba <dsterba@suse.cz>,
        squashfs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] Add xxhash and zstd modules
Message-ID: <20170722113503.nf227bdrzx6637wl@angband.pl>
References: <20170720212743.3351201-1-terrelln@fb.com>
 <cb9deeb3-dc04-45a4-9583-1da9e8a3f779@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <cb9deeb3-dc04-45a4-9583-1da9e8a3f779@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 21, 2017 at 11:56:21AM -0400, Austin S. Hemmelgarn wrote:
> On 2017-07-20 17:27, Nick Terrell wrote:
> > This patch set adds xxhash, zstd compression, and zstd decompression
> > modules. It also adds zstd support to BtrFS and SquashFS.
> > 
> > Each patch has relevant summaries, benchmarks, and tests.
> 
> For patches 2-3, I've compile tested and had runtime testing running for
> about 18 hours now with no issues, so you can add:
> 
> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>

I assume you haven't tried it on arm64, right?

I had no time to get 'round to it before, and just got the following build
failure:

  CC      fs/btrfs/zstd.o
In file included from fs/btrfs/zstd.c:28:0:
fs/btrfs/compression.h:39:2: error: unknown type name ‘refcount_t’
  refcount_t pending_bios;
  ^~~~~~~~~~
scripts/Makefile.build:302: recipe for target 'fs/btrfs/zstd.o' failed

It's trivially fixably by:
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -24,6 +24,7 @@
 #include <linux/sched.h>
 #include <linux/pagemap.h>
 #include <linux/bio.h>
+#include <linux/refcount.h>
 #include <linux/zstd.h>
 #include "compression.h"

after which it works fine, although half an hour of testing isn't exactly
exhaustive.


Alas, the armhf machine I ran stress tests (Debian archive rebuilds) on
doesn't boot with 4.13-rc1 due to some unrelated regression, bisecting that
would be quite painful so I did not try yet.  I guess re-testing your patch
set on 4.12, even with btrfs-for-4.13 (which it had for a while), wouldn't
be of much help.  So far, previous versions have been running for weeks,
with no issue since you fixed workspace flickering.


On amd64 all is fine.


I haven't tested SquashFS at all.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
