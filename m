From: Chris Samuel <chris@csamuel.org>
Subject: Re: [3.2-rc7] slowdown, warning + oops creating lots of files
Date: Thu, 05 Jan 2012 09:23:52 +1100
Message-ID: <4F04D178.2070006@csamuel.org>
References: <20120104214445.GE17026@dastard> <20120104221105.GF17026@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120104221105.GF17026@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/01/12 09:11, Dave Chinner wrote:

> Looks to be reproducable.

Does this happen with rc6 ?

If not then it might be easy to track down as there are only
2 modifications between rc6 and rc7..

commit 08c422c27f855d27b0b3d9fa30ebd938d4ae6f1f
Author: Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri Dec 23 07:58:13 2011 -0500

    Btrfs: call d_instantiate after all ops are setup
    
    This closes races where btrfs is calling d_instantiate too soon during
    inode creation.  All of the callers of btrfs_add_nondir are updated to
    instantiate after the inode is fully setup in memory.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Chris Mason <chris.mason@oracle.com>

commit 8d532b2afb2eacc84588db709ec280a3d1219be3
Author: Chris Mason <chris.mason@oracle.com>
Date:   Fri Dec 23 07:53:00 2011 -0500

    Btrfs: fix worker lock misuse in find_worker
    
    Dan Carpenter noticed that we were doing a double unlock on the worker
    lock, and sometimes picking a worker thread without the lock held.
    
    This fixes both errors.
    
    Signed-off-by: Chris Mason <chris.mason@oracle.com>
    Reported-by: Dan Carpenter <dan.carpenter@oracle.com>


-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
