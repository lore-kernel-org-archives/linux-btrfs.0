Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46995 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3FLSKk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Jun 2013 14:10:40 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id EF45C7C0692
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Jun 2013 12:10:39 -0600 (MDT)
Date: Wed, 12 Jun 2013 14:10:37 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Mark Fasheh <mfasheh@suse.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clmason@fusionio.com>, Josef Bacik <josef@redhat.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 0/4] btrfs: offline dedupe v2
Message-ID: <20130612181037.GD658@localhost.localdomain>
References: <1370982698-757-1-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1370982698-757-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 11, 2013 at 02:31:34PM -0600, Mark Fasheh wrote:
> Hi,
> 
> The following series of patches implements in btrfs an ioctl to do
> offline deduplication of file extents.
> 
> To be clear, "offline" in this sense means that the file system is
> mounted and running, but the dedupe is not done during file writes,
> but after the fact when some userspace software initiates a dedupe.
> 
> The primary patch is loosely based off of one sent by Josef Bacik back
> in January, 2011.
> 
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/8508
> 
> I've made significant updates and changes from the original. In
> particular the structure passed is more fleshed out, this series has a
> high degree of code sharing between itself and the clone code, and the
> locking has been updated.
> 
> 
> The ioctl accepts a struct:
> 
> struct btrfs_ioctl_same_args {
> 	__u64 logical_offset;	/* in - start of extent in source */
> 	__u64 length;		/* in - length of extent */
> 	__u16 dest_count;	/* in - total elements in info array */
> 	__u16 reserved1;
> 	__u32 reserved2;
> 	struct btrfs_ioctl_same_extent_info info[0];
> };
> 
> Userspace puts each duplicate extent (other than the source) in an
> item in the info array. As there can be multiple dedupes in one
> operation, each info item has it's own status and 'bytes_deduped'
> member. This provides a number of benefits:
> 
> - We don't have to fail the entire ioctl because one of the dedupes failed.
> 
> - Userspace will always know how much progress was made on a file as we always
>   return the number of bytes deduped.
> 
> 
> #define BTRFS_SAME_DATA_DIFFERS	1
> /* For extent-same ioctl */
> struct btrfs_ioctl_same_extent_info {
> 	__s64 fd;		/* in - destination file */
> 	__u64 logical_offset;	/* in - start of extent in destination */
> 	__u64 bytes_deduped;	/* out - total # of bytes we were able
> 				 * to dedupe from this file */
> 	/* status of this dedupe operation:
> 	 * 0 if dedup succeeds
> 	 * < 0 for error
> 	 * == BTRFS_SAME_DATA_DIFFERS if data differs
> 	 */
> 	__s32 status;		/* out - see above description */
> 	__u32 reserved;
> };
> 
> 
> The kernel patches are based off Linux v3.9. At this point I've tested the
> ioctl against a decent variety of files and conditions.
> 
> A git tree for the kernel changes can be found at:
> 
> https://github.com/markfasheh/btrfs-extent-same
> 
> 
> I have a userspace project, duperemove available at:
> 
> https://github.com/markfasheh/duperemove
> 
> Hopefully this can serve as an example of one possible usage of the ioctl.
> 
> duperemove takes a list of files as argument and will search them for
> duplicated extents. If given the '-D' switch, duperemove will send dedupe
> requests for same extents and display the results.
> 
> Within the duperemove repo is a file, btrfs-extent-same.c that acts as
> a test wrapper around the ioctl. It can be compiled completely
> seperately from the rest of the project via "make
> btrfs-extent-same". This makes direct testing of the ioctl more
> convenient.
> 
> 
> Limitations
> 
> We can't yet dedupe within the same file (that is, source and destination
> are the same inode). This is due to a limitation in btrfs_clone().
> 
> 
> Perhaps this isn't a limiation per-se but extent-same requires read/write
> access to the files we want to dedupe.  During my last series I had a
> conversation with Gabriel de Perthuis about access checking where we tried
> to maintain the ability for a user to run extent-same against a readonly
> snapshot. In addition, I reasoned that since the underlying data won't
> change (at least to the user) that we ought only require the files to be
> open for read.
> 
> What I found however is that neither of these is a great idea ;)
> 
> - We want to require that the inode be open for writing so that an
>   unprivileged user can't do things like run dedupe on a performance
>   sensitive file that they might only have read access to.  In addition I
>   could see it as kind of a surprise (non-standard behavior) to an
>   administrator that users could alter the layout of files they are only
>   allowed to read.
> 
> - Readonly snapshots won't let you open for write anyway (unsuprisingly,
>   open() returns -EROFS).  So that kind of kills the idea of them being able
>   to open those files for write which we want to dedupe.
> 
> That said, I still think being able to run this against a set of readonly
> snapshots makes sense especially if those snapshots are taken for backup
> purposes. I'm just not sure how we can sanely enable it.
> 
> 
> 
> Code review is very much appreciated. Thanks,
>      --Mark
> 
> 
> ChangeLog
> 
> - check that we have appropriate access to each file before deduping. For
>   the source, we only check that it is opened for read. Target files have to
>   be open for write.
> 
> - don't dedupe on readonly submounts (this is to maintain 
> 
> - check that we don't dedupe files with different checksumming states
>  (compare BTRFS_INODE_NODATASUM flags)
> 
> - get and maintain write access to the mount during the extent same
>   operation (mount_want_write())
> 
> - allocate our read buffers up front in btrfs_ioctl_file_extent_same() and
>   pass them through for re-use on every call to btrfs_extent_same(). (thanks
>   to David Sterba <dsterba@suse.cz> for reporting this
> 
> - As the read buffers could possibly be up to 1MB (depending on user
>   request), we now conditionally vmalloc them.
> 
> - removed redundant check for same inode. btrfs_extent_same() catches it now
>   and bubbles the error up.
> 
> - remove some unnecessary printks
> 
> Changes from RFC to v1:
> 
> - don't error on large length value in btrfs exent-same, instead we just
>   dedupe the maximum allowed.  That way userspace doesn't have to worry
>   about an arbitrary length limit.
> 
> - btrfs_extent_same will now loop over the dedupe range at 1MB increments (for
>   a total of 16MB per request)
> 
> - cleaned up poorly coded while loop in __extent_read_full_page() (thanks to
>   David Sterba <dsterba@suse.cz> for reporting this)
> 
> - included two fixes from Gabriel de Perthuis <g2p.code@gmail.com>:
>    - allow dedupe across subvolumes
>    - don't lock compressed pages twice when deduplicating
> 
> - removed some unused / poorly designed fields in btrfs_ioctl_same_args.
>   This should also give us a bit more reserved bytes.
> 
> - return -E2BIG instead of -ENOMEM when arg list is too large (thanks to
>   David Sterba <dsterba@suse.cz> for reporting this)
> 
> - Some more reserved bytes are now included as a result of some of my
>   cleanups. Quite possibly we could add a couple more.

Ok I'm relatively happy with this set, I just want to have an xfstest on deck to
test it with.  Once I have an xfstest to run to verify its sanity I'll pull it
in.  Thanks,

Josef
