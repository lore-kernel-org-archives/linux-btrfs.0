Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36832 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751083AbdFAOZQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Jun 2017 10:25:16 -0400
Date: Thu, 1 Jun 2017 16:24:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: switch to kvmalloc and GFP_KERNEL in lzo/zlib
 alloc_workspace
Message-ID: <20170601142414.GD12135@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1496245064.git.dsterba@suse.com>
 <5e5885e05f14e5449d48b9c512c934c241f6139f.1496245064.git.dsterba@suse.com>
 <00db6185-fc87-f4e2-4114-4f3cb43b4eb7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <00db6185-fc87-f4e2-4114-4f3cb43b4eb7@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 01, 2017 at 11:58:31AM +0800, Anand Jain wrote:
> 
> 
> > @@ -59,7 +59,7 @@ static struct list_head *zlib_alloc_workspace(void)
> >
> >  	workspacesize = max(zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL),
> >  			zlib_inflate_workspacesize());
> > -	workspace->strm.workspace = vmalloc(workspacesize);
> > +	workspace->strm.workspace = kvmalloc(workspacesize, GFP_KERNEL);
> >  	workspace->buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> 
>   Workspace->buf can be a kvmalloc as well as in lzo? or I don't know if
>   there was any purpose for not doing it for zlib.

Zlib is fine with PAGE_SIZE. Lzo needs potentially more than a page, and
kvmalloc does not fallback to vmalloc in that case:

http://elixir.free-electrons.com/linux/v4.12-rc3/source/mm/util.c#L378
