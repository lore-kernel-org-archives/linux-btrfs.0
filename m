Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:57003 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaFBWED (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jun 2014 18:04:03 -0400
Received: by mail-ob0-f169.google.com with SMTP id vb8so5301680obc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jun 2014 15:04:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
References: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
Date: Mon, 2 Jun 2014 17:04:02 -0500
Message-ID: <CAKcLGm9nHmmN1oAe2AQO6aNB8R6nmqvwjUv+9ytiUFD5LWG3nw@mail.gmail.com>
Subject: Re: [PATCH 0/8] Add support for LZ4 compression
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Philip Worrall <philip.worrall@googlemail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 31, 2014 at 6:48 PM, Philip Worrall
<philip.worrall@googlemail.com> wrote:
> LZ4 is a lossless data compression algorithm that is focused on
> compression and decompression speed. LZ4 gives a slightly worse
> compression ratio compared with LZO (and much worse than Zlib)
> but compression speeds are *generally* similar to LZO.
> Decompression tends to be much faster under LZ4 compared
> with LZO hence it makes more sense to use LZ4 compression
> when your workload involves a higher proportion of reads.
>
> The following patch set adds LZ4 compression support to BTRFS
> using the existing kernel implementation. It is based on the
> changeset for LZO support in 2011. Once a filesystem has been
> mounted with LZ4 compression enabled older versions of BTRFS
> will be unable to read it. This implementation is however
> backwards compatible with filesystems that currently use
> LZO or Zlib compression. Existing data will remain unchanged
> but any new files that you create will be compressed with LZ4.
>
> Usage:
> Apply the following 8 patches to the current git tree
> (as of 20140531) and compile/load the btrfs module.
>
> # mount -t btrfs -o compress=lz4 device mountpoint
>
> or
>
> # mount -t btrfs -o compress-force=lz4 device mountpoint
>

I gave this patch-set a preliminary test, and there were no obvious
signs of corruption.

I was unable to run btrfsck or xfstests since btrfs-progs is not yet
aware of lz4, so my testing should be considered superficial.

One comment:  IMHO, it would make sense to implement lz4 and lz4hc at
the same time.  Since both are now in the kernel, I assume we would go
that direction eventually anyways, unless there are some wrinkles
around lz4hc I don't fully appreciate.  So we might as well conserve
the kernel INCOMPAT flag.
