Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbbELPqR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 11:46:17 -0400
Date: Tue, 12 May 2015 17:46:15 +0200
From: David Sterba <dsterba@suse.cz>
To: xuw2015@gmail.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: replace PAGE_CACHE_SIZE to
 sysconf(_SC_PAGESIZE)
Message-ID: <20150512154615.GE23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1430901322-10133-1-git-send-email-xuw2015@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430901322-10133-1-git-send-email-xuw2015@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 06, 2015 at 04:35:22PM +0800, xuw2015@gmail.com wrote:
> From: George Wang <xuw2015@gmail.com>
> 
> PAGE_CACHE_SIZE is usually 4096. But for some ppc64/ppc64le, it will be 65536.
> Just replace this fixed PAGE_CACHE_SIZE to sysconf(_SC_PAGESIZE), which will
> be more flexible

As implemented in kernel right now, sectorsize must be page size and
this is also part of the compressed data format. So in restore we should
use the sectorsize from the filesystem.

Instead of passing the sectorsize through multiple functions, I suggest
to add a static global variable and set it after open_ctree.

Thanks.
