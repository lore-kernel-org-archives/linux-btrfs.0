Return-Path: <SRS0=+Zy3=W5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEBE7C3A59E
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Sep 2019 16:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCB5421744
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Sep 2019 16:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfIBQnf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 2 Sep 2019 12:43:35 -0400
Received: from verein.lst.de ([213.95.11.211]:51602 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfIBQnf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Sep 2019 12:43:35 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8EAE868AFE; Mon,  2 Sep 2019 18:43:31 +0200 (CEST)
Date:   Mon, 2 Sep 2019 18:43:31 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        darrick.wong@oracle.com, hch@lst.de, david@fromorbit.com,
        riteshh@linux.ibm.com
Subject: Re: [PATCH v3 0/15] Btrfs iomap
Message-ID: <20190902164331.GE6263@lst.de>
References: <20190901200836.14959-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190901200836.14959-1-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Sep 01, 2019 at 03:08:21PM -0500, Goldwyn Rodrigues wrote:
> This is an effort to use iomap for btrfs. This would keep most
> responsibility of page handling during writes in iomap code, hence
> code reduction. For CoW support, changes are needed in iomap code
> to make sure we perform a copy before the write.
> This is in line with the discussion we had during adding dax support in
> btrfs.

This looks pretty good modulo a few comments.

Can you please convert the XFS code to use your two iomaps for COW
approach as well to validate it?

Also the iomap_file_dirty helper would really benefit from using the
two iomaps, any chance you could look into improving it to use your
new infrastructure?
