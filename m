Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32992 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750968AbdBHSRM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 13:17:12 -0500
Date: Wed, 8 Feb 2017 19:16:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Better csum error message for data csum
 mismatch
Message-ID: <20170208181608.GB16928@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170207065717.6671-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170207065717.6671-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 07, 2017 at 02:57:17PM +0800, Qu Wenruo wrote:
> The original csum error message only outputs inode number, offset, check
> sum and expected check sum.
> 
> However no root objectid is outputted, which sometimes makes debugging
> quite painful under multi-subvolume case (including relocation).
> 
> Also the checksum output is decimal, which seldom makes sense for
> users/developers and is hard to read in most time.
> 
> This patch will add root objectid, which will be %lld for rootid larger
> than LAST_FREE_OBJECTID, and hex csum output for better readability.

Ok for the change.

> +	"csum failed root %lld ino %lld off %llu csum 0x%08x expected csum 0x%08x",

> +	"csum failed root %llu ino %llu off %llu csum 0x%08x expected csum 0x%08x",

> -			   "csum failed ino %llu extent %llu csum %u wanted %u mirror %d",

so the new code does not print mirror number, I think this still makes
sense in cases where we know it. Please extend the helper and callchain
that leads to the new print functions so we see the mirror as well.

btrfs_readpage_end_io_hook
  __readpage_endio_check
    (print the csum failed message)
