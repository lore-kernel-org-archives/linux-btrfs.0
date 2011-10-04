From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 00/65] Error handling patchset v3
Date: Mon, 03 Oct 2011 23:22:30 -0400
Message-ID: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all -

Here's my current error handling patchset, against 3.1-rc8. Almost all of
this patchset is preparing for actual error handling. Before we start in
on that work, I'm trying to reduce the surface we need to worry about. It
turns out that there is a ton of code that returns an error code but never
actually reports an error.

The patchset has grown to 65 patches. 46 of them change functions that
currently return int to return void. Many of them didn't even have the
error codes checked in the caller to begin with. 10 of the patches push
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

-Jeff


