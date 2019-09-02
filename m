Return-Path: <SRS0=+Zy3=W5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA14C3A59E
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Sep 2019 16:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F38C521744
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Sep 2019 16:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfIBQ3i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 2 Sep 2019 12:29:38 -0400
Received: from verein.lst.de ([213.95.11.211]:51506 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfIBQ3i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Sep 2019 12:29:38 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7D62768AFE; Mon,  2 Sep 2019 18:29:34 +0200 (CEST)
Date:   Mon, 2 Sep 2019 18:29:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        darrick.wong@oracle.com, hch@lst.de, david@fromorbit.com,
        riteshh@linux.ibm.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 01/15] iomap: Introduce CONFIG_FS_IOMAP_DEBUG
Message-ID: <20190902162934.GA6263@lst.de>
References: <20190901200836.14959-1-rgoldwyn@suse.de> <20190901200836.14959-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190901200836.14959-2-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Sep 01, 2019 at 03:08:22PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> To improve debugging abilities, especially invalid option
> asserts.

Looking at the code I'd much rather have unconditional WARN_ON_ONCE
statements in most places.  Including returning an error when we see
something invalid in most cases.
