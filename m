From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: Re: [PATCH] Log parent inode if it is newer than the last commit
Date: Mon, 8 Nov 2010 23:27:51 +0900
Message-ID: <20101108232751.3a6cecd0.kitayama@cl.bb4u.ne.jp>
References: <20101106200305.5d9eb7e0.kitayama@cl.bb4u.ne.jp>
	<1289224052-sup-1226@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1289224052-sup-1226@think>
List-ID: <linux-btrfs.vger.kernel.org>


I've been puzzled why I see a flood of ENOENT returned upon rename during Fedora 13 and 14's GDM session. 

The case is of course handled by your recent patch which is in upstream and btrfs-unstable, but I thought 
doing a log look-up always fail is inefficient so I checked the code path that set inode's logged_trans field.   

Itaru

On Mon, 08 Nov 2010 08:50:21 -0500
Chris Mason <chris.mason@oracle.com> wrote:

> Excerpts from Itaru Kitayama's message of 2010-11-06 07:03:05 -0400:
> > 
> > In the file sync path, file's parent inode is logged if it is newer than the last
> > commit. This patch checks also the last_trans field as well as generation.
> > 
> > As btrfs_log_inode updates the logged_trans field of parent dir's inode, tree-log
> > lookup operations are suppressed upon unlink.
> 
> Is there a specific test case you're working on for this?  The idea
> behind the logging code is that we use the backrefs in the inode to
> recreate the inode in the directory if we crash.
> 
> This doesn't work if the directory doesn't exist when we come back, so
> the code logs the directory if it is newer than the last commit.
> 
> As long as the directory exists in the tree, we should be able to safely
> continue replay without logging it again.
> 
> -chris

