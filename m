Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48509 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753122AbdIXWOp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Sep 2017 18:14:45 -0400
Date: Mon, 25 Sep 2017 00:13:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: check: check invalid extent_inline_ref type
 in lowmem
Message-ID: <20170924221311.GV29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170919083213.9082-1-suy.fnst@cn.fujitsu.com>
 <ab586271-41f9-611f-ec0b-179a3a030f67@gmx.com>
 <e23db2e8-955e-b7bd-7877-9a005ed07ff0@cn.fujitsu.com>
 <8902982e-7a39-e01e-719d-fef2a859b227@gmx.com>
 <ef97b663-d58d-f065-5b9c-bdffeb4c8ad5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ef97b663-d58d-f065-5b9c-bdffeb4c8ad5@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 24, 2017 at 05:17:19PM +0300, Nikolay Borisov wrote:
> >>> However, such whac-a-mole fix will finally be a nightmare to maintain.
> >>>
> >>> What about integrating all of such validation checkers into one place?
> >>> So fsck part will only need to check their cross reference without
> >>> bothering such corruption.
> >>>
> >> I was confused how to fix the bug(new checker or little changes
> >> in this patch).
> >> The reason why I fix it in this way is that most callers do
> >> check type before calling btrfs_extent_inline_ref_size().
> >>
> >> Since you prefer the former, I'm going to do it.
> > 
> > Current version looks good enough as a fix.>
> > Just saying we'd better using an integrated solution later.
> 
> I agree with you that we should have an integrated solution but frankly
> I'd rather see it sooner rather than later, because history has shown
> that if something is not done when it's first talked about it usually
> gets bogged down by other work.  With this in mind, Su, might I ask you
> that you repost the patch but with the centralised idea of handling the
> validation lifted from Qu's kernel side patches.

Agreed.
