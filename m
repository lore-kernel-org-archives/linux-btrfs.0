From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Way to quickly "revert back" to a snapshot?
Date: Mon, 26 Oct 2009 18:38:42 +0900
Message-ID: <20091026093842.GF5564@think>
References: <4AD9FCDC.6060107@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: John Dong <jdong@ubuntu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AD9FCDC.6060107@ubuntu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 17, 2009 at 01:20:28PM -0400, John Dong wrote:
> Suppose I want to do test something insane (like a massive OS
> update) to my system, and create a snapshot before doing so.
> Afterwards, if I decide my system is hosed and I'd like to revert
> back to the snapshot and forget any of this actually happened,
> what's the quickest way of doing it. It seems like by btrfs's design
> there should be a way to just "set the head" of the filesystem back
> to the snapshot, like git-reset, right?

This is near the top of the list of features I want to add for 2.6.33.
Basically all we need is a way to swap the default subvolume (which is
just a directory entry) pointer with another subvolume.

We also want a way to find an snapshot all the subvolumes and snapshots
underneath a given root.  That way the user won't have to do it
manually (snapshotting isn't recursive by default).

If anyone is interested in a coding project, both are fairly easy, just
let me know.

-chris


