Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FEBECDE30
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7EF721529
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:36:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lAfbl8Kp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7EF721529
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbeJQQbb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 12:31:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46572 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbeJQQbb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 12:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2jGMuw/IDUHGfFXckUR8sZLJ5nbBNtVb83WOlmdGwJI=; b=lAfbl8KpFIS/6ewxmEYdhTbW7
        jYpcNhS45rz6HFj2+ahZ9VciIiAU2AVM/sPcKda4XOJiAYvqly2+EVL24g2cxqvJBDaJfKYkk0/vJ
        1xEoVRF1X1awZedeAG/UKCAe6gYAWig+gxoCH8bxvt9RvB59EQ5Zi/Dcge/B8jUTY1nbIRcZZQN+J
        XzjyMFqiayDqwpoqQIsLHejE/jhz34wA6+5ya0k8adbcCd2bMCoLONZjRutnEbRVqO4TPbh0yh0eI
        KCQ336SSEhp50FEGm/fE+uR4RwO/CiOEHLTMw83CBmEf7q0Q6+bXyxqxMIzYpWGF0LHAsiqUwuffu
        EsjnSSeXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gChK0-00017g-BZ; Wed, 17 Oct 2018 08:36:52 +0000
Date:   Wed, 17 Oct 2018 01:36:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 17/26] vfs: enable remap callers that can handle short
 operations
Message-ID: <20181017083652.GF16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153965999426.3607.3221368918901209000.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153965999426.3607.3221368918901209000.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

>  /* Update inode timestamps and remove security privileges when remapping. */
> @@ -2023,7 +2034,8 @@ loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
>  {
>  	loff_t ret;
>  
> -	WARN_ON_ONCE(remap_flags & ~(REMAP_FILE_DEDUP));
> +	WARN_ON_ONCE(remap_flags & ~(REMAP_FILE_DEDUP |
> +				     REMAP_FILE_CAN_SHORTEN));

I guess this is where you could actually use REMAP_FILE_VALID_FLAGS..

>  /* REMAP_FILE flags taken care of by the vfs. */
> -#define REMAP_FILE_ADVISORY		(0)
> +#define REMAP_FILE_ADVISORY		(REMAP_FILE_CAN_SHORTEN)

And btw, they are not 'taken care of by the VFS', they need to be
taken care of by the fs (possibly using helpers) to take affect,
but they can be safely ignored.

> +		if (!IS_ALIGNED(count, bs)) {
> +			if (remap_flags & REMAP_FILE_CAN_SHORTEN)
> +				count = ALIGN_DOWN(count, bs);
> +			else
> +				return -EINVAL;

			if (!(remap_flags & REMAP_FILE_CAN_SHORTEN))
				return -EINVAL;
			count = ALIGN_DOWN(count, bs);
