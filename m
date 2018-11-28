Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB76C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 07:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A393D2082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 07:46:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DLwund4O"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A393D2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbeK1SrK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 13:47:10 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47414 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbeK1SrK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 13:47:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NSJZSw75Mi8FTfHh59eihT5753dHfa5BRr2Fw+FLGmw=; b=DLwund4Ov5f3ThJJBDQQJC5Dyx
        /64J4EMoZ1eGtfruNZ0r2QeQ0LWTZ45Hx0V5L0rrjUumQHmUOI+beT7ufc9ow/qMNF8DGcb6GzXhb
        3KouhKFM2kdPoRW0d6pERJhLvhoRdXsJCKlmSclfCDq0b0TzLPF6ZsYQY1OQu+IsX4x6FIOr2ph6v
        9bWrjLARklMIHM+0IY81/gH/hgs07cWijZApyVy76NxrE4vnNLFxpQOXLXGehK4bG8EVjGnJZ6Drl
        YVWWrSLsfLh7CyGh6/AiM1oKK/PNr4SPkpgNqYb7vfg061rTS7Tz50X5ygF9cf9SVgZ2Hi5XxWgGa
        sKcapbAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gRuYD-0007R7-Hr; Wed, 28 Nov 2018 07:46:25 +0000
Date:   Tue, 27 Nov 2018 23:46:25 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] btrfs: drop file privileges in btrfs_clone_files
Message-ID: <20181128074625.GA27028@infradead.org>
References: <20181128030731.10288-1-lufq.fnst@cn.fujitsu.com>
 <3377ecbb-a46b-bd85-10b3-7163535a4332@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3377ecbb-a46b-bd85-10b3-7163535a4332@suse.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 09:44:59AM +0200, Nikolay Borisov wrote:
> 
> 
> On 28.11.18 г. 5:07 ч., Lu Fengqi wrote:
> > The generic/513 tell that cloning into a file did not strip security
> > privileges (suid, capabilities) like a regular write would.
> > 
> > Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> > ---
> > The xfs and ocfs2 call generic_remap_file_range_prep to drop file
> > privileges, I'm not sure whether btrfs should do the same thing.
> 
> Why do you think btrfs shouldn't do the same thing. Looking at
> remap_file_range_prep it seems that btrfs is missing a ton of checks
> that are useful i.e immutable files/aligned offsets etc.

Any chance we could move btrfs over to use remap_file_range_prep so that
all file systems share the exact same checks?
