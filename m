From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH]  Btrfs: return EUCLEAN rather than ENXIO once internal
 error has occurred for SEEK_DATA/SEEK_HOLE inquiry
Date: Thu, 9 Feb 2012 15:51:18 +1100
Message-ID: <20120209045118.GE7479@dastard>
References: <4F334178.7030704@oracle.com>
 <4F3346CF.3090908@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Jeff Liu <jeff.liu@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F3346CF.3090908@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 09, 2012 at 12:08:47PM +0800, Jeff Liu wrote:
> On 02/09/2012 11:46 AM, Jeff Liu wrote:
> 
> > By referring to http://linux.die.net/man/2/lseek, return ENXIO only
> > when "offset beyond EOF" for either SEEK_DATA or SEEK_HOLE inquiry.
> > But we return it in case of internal issue too if btrfs_get_extent_fiemap() failed
> > due to other issues.  This will confuse the user applications to be expecting ENXIO when
> > trying to find a specific data or hole location once it has occurred.
> > 
> > Thanks Dave for pointing that out in XFS thread.
> > 
> > This patch fix it to return EUCLEAN, or maybe another particular errno is more reasonable in Btrfs to indicate this fatal error?
> 
> Or maybe just return the error that was happened at internal routine, to
> give user more accurate error info, which is better?

Return the internal error unchanged - a failure to read the extent
list (EIO) is different to a corruption detected in the extent
map read from disk (EUCLEAN). Having a user report the appropriate
error makes our life much simpler when it comes to trying to
understand their problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
