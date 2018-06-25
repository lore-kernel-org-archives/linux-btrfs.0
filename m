Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41384 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752456AbeFYQXa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 12:23:30 -0400
Date: Mon, 25 Jun 2018 18:20:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs: Use iocb to derive pos instead of passing a
 separate parameter
Message-ID: <20180625162037.GG27958@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180617173947.818-1-rgoldwyn@suse.de>
 <5678d4d9-cc58-e07f-9592-07caa4deb59b@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5678d4d9-cc58-e07f-9592-07caa4deb59b@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2018 at 01:58:58PM +0900, Misono Tomohiro wrote:
> So, this is the updated version of https://patchwork.kernel.org/patch/10063039/
> 
> This time xfstest is ok and
>  Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Your comment about invalidate_mapping_pages is also ok, right? As
filemap_fdatawait_range and invalidate_mapping_pages use the same
start/end of the range.
