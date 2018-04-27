Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43897 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758567AbeD0QKR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 12:10:17 -0400
Date: Fri, 27 Apr 2018 18:07:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Jayashree Mohan <jayashree2912@gmail.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        Filipe Manana <fdmanana@kernel.org>
Subject: Re: Inconsistent behavior of fsync in btrfs
Message-ID: <20180427160740.GD21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CA+EzBbC7rmYsKjy_+rkwJLK-bmU51q+a4rnezvOoZYyJ8kWGqg@mail.gmail.com>
 <34B2B717-B12D-44F4-B0D0-E3D606BBEFA6@fb.com>
 <CA+EzBbBaZjcdHi4O4W8LZ2JvpYhN_hFGvktaeFYRfSygW3sK7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+EzBbBaZjcdHi4O4W8LZ2JvpYhN_hFGvktaeFYRfSygW3sK7A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2018 at 07:59:23PM -0500, Jayashree Mohan wrote:
> Thanks for the response. We are using a tool we developed called
> CrashMonkey[1] to run crash consistency tests and generate the bug
> reports above. We'd be happy to guide you through setting up
> CrashMonkey and getting these bugs reproduced. However, if you want to
> be able to reproduce them with your current setup (xfstest +
> dm-flakey), I have the workload scripts attached to the end of the
> mail which might make your task simpler.
> 
> Interestingly we seem to have found another bug that breaks rename
> atomicity and results in a previously fsynced file missing.
> 
> Workload:
> 1. mkdir A
> 2. creat A/bar (*)
> 3. fsync A/bar
> 4. mkdir B
> 5. creat B/bar
> 6. rename B/bar A/bar
> 7. creat A/foo
> 8. fsync A/foo
> 9. fsync A
> --- crash---
> 
> When we recover from the crash, we see that file A/bar goes missing.
> If the rename did not persist, we expect to see A/bar(*) created in
> step 2 above, or if the rename indeed persisted, we still expect file
> A/bar to be present.

I'm no fsync expert and the lack of standard or well defined behaviour
(mentioned elsewhere) leads me to question, on what do you base your
expectations? Not only for this report, but in general during your
testing.

Comparing various filesystems will show that at best it's implementation
defined and everybody has their own reasons for doing it one way or
another, or request fsync at particular time etc.

We have a manual page in section 5 that contains general topics of
btrfs, so documenting the fsync specifics would be good.
