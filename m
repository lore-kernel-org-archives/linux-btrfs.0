Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab3LMP6w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 10:58:52 -0500
Date: Fri, 13 Dec 2013 16:58:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/7] Patches to support subpagesize blocksize
Message-ID: <20131213155850.GZ6498@suse.cz>
Reply-To: dsterba@suse.cz
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
 <20131213011720.GW6498@twin.jikos.cz>
 <1386947820.4241.22.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1386947820.4241.22.camel@chandra-dt.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 13, 2013 at 09:17:00AM -0600, Chandra Seetharaman wrote:
> > For a full compatibility with any blocksize on arch with any pagesize
> > you'd need to implement the case when sectorsize is larger than
> > pagesize. Your patchset does the "4k sector/64k page", but I haven't
> > noticed the "64k sector/4k page" counterpart.
> 
> My object was to make btrfs filesystems from other arches to be directly
> usable in PPC64.

Ok then.

> Nevertheless, IIUC, btrfs currently support such a case. Each extent
> buffers currently can have up to INLINE_EXTENT_BUFFER_PAGES(16). 
> 
> -------
> #define INLINE_EXTENT_BUFFER_PAGES 16
> 
> struct extent_buffer {
>         :
>         :
>         struct page *pages[INLINE_EXTENT_BUFFER_PAGES];
>         :
> };
> --------
> 
> No ?

Just for metadata blocks.

> There are some issues with relocation too. Is there similar assumption
> in that code path too ?

I don't know. If yes, then it's different from the compression issues,
because there are some hardwired assumptions about the binary format of
the compressed data, while relocation uses the common code.
