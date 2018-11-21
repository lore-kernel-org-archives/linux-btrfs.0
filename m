Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FE3C04EBA
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 14:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C7C3214C4
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 14:09:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C7C3214C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbeKVAoY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 19:44:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:38176 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726671AbeKVAoY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 19:44:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B5AB4AF93;
        Wed, 21 Nov 2018 14:09:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D70D2DA871; Wed, 21 Nov 2018 15:09:30 +0100 (CET)
Date:   Wed, 21 Nov 2018 15:09:30 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-btrfs@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: look at bi_size for repair decisions
Message-ID: <20181121140930.GN24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>,
        linux-btrfs@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org
References: <20181121135908.4720-1-hch@lst.de>
 <20181121135908.4720-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121135908.4720-3-hch@lst.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 21, 2018 at 02:59:08PM +0100, Christoph Hellwig wrote:
> bio_readpage_error currently uses bi_vcnt to decide if it is worth
> retrying an I/O.  But the vector count is mostly an implementation
> artifact - it really should figure out if there is more than a
> single sector worth retrying.  Use bi_size for that and shift by
> PAGE_SHIFT.  This really should be blocks/sectors, but given that
> btrfs doesn't support a sector size different from the PAGE_SIZE
> using the page size keeps the changes to a minimum.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: David Sterba <dsterba@suse.com>
