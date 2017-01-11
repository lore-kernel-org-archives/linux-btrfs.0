Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42599 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755660AbdAKQvR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 11:51:17 -0500
Date: Wed, 11 Jan 2017 17:51:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 00/12] Refactor btrfs_inode VS inode in
 delayed-inode.c
Message-ID: <20170111165100.GL12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 10, 2017 at 08:35:30PM +0200, Nikolay Borisov wrote:
> After following the discussion in [1] I took a look at what's the 
> state of VFS-related members being used in core BTRFS code. It turned 
> out there are quite a few functions which operate on struct btrfs_inode, 
> yet take struct inode. As a result they have to resort ot excessive 
> usage of BTRFS_I, furthermore passing inode around doesn't help the 
> poor reader inferring why inode might be passed to a particular function. 
> 
> In order to better separate core btrfs functionalities from those part,
> which interface with the VFS I took a look around the code and this is 
> the result. I'd like to solicit opinions whether people think this 
> refactoring is useful, since I have gathered a list of a lot more
> functions which might use a bit of inode VS btrfs_inode changes. Also, 
> a lot of function take inode just because btrfs_ino was taking an inode.

Agreed, this is a good direction how to clean up the code.

> The patches are self-explanatory, with the first one dealing with 
> btrfs_ino being the bulk of it. This paves the way to restructuring 
> a lot of functions. 
> 
> If the maintainers think this should be merged I'd rather resend it 
> as a single patch so as not to pollute the git history. This 
> version can be used for fine-grained discussion and feedback. 

Actually I like the way it's separated as it keeps the review easy, it
keeps the context in one function and does one change.

It would be interesting the see the result as reported by the 'size'
utility before and after the patchset, the effects of removed BTRFS_I
calls.

I'll do a testing merge on top of current for-next to see how intrusive
it is. If it turns out to be ok, I'll add the patches to the cleanups
branch.
