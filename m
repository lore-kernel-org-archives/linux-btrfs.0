From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Log parent inode if it is newer than the last commit
Date: Mon, 08 Nov 2010 15:26:08 -0500
Message-ID: <1289247820-sup-7675@think>
References: <20101106200305.5d9eb7e0.kitayama@cl.bb4u.ne.jp> <1289224052-sup-1226@think> <20101108232751.3a6cecd0.kitayama@cl.bb4u.ne.jp>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20101108232751.3a6cecd0.kitayama@cl.bb4u.ne.jp>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Itaru Kitayama's message of 2010-11-08 09:27:51 -0500:
> 
> I've been puzzled why I see a flood of ENOENT returned upon rename during Fedora 13 and 14's GDM session. 
> 
> The case is of course handled by your recent patch which is in upstream and btrfs-unstable, but I thought 
> doing a log look-up always fail is inefficient so I checked the code path that set inode's logged_trans field.   

Oh ok, I thought you were trying to make sure it was relogged, so I read
this wrong.  You're assuming that if it was ever logged we don't need to
log it again, which does look correct.

Thanks for the patch.

-chris
