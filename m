Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbaKYScQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 13:32:16 -0500
Date: Tue, 25 Nov 2014 19:32:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] btrfs-progs: New 'lost+found' infrastructrue with
Message-ID: <20141125183215.GP26471@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1416820025-10373-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416820025-10373-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 24, 2014 at 05:06:59PM +0800, Qu Wenruo wrote:
> Introduce the new 'lost+found' dir and related infrastructure to create it
> in btrfs-progs.
> 
> [BUG]
> With the new infrastructure, fix a bug that some people reported in both
> kernel BZ and maillist, which there is some files' nlink is 1 but backref
> points to non-exist parent.
> The two reporters all report missing file(chrome config file), so we'd
> better not to delete such files but use the 'lost+found' dir.

Well, I don't like introducing the lost+found directory.

My idea is to extend the rescue utilities to extract the unlinked and
copy them to a user defined directory and do not touch the filesystem.

Or, at least make the in-filesytem lost+found directory creation
optional. You've split the patches well so I'm going to pull 1-5
directly. Patch 6 should be updated a bit, I'll look closer and will let
you know.

> 2. Unify the repair framework.
> When writing the 6th patch, I think it is better to build a frame work
> that unify the check and repair framework.
> In 6th patch, my patchset and Josef's commit 2dc4c001 in fact has some
> similar function but do the repair in different time and functions.
> 
> I will try to build a unified framework for repair, each repair will be
> independent and have its own err number.
> And each repair function should work like the following:
> 1) Check the error number
> 2) Do the repair
> 3) Update the related btrfsck record(like newly created inode, deleted inode)

The unification is most welcome, feel free to send me anything that could be
merged as preparatory work (cleanups, safe changes, etc).
