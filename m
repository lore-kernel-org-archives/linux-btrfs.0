Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818B0C04EBA
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 14:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 566B8214DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 14:09:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 566B8214DA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbeKVAoM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 19:44:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:38112 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726671AbeKVAoM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 19:44:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 665ADAF93;
        Wed, 21 Nov 2018 14:09:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CFA80DA871; Wed, 21 Nov 2018 15:09:18 +0100 (CET)
Date:   Wed, 21 Nov 2018 15:09:18 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-btrfs@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: remove various bio_offset arguments
Message-ID: <20181121140918.GM24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>,
        linux-btrfs@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org
References: <20181121135908.4720-1-hch@lst.de>
 <20181121135908.4720-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121135908.4720-2-hch@lst.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 21, 2018 at 02:59:07PM +0100, Christoph Hellwig wrote:
> The btrfs write path passes a bio_offset argument through some deep
> callchains including async offloading.  In the end this is easily
> calculatable using page_offset plus the bvec offset for the first
> page in the bio, and only actually used by by a single function.
> Just move the calculation of the offset there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: David Sterba <dsterba@suse.com>

Ack for taking it with the bio updates.
