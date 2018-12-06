Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7520C04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 11:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 833A620661
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 11:46:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 833A620661
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbeLFLqF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 06:46:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:56710 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727832AbeLFLqF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 06:46:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 861A2AFA6;
        Thu,  6 Dec 2018 11:46:03 +0000 (UTC)
Date:   Thu, 6 Dec 2018 05:46:01 -0600
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/10] dax: export functions for use with btrfs
Message-ID: <20181206114601.bzh3356jtyvhxc6m@merlin>
References: <20181205122835.19290-1-rgoldwyn@suse.de>
 <20181205122835.19290-8-rgoldwyn@suse.de>
 <20181205145227.GA12361@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205145227.GA12361@infradead.org>
User-Agent: NeoMutt/20180323
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On  6:52 05/12, Christoph Hellwig wrote:
> If you want to export these at all they have to be EXPORT_SYMBOL_GPL.
> 

Understood.

> But I'd really like to avoid seeing another duplicate DAX I/O path.
> Please try to adopt the existing iomap-based infrastructure for your
> needs first.

This is not worth with btrfs. With non-page aligned I/O on btrfs, we
need to copy the first/last page of the extents for CoW. So, we
would end up using the exported functions anyways. Believe me, I have
spent some time getting btrfs iomap compatible before giving up. The
problems are btrfs needs to carry a lot of information across
iomap_begin and iomap_end. While the added private variable helps in
this, it also needs hooks in bio_submit() functions for crc calculations
during direct writes.

-- 
Goldwyn
