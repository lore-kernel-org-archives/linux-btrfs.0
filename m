Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40352 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758984AbeD0Ux0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 16:53:26 -0400
Date: Fri, 27 Apr 2018 16:53:13 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.cz>, Jayashree Mohan <jayashree2912@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        Filipe Manana <fdmanana@kernel.org>
Subject: Re: Inconsistent behavior of fsync in btrfs
Message-ID: <20180427205313.GM5965@thunk.org>
References: <CA+EzBbC7rmYsKjy_+rkwJLK-bmU51q+a4rnezvOoZYyJ8kWGqg@mail.gmail.com>
 <34B2B717-B12D-44F4-B0D0-E3D606BBEFA6@fb.com>
 <CA+EzBbBaZjcdHi4O4W8LZ2JvpYhN_hFGvktaeFYRfSygW3sK7A@mail.gmail.com>
 <20180427160740.GD21272@twin.jikos.cz>
 <1A75793D-6487-4EE6-9F4D-AD538D7283CA@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1A75793D-6487-4EE6-9F4D-AD538D7283CA@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 11:33:29AM -0600, Chris Mason wrote:
> My goal for the fsync tree log was to make it just do the right thing most
> of the time.  We mostly got there, thanks to a ton of fixes and test cases
> from Filipe.
> 
> fsync(some file) -- all the names for this file will exist, without having
> to fsync the directory.
> 
> fsync(some dir) -- ugh, don't fsync the directory.  But if you do, all the
> files/subdirs will exist, and unlinks will be done and renames will be
> included.  This is slow and may require a full FS commit, which is why we
> don't want dirs fsunk.

What ext4 does is this:

fsync(some file) -- for a newly created file, the filename that it was
	created under will exist.  If the file has a hard-link added,
	the hard link is not guarnateed to be written to disk

fsync(some dir) -- all changes to file names in thentee directory will
	exist after the crash.  It does *not* guarantee that any data
	changes to any of files in the directories will persist after
	a crash.

It seems to me that it would be desirable if all of the major file
systems have roughly the same minimum guarantee for fsync(2), so that
application writers don't have to make file-system specific
assumptions.  In general the goal ought to be "the right thing" should
happen.

The reason why ext4 doesn't sync all possible hard link names is that
(a) that's not a common requiremnt for most applications, and (b) it's
too hard to find all of the directories which might contain a hard
link to a particular file.  But otherwise, the semantics seem to
largely match up with what Chris as suggested for btrfs.

	      	      	   	    - Ted
