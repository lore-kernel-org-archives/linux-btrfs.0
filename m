Return-Path: <SRS0=+Zy3=W5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F7B8C3A59E
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Sep 2019 16:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A35021744
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Sep 2019 16:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfIBQbI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 2 Sep 2019 12:31:08 -0400
Received: from verein.lst.de ([213.95.11.211]:51518 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfIBQbI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Sep 2019 12:31:08 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7DF9C68AFE; Mon,  2 Sep 2019 18:31:04 +0200 (CEST)
Date:   Mon, 2 Sep 2019 18:31:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        darrick.wong@oracle.com, hch@lst.de, david@fromorbit.com,
        riteshh@linux.ibm.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 02/15] iomap: Use a IOMAP_COW/srcmap for a
 read-modify-write I/O
Message-ID: <20190902163104.GB6263@lst.de>
References: <20190901200836.14959-1-rgoldwyn@suse.de> <20190901200836.14959-3-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190901200836.14959-3-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Sep 01, 2019 at 03:08:23PM -0500, Goldwyn Rodrigues wrote:
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -37,6 +37,7 @@ struct vm_fault;
>  #define IOMAP_MAPPED	0x03	/* blocks allocated at @addr */
>  #define IOMAP_UNWRITTEN	0x04	/* blocks allocated at @addr in unwritten state */
>  #define IOMAP_INLINE	0x05	/* data inline in the inode */
> +#define IOMAP_COW	0x06	/* copy data from srcmap before writing */

I don't think IOMAP_COW can be a type - it is a flag given that we
can do COW operations that allocate normal written extents (e.g. for
direct I/O or DAX) and for delayed allocations.

