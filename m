From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 00/66] [pull] Error handling patchset v5
Date: Mon, 24 Oct 2011 21:02:36 -0400
Message-ID: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all -

Here's my current error handling patchset, against David's integration
branch. Almost all of this patchset is preparing for actual error
handling.  Before we start in on that work, I'm trying to reduce the
surface we need to worry about. It turns out that there is a ton of code
that returns an error code but never actually reports an error.

The patchset has grown to 66 patches. 46 of them change functions that
currently return int to return void. Many of them didn't even have the
error codes checked in the caller to begin with. 11 of the patches push
error codes up into the caller.

The remaining 9 patches do:
- Add a btrfs_panic facility, with a mount option to select BUG or panic
- Catch tree operation failures
- Simplify/add some wrapper functions

The biggest change, which will probably merit some discussion, is the
introduction of slab-backed mempools in the delayed ref code. I expect
to use this technique in other areas of the code to deal with deep
failures that are impossible to recover gracefully from. Rather than
returning -ENOMEM, we keep a page's worth of objects around for each
node type. That allows the callers to be drastically simplified. There's
no reason in particular to start with the delayed ref code, it's just
where I happened to do it.

Changes since v3 in order of impact:
- Fixed an issue in ("btrfs: clear_extent_bit error push-up") where a
  positive error code returned by clear_extent_bit was being passed to
  callers of btrfs_direct_IO. The callers intepreted it as an error and
  xfstests reported corruption in test 130.
- Push-up patches have added __must_check to their prototypes so that
  new callers are forced to properly handle the error conditions, even if
  it's also with BUG_ON. Some callers weren't checking error codes at
  all and this will prevent those types of issues from being
  re-introduced.
- Added error push-up and tree locking check for convert_extent_bit.
- Moved btrfs_drop_snapshot checks into the patch that changed it to
  return int.

This is also available in my git repository at:
git://git.jeffreymahoney.com/linux/btrfs-unstable for-david-v5

It depends on git://repo.or.cz/linux-2.6/btrfs-unstable.git, starting
with commit f2ab07c6 ("Btrfs: fix the amount of space reserved for unlink").

I can rebase if necessary.

-Jeff

