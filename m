Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbcGGIIG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 04:08:06 -0400
From: Pavel Raiskup <praiskup@redhat.com>
To: bug-tar@gnu.org
Cc: Andreas Dilger <adilger@dilger.ca>, linux-btrfs@vger.kernel.org
Subject: Re: [Bug-tar] stat() on btrfs reports the st_blocks with delay (data loss in archivers)
Date: Thu, 07 Jul 2016 10:08:03 +0200
Message-ID: <7854570.OBJzfVvvRz@unused-4-107.brq.redhat.com>
In-Reply-To: <A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca>
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com> <A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, July 4, 2016 1:35:25 PM CEST Andreas Dilger wrote:
> I think in addition to fixing btrfs (because it needs to work with existing
> tar/rsync/etc. tools) it makes sense to *also* fix the heuristics of tar to
> handle this situation more robustly.

What I was rather thinking about is to remove the [2] heuristic.  As there is
now SEEK_HOLE implemented, the need for that check "completely sparse files"
might be considered less useful.  With [1], I'm not sure -- is it that bad to
face some false positive there? (it is documented that tar shouldn't be run
concurrently with other processes writing to archived files .., and waiting for
flush here is probably a very similar race condition).

> One option is if st_blocks == 0 then tar should also check if st_mtime is
> less than 60s in the past, and if yes then it should call fsync() on the
> file to flush any unwritten data to disk , or assume the file is not sparse
> and read the whole file, so that it doesn't incorrectly assume that the file
> is sparse and skip archiving the file data.

The reported fact 'st_blocks != 0' doesn't mean that the fsync() call is not
needed, so I'm not 100% we should special-case the 'st_blocks == 0' files.

--

As this effectively breaks tar's testsuite on btrfs, could we also explicitly
sync in 'genfile'?

Pavel

> 
> Cheers, Andreas
> 
> > [1] http://git.savannah.gnu.org/cgit/paxutils.git/tree/lib/system.h?id=ec72abd9dd63bbff4534ec77e97b1a6cadfc3cf8#n392
> > [2] http://git.savannah.gnu.org/cgit/tar.git/tree/src/sparse.c?id=ac065c57fdc1788a2769fb119ed0c8146e1b9dd6#n273

