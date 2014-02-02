Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:33163 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752444AbaBBV5X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Feb 2014 16:57:23 -0500
Date: Mon, 3 Feb 2014 08:57:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, jbacik@fb.com
Subject: Re: [PATCH] xfstests: more tests for test case btrfs/030
Message-ID: <20140202215720.GT2212@dastard>
References: <1391220332-22118-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391220332-22118-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 01, 2014 at 02:05:32AM +0000, Filipe David Borba Manana wrote:
> This change adds some new tests for btrfs' incremental send feature.
> These are all related with inverting the parent-child relationship
> of directories, and cover the cases:
> 
> * when the new parent didn't get renamed (just moved)
> * when a child file of the former parent gets renamed too
> 
> These new cases are fixed by the following btrfs linux kernel patches:
> 
> * "Btrfs: more send support for parent/child dir relationship inversion"
> * "Btrfs: fix send dealing with file renames and directory moves"
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

Rather than modifying 030 which will cause it to fail on kernels
where it previously passed, can you factor out the common code and
create a new test with the additional coverage?

i.e. the rule of thumb is that once a test is "done" we don't go
back and modify it in significant ways - we write a new unit test
that covers the new/extended functionality. Redundancy in unit tests
is not a bad thing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
