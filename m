From: Jan Schubert <Jan.Schubert@GMX.li>
Subject: Re: btrfs-progs integration branch updated
Date: Sat, 6 Aug 2011 12:12:08 +0000 (UTC)
Message-ID: <loom.20110806T140829-805@post.gmane.org>
References: <20110804224334.GD8970@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills <hugo <at> carfax.org.uk> writes:
>    It includes the latest scrub patches, the compile fixes for gcc
> 4.6, and a selection of other, smaller features. Go forth and play.

I've to report a kernel crash after upgrading to this branch _and_ upgrading to 
official kernel 301 (coming from plain 30). I was not able to save the dump, 
sorry, a btrfs-zero-log did the trick. As I understood there has been no changes 
in 301 concerning btrfs, so I'm now on the for-chris branch of btrfs-progs-
unstable and everyting is fine (so far).

HTH,
Jan


