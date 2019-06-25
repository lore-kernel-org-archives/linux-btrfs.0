Return-Path: <SRS0=RfiN=UY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA51C48BD6
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Jun 2019 19:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE7B42053B
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Jun 2019 19:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfFYTWo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Jun 2019 15:22:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:53916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726393AbfFYTWn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jun 2019 15:22:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A0132AE52;
        Tue, 25 Jun 2019 19:22:42 +0000 (UTC)
Date:   Tue, 25 Jun 2019 14:22:40 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@lst.de, david@fromorbit.com
Subject: Re: [PATCH 3/6] iomap: Check iblocksize before transforming
 page->private
Message-ID: <20190625192240.tl2pxf6te2w4tbh7@fiona>
References: <20190621192828.28900-1-rgoldwyn@suse.de>
 <20190621192828.28900-4-rgoldwyn@suse.de>
 <20190622002107.GA1611011@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190622002107.GA1611011@magnolia>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 17:21 21/06, Darrick J. Wong wrote:
> On Fri, Jun 21, 2019 at 02:28:25PM -0500, Goldwyn Rodrigues wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > btrfs uses page->private as well to store extent_buffer. Make
> > the check stricter to make sure we are using page->private for iop by
> > comparing iblocksize < PAGE_SIZE.
> > 
> > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> /me wonders what will happen when btrfs decides to support blocksize !=
> pagesize... will we have to add a pointer to struct iomap_page so that
> btrfs can continue to associate an extent_buffer with a page?
> 

Yes, I did not think about that. It would be nasty to put wrappers
to get to the right pointer.

-- 
Goldwyn
