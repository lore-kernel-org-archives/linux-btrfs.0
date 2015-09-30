Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbbI3O7W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 10:59:22 -0400
Date: Wed, 30 Sep 2015 16:58:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix a compiler warning of may be used
 uninitialized
Message-ID: <20150930145821.GG11442@suse.cz>
Reply-To: dsterba@suse.cz
References: <09827c6fe97dbbeb585e6214f7e40699061b8fc6.1441178370.git.zhaolei@cn.fujitsu.com>
 <20150929142134.GC11442@twin.jikos.cz>
 <00d701d0fb33$cfbc6a80$6f353f80$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <00d701d0fb33$cfbc6a80$6f353f80$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 30, 2015 at 11:55:13AM +0800, Zhao Lei wrote:
> > AFAICS the codepath that would use uninitialized value of count is not
> > reachable:
> > 
> > 		    add_to_ctl = true
> > 
> > 270                 if (info->offset > root->ino_cache_progress)
> > 271                         add_to_ctl = false;
> > 272                 else if (info->offset + info->bytes >
> > root->ino_cache_progress)
> > 273                         count = root->ino_cache_progress -
> > info->offset + 1;
> > 274                 else
> > 275                         count = info->bytes;
> > 276
> > 277                 rb_erase(&info->offset_index, rbroot);
> > 278                 spin_unlock(rbroot_lock);
> > 279                 if (add_to_ctl)
> > 280                         __btrfs_add_free_space(ctl, info->offset,
> > count);
> > 
> > count is defined iff add_to_ctl == true, so the patch is not necessary. And I'm
> > not quite sure that 0 passed down to __btrfs_add_free_space as 'bytes' makes
> > sense at all.
> 
> Agree above all.
> 
> So I write following description in changelog:
>   "Not real problem, just avoid warning of: ..."
> 
> It is just to avoid complier warning, no function changed.
> A warning in compiler output is not pretty:)

And the compiler is wrong in this case, the code is fine as is. I'd say
go fix you compiler and the output will be pretty :) No really, this
kind of fixes brings false sense of "fixing something in the code".
