Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:38777 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726540AbeITXZZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 19:25:25 -0400
Date: Thu, 20 Sep 2018 10:40:34 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] rb_first to rb_first_cached conversion
Message-ID: <20180920174033.mxclsy5fbcoycwky@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1534967513-117382-1-git-send-email-bo.liu@linux.alibaba.com>
 <20180920164958.GA5847@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180920164958.GA5847@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 20, 2018 at 06:49:59PM +0200, David Sterba wrote:
> On Thu, Aug 23, 2018 at 03:51:48AM +0800, Liu Bo wrote:
> > Several structs in btrfs are using rb_first() in a while loop, it'd be
> > more efficient to do this with rb_first_cached() which has the O(1)
> > complexity.
> > 
> > This patch set updates five structs which may have a large rb tree in
> > practice
> > 
> > Liu Bo (5):
> >   Btrfs: href_root: use rb_first_cached
> >   Btrfs: href->ref_tree: use rb_first_cached
> >   Btrfs: delayed_items: use rb_first_cached
> >   Btrfs: extent_map: use rb_first_cached
> >   Btrfs: preftree: use rb_first_cached
> 
> For the record, patches have been merged to misc-next. I've changed the
> subject titles to
> 
> Btrfs: delayed-refs: use rb_first_cached for href_root
> Btrfs: delayed-refs: use rb_first_cached for ref_tree
> Btrfs: delayed-inode: use rb_first_cached for ins_root and del_root
> Btrfs: extent_map: use rb_first_cached
> Btrfs: preftree: use rb_first_cached
> 
> added Holger's tested-by and my reviewed-by.

Thanks so much for the efforts.

thanks,
-liubo
