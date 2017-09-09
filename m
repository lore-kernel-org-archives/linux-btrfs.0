Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60460 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757173AbdIIAoR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 20:44:17 -0400
Subject: Re: [GIT PULL] zstd support (lib, btrfs, squashfs)
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nick Terrell <terrelln@fb.com>,
        Phillip Lougher <phillip@squashfs.org.uk>, Sean Purcell <me@seanp.xyz>
CC: David Sterba <dsterba@suse.cz>
References: <de155140-8773-1a78-2dab-1d722ede3dc1@fb.com>
Message-ID: <c721b754-aee4-d1ac-3fa7-64fd6c7725c1@fb.com>
Date: Fri, 8 Sep 2017 20:43:52 -0400
MIME-Version: 1.0
In-Reply-To: <de155140-8773-1a78-2dab-1d722ede3dc1@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/08/2017 03:33 PM, Chris Mason wrote:
> Hi Linus,
> 
> Nick Terrell's patch series to add zstd support to the kernel has been
> floating around for a while.  After talking with Dave Sterba, Herbert and
> Phillip, we decided to send the whole thing in as one pull request.
> 
> I have it in my zstd branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git zstd
> 
> There's a trivial conflict with the main btrfs pull that Dave Sterba just
> sent.  His pull deletes BTRFS_COMPRESS_LAST in fs/btrfs/compression.h, and
> I've put the sample resolution in a branch named zstd-4.14-merge.  My
> idea was that you'd take our main btrfs pull first and this one second,
> but the conflicts are small enough it's not a big deal.
> 
> zstd is a big win in speed over zlib and in compression ratio over lzo, and
> the compression team here at FB has gotten great results using it in production.
> Nick will continue to update the kernel side with new improvements from the
> open source zstd userland code.

Just to clarify, we've been testing the kernel side of this here at FB, 
but our zstd use in prod is limited to the application side.

-chris
