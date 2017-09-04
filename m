Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49274 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753871AbdIDSDg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 14:03:36 -0400
Date: Mon, 4 Sep 2017 20:02:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Nick Terrell <terrelln@fb.com>
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Add zstd support
Message-ID: <20170904180207.GF31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170830215322.782399-1-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170830215322.782399-1-terrelln@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 30, 2017 at 02:53:22PM -0700, Nick Terrell wrote:
> Adds zstd support to the btrfs program, and a dependency on libzstd >=
> 1.0.0.

I'm afraid we'll have to make the build optional for now, as the distros
may not provide it and I'd like to give at least some heads-up first. My
idea is:

- check if zstd library is found, use it
- otherwise warn that's it's going to be on by default in near future

'btrfs restore' would need to be enhanced to dump what's built in (in a
similar way convert now prints the supported filesystem), and possibly
warn that there are data compressed by zstd but there's no
decrompression support.

> The patch is also available in my fork of btrfs-progs [1], which passes
> Travis-CI. I tested each command that is effected in my test script [2].

The test requires zstd kernel support, which may be not available for
some time in the testing environments. But as restore is userspace-only,
we can create and use various images with zstd compressed data.

> I haven't updated Android.mk since I have no way to test it, and am not
> certain if it is used.

The anodroid build verification will work eventually through travis and
I'm aware it could be out of sync, you don't need to care about that
right now.
