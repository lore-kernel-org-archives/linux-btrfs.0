Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52281 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752115AbeEOOJn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 10:09:43 -0400
Date: Tue, 15 May 2018 16:07:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: property: Set incompat flag of lzo/zstd
 compression
Message-ID: <20180515140703.GS6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1526370458.git.misono.tomohiro@jp.fujitsu.com>
 <35713081-318c-8bca-22bc-8b9c4894c0d8@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <35713081-318c-8bca-22bc-8b9c4894c0d8@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 15, 2018 at 04:51:26PM +0900, Misono Tomohiro wrote:
> Incompat flag of lzo/zstd compression should be set at:
>  1. mount time (-o compress/compress-force)
>  2. when defrag is done
>  3. when property is set
> 
> Currently 3. is missing and this commit adds this.

That was missed during the review, thanks for catching it.

> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>

For 4.17-rc and for stable 4.14+.
