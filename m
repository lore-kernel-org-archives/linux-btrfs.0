Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:38897 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3LMPRG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 10:17:06 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <sekharan@us.ibm.com>;
	Fri, 13 Dec 2013 08:17:06 -0700
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id CCC9B1FF001A
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 08:16:39 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08027.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rBDFH2oQ33816594
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 16:17:03 +0100
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rBDFH29O012665
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 08:17:02 -0700
Subject: Re: [PATCH 0/7] Patches to support subpagesize blocksize
From: Chandra Seetharaman <sekharan@us.ibm.com>
Reply-To: sekharan@us.ibm.com
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
In-Reply-To: <20131213011720.GW6498@twin.jikos.cz>
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
	 <20131213011720.GW6498@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Dec 2013 09:17:00 -0600
Message-ID: <1386947820.4241.22.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2013-12-13 at 02:17 +0100, David Sterba wrote:

Hi David,

> On Wed, Dec 11, 2013 at 05:38:35PM -0600, Chandra Seetharaman wrote:
> > In other words, one cannot create a filesystem in some other architecture
> > and use that filesystem in PPC64 or ARM64, and vice versa.,
> 
> For a full compatibility with any blocksize on arch with any pagesize
> you'd need to implement the case when sectorsize is larger than
> pagesize. Your patchset does the "4k sector/64k page", but I haven't
> noticed the "64k sector/4k page" counterpart.

My object was to make btrfs filesystems from other arches to be directly
usable in PPC64.

Nevertheless, IIUC, btrfs currently support such a case. Each extent
buffers currently can have up to INLINE_EXTENT_BUFFER_PAGES(16). 

-------
#define INLINE_EXTENT_BUFFER_PAGES 16

struct extent_buffer {
        :
        :
        struct page *pages[INLINE_EXTENT_BUFFER_PAGES];
        :
};
--------

No ?

> 
> > Sometime last year, Wade Cline posted a patch(http://lwn.net/Articles/529682/).
> > I started testing it, and found many locking/race issues. So, I changed the
> > logic and created an extent_buffer_head that holds an array of extent buffers that
> > belong to a page.
> > 
> > There are few wrinkles in this patchset, like some xfstests are failing, which
> > could be due to me doing something incorrectly w.r.t how the blocksize and
> > PAGE_SIZE are used in these patched.
> 
> How does it handle compression? The current code relies on
> 
>   compression block == page size
> 
> but should rather use the sectorsize. That might be one of the reasons
> why xfstests fail.

Thanks for this information. I will look at the code more closely with
this in mind.

There are some issues with relocation too. Is there similar assumption
in that code path too ?

> 


