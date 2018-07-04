Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43336 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933113AbeGDMRb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 08:17:31 -0400
Date: Wed, 4 Jul 2018 14:17:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Don't BUG_ON() if we failed to load one
 device or one chunk
Message-ID: <20180704121727.GP3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180703134040.8108-1-wqu@suse.com>
 <20180704115823.GN3126@twin.jikos.cz>
 <4a6e9f34-d57f-61a8-6ab8-4bd07952d237@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4a6e9f34-d57f-61a8-6ab8-4bd07952d237@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2018 at 08:01:11PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年07月04日 19:58, David Sterba wrote:
> > On Tue, Jul 03, 2018 at 09:40:40PM +0800, Qu Wenruo wrote:
> >> Don't panic for btrfs_read_chunk_tree() if one device or chunk is
> >> corrupted.
> >> Caller can already handle it pretty well.
> >>
> >> Link: https://bugzilla.kernel.org/show_bug.cgi?id=199839
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> > 
> > Applied, thanks.
> > 
> > In case there's a fuzzed image, please send it too. There are example
> > commits how to name, format and document it. Thanks.
> 
> Sorry for forgetting the image.
> 
> However, I'm puzzled by the fact that, even for some fuzzed image which
> is originally designed to detect kernel misbehavior, it's still added
> into btrfs-progs test cases.

The kernel tests of the fuzzed images are considered dangerous and the
mount test is intentionally missing from the progs for now.  As the
testsuite can be exported and used outside of the git repository, the
actual mount tests can be run in an environment where the crashes don't
matter. We'd need to add the script and some way to skip it by default.

The fuzzed images should also pass the userspace tools, for better
testing coverage eg. for the error handling so they're kept in one
place.
