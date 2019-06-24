Return-Path: <SRS0=AU7F=UX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34C6C43613
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Jun 2019 07:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE9182089F
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Jun 2019 07:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfFXHGI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Jun 2019 03:06:08 -0400
Received: from verein.lst.de ([213.95.11.211]:52919 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbfFXHGI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jun 2019 03:06:08 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 3225B68B02; Mon, 24 Jun 2019 09:05:37 +0200 (CEST)
Date:   Mon, 24 Jun 2019 09:05:36 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@lst.de, darrick.wong@oracle.com, david@fromorbit.com,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 3/6] iomap: Check iblocksize before transforming
 page->private
Message-ID: <20190624070536.GA3675@lst.de>
References: <20190621192828.28900-1-rgoldwyn@suse.de> <20190621192828.28900-4-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621192828.28900-4-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jun 21, 2019 at 02:28:25PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> btrfs uses page->private as well to store extent_buffer. Make
> the check stricter to make sure we are using page->private for iop by
> comparing iblocksize < PAGE_SIZE.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

If btrfs uses page->private itself and also uses functions that call
to_iomap_page we have a major problem, as we now have a usage conflict.

How do you end up here?  
