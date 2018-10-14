Return-Path: <SRS0=Sb/y=M2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FCBC7112A
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 17:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2336920876
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 17:41:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o1LtEo74"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2336920876
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbeJOBW4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 14 Oct 2018 21:22:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53226 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbeJOBWz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Oct 2018 21:22:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+fe0sT5Ek2NFvYF8DWAg/fCIGCrpshgw8PTrHtIQoCo=; b=o1LtEo74NvxsTD6TTIIIFrVZz
        xc5IOARzBadGBIS9CJvS38EzLTNht1yv1u0DKMEYD4ulAemUg8ZmSflmJ4XAaIzdSk0ye9VaUB5vc
        89DwEdU2JeBgUGdzCvrM2MhBgmS5ajmGbQGH6hs1klB7cUfqd6U9m6IjVYuiHMc2r7O5NO7Ku8hoL
        Ubtn7RRCvmBhzohAa4dt1ZAbogi0vI/EQ8DfRekrxKDL8oJYs304TjY7bEFHuhjE6YH0ajgylsDmD
        M6jN2kMkPjgfcRheRU4rkDj/LSRZepQTa0NcO2+soAhUYoGhOBkbSsPA0KJT0AQE6B1O1+UoC8Me0
        Ws46Hh2uA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gBkO4-0003Ri-Aq; Sun, 14 Oct 2018 17:41:08 +0000
Date:   Sun, 14 Oct 2018 10:41:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 22/25] ocfs2: support partial clone range and dedupe range
Message-ID: <20181014174108.GB6400@infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938929813.8361.16702022670128567518.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153938929813.8361.16702022670128567518.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> @@ -2531,14 +2531,11 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
>  				     struct file *file_out, loff_t pos_out,
>  				     loff_t len, unsigned int remap_flags)
>  {
> -	int ret;
> -
>  	if (!remap_check_flags(remap_flags, RFR_SAME_DATA))
>  		return -EINVAL;
>  
> -	ret = ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
> -					len, remap_flags);
> -	return ret < 0 ? ret : len;
> +	return ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
> +			len, remap_flags);

Seems like ocfs2_remap_file_range and ocfs2_reflink_remap_range should
be merged now.
