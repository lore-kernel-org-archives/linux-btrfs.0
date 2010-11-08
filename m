From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Log parent inode if it is newer than the last commit
Date: Mon, 08 Nov 2010 08:50:21 -0500
Message-ID: <1289224052-sup-1226@think>
References: <20101106200305.5d9eb7e0.kitayama@cl.bb4u.ne.jp>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20101106200305.5d9eb7e0.kitayama@cl.bb4u.ne.jp>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Itaru Kitayama's message of 2010-11-06 07:03:05 -0400:
> 
> In the file sync path, file's parent inode is logged if it is newer than the last
> commit. This patch checks also the last_trans field as well as generation.
> 
> As btrfs_log_inode updates the logged_trans field of parent dir's inode, tree-log
> lookup operations are suppressed upon unlink.

Is there a specific test case you're working on for this?  The idea
behind the logging code is that we use the backrefs in the inode to
recreate the inode in the directory if we crash.

This doesn't work if the directory doesn't exist when we come back, so
the code logs the directory if it is newer than the last commit.

As long as the directory exists in the tree, we should be able to safely
continue replay without logging it again.

-chris
