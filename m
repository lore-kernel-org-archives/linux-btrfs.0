Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752301AbcJKKHy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 06:07:54 -0400
Date: Tue, 11 Oct 2016 12:07:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, lakshmipathi.g@gmail.com
Subject: Re: [PATCH 2/4] btrfs-progs: Make btrfs-debug-tree print all
 readable strings for inode flags
Message-ID: <20161011100752.GM11398@suse.cz>
Reply-To: dsterba@suse.cz
References: <20161010031121.5017-1-quwenruo@cn.fujitsu.com>
 <20161010031121.5017-3-quwenruo@cn.fujitsu.com>
 <20161010155026.GL11398@twin.jikos.cz>
 <9f4cc38e-4c95-7938-fd74-6cf39411901e@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9f4cc38e-4c95-7938-fd74-6cf39411901e@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 11, 2016 at 10:18:51AM +0800, Qu Wenruo wrote:
> >> -/* Caller should ensure sizeof(*ret) >= 29 "NODATASUM|NODATACOW|READONLY" */
> >> +#define copy_one_inode_flag(flags, name, empty, dst) ({			\
> >> +	if (flags & BTRFS_INODE_##name) {				\
> >> +		if (!empty)						\
> >> +			strcat(dst, "|");				\
> >> +		strcat(dst, #name);					\
> >> +		empty = 0;						\
> >> +	}								\
> >> +})
> >
> > Can you please avoid using the macro? Or at least make it uppercase so
> > it's visible. Similar in the next patch.
> >
> >
> OK, I'll change it to upper case.

Ok.

> The only reason I'm using macro is, inline function can't do 
> stringification, or I missed something?

No, that's where macros help. My concern was about the hidden use of a
local variable, so at least an all-caps macro name would make it more
visible. As this is not going to be used elsewhere, we can live with
that.
