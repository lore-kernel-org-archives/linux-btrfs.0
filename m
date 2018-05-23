Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41562 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932271AbeEWKT7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 06:19:59 -0400
Date: Wed, 23 May 2018 12:17:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>,
        Timofey Titovets <nefelim4ag@gmail.com>
Subject: Re: [PATCH 0/2] Btrfs: fix partly checksummed file races
Message-ID: <20180523101714.GZ6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1527026445.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1527026445.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 03:02:11PM -0700, Omar Sandoval wrote:
> Based on kdave/for-next. Note that there's a Fixes: tag in there
> referencing a commit in the for-next branch, so that would have to be
> updated if the commit gets rebased. These patches are also available at
> https://github.com/osandov/linux/tree/btrfs-nodatasum-race.

If the original patch is not in any released or frozen branch, then the
fix should be folded to the original patch. The for-next branch is for
preview, testing and catching bugs that slip past the review. And gets
reassembled frequently so referencing a patch from there does not make
sense.

Sending the fixups as patches is ok, replies to the original thread
might get lost in the noise.
