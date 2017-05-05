Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56322 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751429AbdEEPnb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 May 2017 11:43:31 -0400
Date: Fri, 5 May 2017 08:43:23 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, hurikhan77@gmail.com
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        bo.li.liu@oracle.com, fdmanana@suse.com, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Message-ID: <20170505154323.hx6ht7jo5mnl6mye@merlins.org>
References: <20170505024041.4jdfponlichetnwm@merlins.org>
 <54c51818-c46d-91de-19fd-d165b2d88ecb@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54c51818-c46d-91de-19fd-d165b2d88ecb@cn.fujitsu.com>
Subject: Re: 4.11 relocate crash, null pointer + rolling back a filesystem by
 X hours?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks again for your answer. Obviously even if my filesystem is toast,
it's useful to learn from what happened.

On Fri, May 05, 2017 at 01:03:02PM +0800, Qu Wenruo wrote:
> > > So unfortunately, your fs/subvolume trees are also corrupted.
> > > And almost no chance to do a graceful recovery.
> > So I'm confused here. You're saying my metadata is not corrupted (and in
> > my case, I have DUP, so I should have 2 copies),
> 
> Nope, here I'm all talking about metadata (tree blocks).
> Difference is the owner, either extent tree or fs/subvolume tree.
 
I see. I didn't realize that my filesystem managed to corrupt both
copies of its metadata.

> The fsck doesn't check data blocks.

Right, that's what scrub does, fair enough.

> The problem is, tree blocks (metadata) that refers these data blocks are
> corrupted.
> 
> And they are corrupted in such a way that both extent tree (tree contains
> extent allocation info) and fs tree (tree contains real fs info, like inode
> and data location) are corrupted.
> 
> So graceful recovery is not possible now.

I see, thanks for explaining.

> Unfortunately, no, even you have 2 copies, a lot of tree blocks are
> corrupted that neither copy matches checksum.
 
Thanks for confirming. I guess if I'm having corruption due to a bad
card, it makes sense that both get updated after one another and both
got corrupted for the same reason.

> Corrupted blocks are corrupted, that command is just trying to corrupt it
> again.
> It won't do the black magic to adjust tree blocks to avoid them.
 
I see. you may hve seen the earlier message from Kai Krakow who was
able to to recover his FS by trying this trick, but I understand it
can't work in all cases.

Thanks again for your answers.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
