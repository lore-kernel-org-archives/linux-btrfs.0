Return-Path: <SRS0=1T4y=43=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E37C10F27
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Mar 2020 16:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8248B20848
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Mar 2020 16:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgCJQa2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:30:28 -0400
Received: from verein.lst.de ([213.95.11.211]:53887 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgCJQa2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Mar 2020 12:30:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A53BC68BE1; Tue, 10 Mar 2020 17:30:25 +0100 (CET)
Date:   Tue, 10 Mar 2020 17:30:24 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/15] btrfs: fix double __endio_write_update_ordered
 in direct I/O
Message-ID: <20200310163024.GB6361@lst.de>
References: <cover.1583789410.git.osandov@fb.com> <b4b45179cc951dde98feea48723572683daf7fb3.1583789410.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4b45179cc951dde98feea48723572683daf7fb3.1583789410.git.osandov@fb.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 09, 2020 at 02:32:28PM -0700, Omar Sandoval wrote:
> +static void btrfs_submit_direct_hook(struct btrfs_dio_private *dip)

Just curious: why is this routine called btrfs_submit_direct_hook?
it doesn't seem to hook up anything, but just contains the guts of
btrfs_submit_direct.  Any reason to keep the two functions separate?

Also instead of the separate bip allocation and the bio clone, why
not clone into a private bio_set that contains the private data
as part of the allocation?
