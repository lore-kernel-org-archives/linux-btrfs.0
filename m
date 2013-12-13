Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab3LMBRV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 20:17:21 -0500
Date: Fri, 13 Dec 2013 02:17:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-btrfs@vger.kernel.org, chandra_pdx@yahoo.com
Subject: Re: [PATCH 0/7] Patches to support subpagesize blocksize
Message-ID: <20131213011720.GW6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 11, 2013 at 05:38:35PM -0600, Chandra Seetharaman wrote:
> In other words, one cannot create a filesystem in some other architecture
> and use that filesystem in PPC64 or ARM64, and vice versa.,

For a full compatibility with any blocksize on arch with any pagesize
you'd need to implement the case when sectorsize is larger than
pagesize. Your patchset does the "4k sector/64k page", but I haven't
noticed the "64k sector/4k page" counterpart.

> Sometime last year, Wade Cline posted a patch(http://lwn.net/Articles/529682/).
> I started testing it, and found many locking/race issues. So, I changed the
> logic and created an extent_buffer_head that holds an array of extent buffers that
> belong to a page.
> 
> There are few wrinkles in this patchset, like some xfstests are failing, which
> could be due to me doing something incorrectly w.r.t how the blocksize and
> PAGE_SIZE are used in these patched.

How does it handle compression? The current code relies on

  compression block == page size

but should rather use the sectorsize. That might be one of the reasons
why xfstests fail.
