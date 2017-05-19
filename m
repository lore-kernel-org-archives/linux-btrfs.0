Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42918 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751976AbdESPBp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 11:01:45 -0400
Date: Fri, 19 May 2017 11:01:38 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Anand Jain <anand.jain@oracle.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, dsterba@suse.com, quwenruo@cn.fujitsu.com
Subject: Re: [PATCH RFC] vfs: add mount umount logs
Message-ID: <20170519150138.i65ycwawfhru6skz@thunk.org>
References: <20170518100804.25538-1-anand.jain@oracle.com>
 <20170518173947.GA4505@birch.djwong.org>
 <cdc5185c-f69e-d296-99c8-b2af64d99833@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cdc5185c-f69e-d296-99c8-b2af64d99833@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 19, 2017 at 08:17:55AM +0800, Anand Jain wrote:
> > XFS already logs its own unmounts.
> 
>  Nice. as far as I know its only in XFS.

Ext4 logs mounts, but not unmounts.

> >  I prefer to let each filesystem log
> > its own unmount, because then the mount/unmount messages also have the
> > same prefix as all other messages coming from that filesystem driver.
> 
>  Ok. One nitpick though there are other mount types (remount, bind..),
>  and subsequent mounts of the same FS and FS driver can't log them
>  effectively.

The other issue is there is a difference between when an unmount is
started, or when a file system is unmounted in one namespace, and when
the file system as a whole is unmounted by the low-level because there
are no longer any references to the file system in any namespace.

More than once I've gotten a bug report for ext4 that was really
caused by the fact that some program had forked a daemon process in
its own namespace, so when the USB thumbdrive was unmounted, it wasn't
*really* unmounted.  So being able to clearly express that in the logs
is also a good thing.

I think the way to do that is to have one set of logs for when the
file system is unmounted from one mount namespace (or from a bind
mount), with perhaps an indication of the number of remaining
refcounts, and to make this be distinct from the unmount of the
underlying low file system code, which should be logged by the file
system code itself.

					- Ted
