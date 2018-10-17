Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA4CECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCA5A21527
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:40:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FIURFMIn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCA5A21527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbeJQQen (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 12:34:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48610 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbeJQQen (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 12:34:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9PuECpRKVqxslEjlGJqwW62aJZZyLSYeb4luzDZtiso=; b=FIURFMInnUbWJSjGalOW0KZZV
        d40ib0GU+/t7SGayg7Dohb+IcR4AAe0KTwripcn7QbEV2uc0Vg7KSJfczfeZid8Q4uF+Nn9DL8Gfz
        I8tqVu7+LEZl0uFipwpuRIsMObVr7VB6yKV3hcwMcjYoj59ZA4NjIhUM5HXNhz0Sr30RroANVYi1i
        gR8oSfoH6WGL2MuwVfRcix2HHKlWUqStvdVY32nI4+Jr7Ib0WePadz8UPGZVaPIIlVM2VRSioUvHq
        H4nWWsfpzuqXuiXI2FnjXR4DU3aXzynN4d0SDUZBJiQGyGJF5tUPIsSrwyAT1HNbiis8YqZ12sG3s
        KNFzh6P9g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gChN5-000216-Aq; Wed, 17 Oct 2018 08:40:03 +0000
Date:   Wed, 17 Oct 2018 01:40:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 25/26] xfs: support returning partial reflink results
Message-ID: <20181017084002.GI16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153966005536.3607.787445581785795364.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153966005536.3607.787445581785795364.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> @@ -1415,11 +1419,17 @@ xfs_reflink_remap_range(
>  
>  	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
>  
> +	if (len == 0) {
> +		ret = 0;
> +		goto out_unlock;
> +	}
> +

As pointed out last time this check is superflous, right above we have
this check:

	if (ret < 0 || len == 0)
		return ret;

>  	ret = xfs_reflink_remap_blocks(src, sfsbno, dest, dfsbno, fsblen,
> -			pos_out + len);
> +			&remappedfsb, pos_out + len);
> +	remapped_bytes = min_t(loff_t, len, XFS_FSB_TO_B(mp, remappedfsb));

I still think returning the bytes from the function would be saner,
but maybe that's just me.
