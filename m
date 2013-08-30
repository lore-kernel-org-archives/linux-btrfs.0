Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab3H3QIk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 12:08:40 -0400
Date: Fri, 30 Aug 2013 18:08:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/15] btrfs-progs: get C=1 sparse checking working again
Message-ID: <20130830160838.GN23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
 <1376522205-16992-2-git-send-email-zab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1376522205-16992-2-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 14, 2013 at 04:16:31PM -0700, Zach Brown wrote:
> There were a few problems that were breaking sparse checking:
> 
> - We were defining CHECK_ENDIAN late in the environment, after
>   linux/fs.h has been included which defines __force and __bitwise in
>   confusing ways that conflict with ours.  Define it up with __CHECKER__
>   so that linux/fs.h and our copy are acting on the same input.
> 
> - We had manually set a few of gcc's internal defines to give to sparse.
>   It's easier to just ask gcc for all the defines it sets and hand those
>   to sparse.
> 
> - We weren't passing the same *FLAGS to sparse as we were to CC.
> 
> - glibc has so many errors with FORTIFY turned on that sparse gives up
>   and doesn't show us any errors from our code.  It's a questionable
>   hack to always turn on FORTIFY ourselves, so we'll just not do that
>   when building with sparse.
> 
> And add a nice '[SP]' quiet output line for sparse checks.

Very nice, thanks.

I'm getting this error, for each built object file:

$ make V=1 C=1
    [SP]     ctree.o
sparse -include .cc-defines.h  -D__CHECKER__ -D__CHECK_ENDIAN__ -Wbitwise -Wuninitialized -Wshadow -Wundef -Wall -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES -fPIC -g -O1 ctree.c
/usr/include/stdio.h:33:12: error: unable to open 'stddef.h'
make: *** [ctree.o] Error 1

