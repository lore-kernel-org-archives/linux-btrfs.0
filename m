Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47740 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751260AbcJCQc4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Oct 2016 12:32:56 -0400
Date: Mon, 3 Oct 2016 18:32:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC][PATCH] btrfs-progs: move sources shared with kernel to own
 directory
Message-ID: <20161003163253.GD6576@suse.cz>
Reply-To: dsterba@suse.cz
References: <1475167106-18054-1-git-send-email-dsterba@suse.com>
 <a0920b31-3dad-5253-7d6f-938bb7bedb0b@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a0920b31-3dad-5253-7d6f-938bb7bedb0b@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 30, 2016 at 09:11:30AM +0800, Qu Wenruo wrote:
> > - cmds/           - (planned) cmds-*.[ch]
> 
> Sounds good, so we can skip the "cmds-" prefix then.

Yes. We have to start somewhere, file renaming is left for later.

> 
> > - convert/        - move as-is, split later, eg. per filsystem
> > - image/          - move as-is, split if needed
> > - check/          - split from cmds-check
> 
> Pretty cool.
> I'm also moving some code into its own dir doing the user-space scrub work.
> (While I'm creating a new dir called fsck/ and put my scrub code into 
> it, rename it to check/ won't be a problem though)
> 
> While I'm not sure what is going to be in kernel-shared/ dir.
> 
> Uapi headers? or things like disk-io.c volumes.c?

Headers and the files you mentioned. See the branch for complete list.
The headers could be further separated, public and private.

> For uapi headers, then kernel-shared/ may contain few files.
> For disk-io.c/volumes.c, they are not shared with kernel anymore.

Partial sharing should be enough. See changelong:

> > All files that share content and purpose with the corresponding file in
> > the kernel are moved to a separate directory. There's only some overlap,
> > can't be 100% match but many functions are shared. A diff between the
> > files can reveal changes that should be applied to the other codebase.

.
