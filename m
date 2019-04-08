Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBCFC282CE
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 14:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C63BE21473
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 14:12:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lQ6CNCTE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfDHOMH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 10:12:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47054 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfDHOMH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2019 10:12:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7dfpLLa9vadqziNX/bgzSvol5DyHPXnb83w0Lmmk6cU=; b=lQ6CNCTEtXCNZNmkN0+cmlyaI
        YdGGybxyscXvvQCP0kTjkZxEMcr23ebsD12+NPtOP1KYOiREQceJMOB7MrA8Tj6RSUQS1W6j0wtpj
        uT9WGU5hbKrH5arv44jEkLB284XfKkYZYtfAldQDsFWvrBp9sq1BedA27xDQxf979Q1WM324/l+LA
        224ReI+B8R2VyCHiEr3/DdsHmU3ybimiZ8etNQ9Frka4Jlb+rRuz4CqARlmPIoslt8CV9ecURPi9l
        B0utxh65ApPJ31z3cq3GbFfZdRM7DMwVh+/53EhjzCEdXIdenyMPqOkWqErv2Mw34C2opJ2rbLpqN
        e4fVu0EZQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hDV0G-0002zL-7N; Mon, 08 Apr 2019 14:12:04 +0000
Date:   Mon, 8 Apr 2019 07:12:04 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH] block: don't use for-inside-for in
 bio_for_each_segment_all
Message-ID: <20190408141203.GT22763@bombadil.infradead.org>
References: <20190406215428.3131-1-ming.lei@redhat.com>
 <20190407065205.GA8799@lst.de>
 <f0c82caf-24f3-dba7-0bf0-85dd0e056e73@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0c82caf-24f3-dba7-0bf0-85dd0e056e73@suse.de>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 08, 2019 at 08:07:55AM +0200, Hannes Reinecke wrote:
> Oh yes, please do.
> The macros are fast becoming unparseable :-)

I think something that would help is removing the mandatory 'i' parameter
to this iterator.  Most of the users don't use it, and the ones that do
can implement it themselves.  eg:


                int j;
                struct bio_vec *bv;
                void *base = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
                struct bvec_iter_all iter_all;

                bio_for_each_segment_all(bv, b->bio, j, iter_all)
                        memcpy(page_address(bv->bv_page),
                               base + j * PAGE_SIZE, PAGE_SIZE);

could become

                struct bio_vec *bv;
                void *addr = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
                struct bvec_iter_all iter_all;

                bio_for_each_segment_all(bv, b->bio, iter_all) {
                        memcpy(page_address(bv->bv_page), addr, PAGE_SIZE);
			addr += PAGE_SIZE;
		}

eg2:

                bio_for_each_segment_all(bi, sbio, j, iter_all)
                        page_len[j] = bi->bv_len;

could become:
                bio_for_each_segment_all(bi, sbio, iter_all)
                        page_len[j++] = bi->bv_len;

