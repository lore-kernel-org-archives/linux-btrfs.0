Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab3EUS3Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 May 2013 14:29:25 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, Josef Bacik <josef@redhat.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/4] btrfs: offline dedupe v1
Date: Tue, 21 May 2013 11:28:24 -0700
Message-Id: <1369160908-26195-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

The following series of patches implements in btrfs an ioctl to do
offline deduplication of file extents.

To be clear, "offline" in this sense means that the file system is
mounted and running, but the dedupe is not done during file writes,
but after the fact when some userspace software initiates a dedupe.

The primary patch is loosely based off of one sent by Josef Bacik back
in January, 2011.

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/8508

I've made significant updates and changes from the original. In
particular the structure passed is more fleshed out, this series has a
high degree of code sharing between itself and the clone code, and the
locking has been updated.


The ioctl accepts a struct:

struct btrfs_ioctl_same_args {
	__u64 logical_offset;	/* in - start of extent in source */
	__u64 length;		/* in - length of extent */
	__u16 dest_count;	/* in - total elements in info array */
	__u16 reserved1;
	__u32 reserved2;
	struct btrfs_ioctl_same_extent_info info[0];
};

Userspace puts each duplicate extent (other than the source) in an
item in the info array. As there can be multiple dedupes in one
operation, each info item has it's own status and 'bytes_deduped'
member. This provides a number of benefits:

- We don't have to fail the entire ioctl because one of the dedupes failed.

- Userspace will always know how much progress was made on a file as we always
  return the number of bytes deduped.


#define BTRFS_SAME_DATA_DIFFERS	1
/* For extent-same ioctl */
struct btrfs_ioctl_same_extent_info {
	__s64 fd;		/* in - destination file */
	__u64 logical_offset;	/* in - start of extent in destination */
	__u64 bytes_deduped;	/* out - total # of bytes we were able
				 * to dedupe from this file */
	/* status of this dedupe operation:
	 * 0 if dedup succeeds
	 * < 0 for error
	 * == BTRFS_SAME_DATA_DIFFERS if data differs
	 */
	__s32 status;		/* out - see above description */
	__u32 reserved;
};


The kernel patches are based off Linux v3.9. The ioctl has been tested
against a small variety of files.

A git tree for the kernel changes can be found at:

https://github.com/markfasheh/btrfs-extent-same


I have a userspace project, duperemove available at:

https://github.com/markfasheh/duperemove

Hopefully this can serve as an example of one possible usage of the ioctl.

duperemove takes a list of files as argument and will search them for
duplicated extents. My most recent changes have been to integrate it
with btrfs_extent_same so that the '-D' switch will have it fire off
dedupe requests once processing of data is complete. Integration with
extent_same has *not* been tested yet so don't expect that to work
flawlessly.

Within the duperemove repo is a file, btrfs-extent-same.c that acts as
a test wrapper around the ioctl. It can be compiled completely
seperately from the rest of the project via "make
btrfs-extent-same". This makes direct testing of the ioctl more
convenient.

Code review is very much appreciated. Thanks,
     --Mark


ChangeLog

- don't error on large length value in btrfs exent-same, instead we just
  dedupe the maximum allowed.  That way userspace doesn't have to worry
  about an arbitrary length limit.

- btrfs_extent_same will now loop over the dedupe range at 1MB increments (for
  a total of 16MB per request)

- cleaned up poorly coded while loop in __extent_read_full_page() (thanks to
  David Sterba <dsterba@suse.cz> for reporting this)

- included two fixes from Gabriel de Perthuis <g2p.code@gmail.com>:
   - allow dedupe across subvolumes
   - don't lock compressed pages twice when deduplicating

- removed some unused / poorly designed fields in btrfs_ioctl_same_args.
  This should also give us a bit more reserved bytes.

- return -E2BIG instead of -ENOMEM when arg list is too large (thanks to
  David Sterba <dsterba@suse.cz> for reporting this)

- Some more reserved bytes are now included as a result of some of my
  cleanups. Quite possibly we could add a couple more.
