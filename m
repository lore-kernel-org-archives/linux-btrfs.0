Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:58718
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751515AbdFIH3c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Jun 2017 03:29:32 -0400
Date: Fri, 9 Jun 2017 12:58:16 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba <dsterba@suse.cz>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-convert: whats minimum free space requirement?
Message-ID: <20170609072816.GA7920@giis.co.in>
References: <20170609051914.GA3788@giis.co.in>
 <6588ee10-82fe-56aa-3079-955d97a674fd@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6588ee10-82fe-56aa-3079-955d97a674fd@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 09, 2017 at 01:35:12PM +0800, Qu Wenruo wrote:
> >ex: Like 5% of ext3/4 free space is needed for
> >btrfs-convert to succeed?
> 
> That's hard to say.
> 
> It's not only dependent on how much free space is here, but also how
> continuous the free space is.
> 
> In convert, it needs the following continuous space at least:
> 
> 1) 64K for temporary btrfs super block
> 2) 4M for system chunk
> 3) 32M for metadata chunk.
> 
> Further more, we want to keep chunks at reasonable size, that's to say we
> want each used data space on old fs is covered by a chunk >= 32M.
> 
> For worst case, if the free space in old fs is so scattered, either we can't
> find continuous for sys/meta chunk, or used data space is so scattered that
> we can't find free space after rounding up data chunks, then we can't do
> convert.
> 
> Thanks,
> Qu

Thanks for the details, Qu.

I was thinking about adding a free-space check (based on total blocks/free block
stat from source superblock) before btrfs-convert begins, looks like its more 
complex than i thought. 

Cheers.
Lakshmipathi.G
