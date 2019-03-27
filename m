Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF99C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 11:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09AD0206B8
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 11:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733043AbfC0LK1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 07:10:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:44458 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726241AbfC0LK0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 07:10:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2E0F6AEC3;
        Wed, 27 Mar 2019 11:10:25 +0000 (UTC)
Date:   Wed, 27 Mar 2019 06:10:23 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Dan Williams <dan.j.williams@gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 07/10] dax: export functions for use with btrfs
Message-ID: <20190327111023.l2nl7mcr7bumacez@merlin>
References: <20181205122835.19290-1-rgoldwyn@suse.de>
 <20181205122835.19290-8-rgoldwyn@suse.de>
 <CAA9_cmcEDc6E=zvC1m=jKXMZ7Wy+GCF91SZK5Nu5FidN6boW4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmcEDc6E=zvC1m=jKXMZ7Wy+GCF91SZK5Nu5FidN6boW4w@mail.gmail.com>
User-Agent: NeoMutt/20180323
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12:36 26/03, Dan Williams wrote:
> On Wed, Dec 5, 2018 at 4:29 AM Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> >
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> >
> > These functions are required for btrfs dax support.
> >
> > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > ---
> >  fs/dax.c            | 35 ++++++++++++++++++++++++-----------
> >  include/linux/dax.h | 16 ++++++++++++++++
> >  2 files changed, 40 insertions(+), 11 deletions(-)
> 
> Per MAINTAINERS, please copy the filesystem-dax developers on dax
> patches please.
> 

Sorry, missed in the v2 iterations. It is sent to fsdevel.
Will do it from henceforth. Thanks for reminding.

-- 
Goldwyn
