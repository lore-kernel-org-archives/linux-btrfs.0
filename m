From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs subvolume snapshot hung in btrfs_commit_transaction
Date: Thu, 16 Dec 2010 20:47:05 -0500
Message-ID: <1292550402-sup-6711@think>
References: <20101212034339.GA26170@idallen.ca> <20101212081359.GA7389@idallen.ca> <20101214022324.GA21001@idallen.ca>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Ian! D. Allen" <idallen@idallen.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20101214022324.GA21001@idallen.ca>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Ian! D. Allen's message of 2010-12-13 21:23:24 -0500:
> I can reliably get btrfs 0.19 to hang in btrfs_commit_transaction.
> Below is another case where it hung after creating just 110 snapshots
> of /var/log/.  Here is an excerpt from the script log file showing the
> last good snapshot followed by the hang:

I think this hang is something that sage fixed.  Which kernel is this
ubuntu including?

-chris
