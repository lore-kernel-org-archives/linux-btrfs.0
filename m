Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48733 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934104AbeFYSGg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 14:06:36 -0400
Date: Mon, 25 Jun 2018 13:06:32 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: dsterba@suse.cz, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs: Use iocb to derive pos instead of passing a
 separate parameter
Message-ID: <20180625180632.aexsmtpfksfyn3hr@merlin>
References: <20180617173947.818-1-rgoldwyn@suse.de>
 <5678d4d9-cc58-e07f-9592-07caa4deb59b@jp.fujitsu.com>
 <20180625162037.GG27958@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180625162037.GG27958@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06-25 18:20, David Sterba wrote:
> On Mon, Jun 25, 2018 at 01:58:58PM +0900, Misono Tomohiro wrote:
> > So, this is the updated version of https://patchwork.kernel.org/patch/10063039/
> > 
> > This time xfstest is ok and
> >  Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Yes, thats right.

> 
> Your comment about invalidate_mapping_pages is also ok, right? As
> filemap_fdatawait_range and invalidate_mapping_pages use the same
> start/end of the range.

I did not mess around with other functions which are affected by
iocb->ki_pos (as opposed to local pos). So, this should be safe with
respect to invalidate_mapping_pages().

-- 
Goldwyn
