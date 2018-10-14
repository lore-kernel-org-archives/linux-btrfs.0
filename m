Return-Path: <SRS0=Sb/y=M2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596CFC71122
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 17:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23D4620835
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 17:19:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QKfJ1AIJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23D4620835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbeJOBBM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 14 Oct 2018 21:01:12 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52606 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeJOBBM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Oct 2018 21:01:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=C7kz8JewuMJwQNG60Ca6L3Sk4/zvzKPbO94FpGpx4L8=; b=QKfJ1AIJPdJpXz1p7Ab+wf1kx
        f/aLK9MDixoehN4UmV5buNqGyuGaEM0ulnjRuxII2j6zDwWi3EOBZzCteEOuTZKnZq4+GI+IHFLti
        upn7CGlHiY2NDIjSGdlThSD8mqiEZ7IpBFf1pySae3Ch/gc60DAu18i5VhgRF7Uas+6908mGWDvaQ
        KJXPB3nMzGytviGQ0h9e46f2hdYNDfQSpK1hQP0hvzNyA0HluT3rYaskPY6/AGelUesnY9lT2HeTK
        0svKvHARQLyELQDUx1PjoaaVjfTjB/jtDRhMWP33ItD9FUbBhiBdk4sKRoLqrx2Zu99+VHPcTF8bE
        IAIm4O0SA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gBk35-0003jH-Ki; Sun, 14 Oct 2018 17:19:27 +0000
Date:   Sun, 14 Oct 2018 10:19:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 07/25] vfs: combine the clone and dedupe into a single
 remap_file_range
Message-ID: <20181014171927.GD30673@infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938919123.8361.13059492965161549195.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153938919123.8361.13059492965161549195.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

>  	unsigned (*mmap_capabilities)(struct file *);
>  #endif
>  	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *, loff_t, size_t, unsigned int);
> -	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> -	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> +	int (*remap_file_range)(struct file *file_in, loff_t pos_in,
> +				struct file *file_out, loff_t pos_out,
> +				u64 len, unsigned int remap_flags);

None of the other methods in this file name their parameters.  While
I generally don't like people leaving them out, in the end consistency
is even more important.

> +int btrfs_remap_file_range(struct file *src_file, loff_t off,
> +		struct file *dst_file, loff_t destoff, u64 len,
> +		unsigned int remap_flags)
>  {
> +	if (!remap_check_flags(remap_flags, RFR_SAME_DATA))
> +		return -EINVAL;
> +
> +	if (remap_flags & RFR_SAME_DATA) {

So at least for btrfs there seems to be no shared code at all below
the function calls.  This kinda speaks against the argument that
they fundamentally are the same..

> +/*
> + * These flags control the behavior of the remap_file_range function pointer.
> + *
> + * RFR_SAME_DATA: only remap if contents identical (i.e. deduplicate)
> + */
> +#define RFR_SAME_DATA		(1 << 0)
> +
> +#define RFR_VALID_FLAGS		(RFR_SAME_DATA)

RFR?  Why not REMAP_FILE_*  Also why not the well understood
REMAP_FILE_DEDUP instead of the odd SAME_DATA?

> +
> +/*
> + * Filesystem remapping implementations should call this helper on their
> + * remap flags to filter out flags that the implementation doesn't support.
> + *
> + * Returns true if the flags are ok, false otherwise.
> + */
> +static inline bool remap_check_flags(unsigned int remap_flags,
> +				     unsigned int supported_flags)
> +{
> +	return (remap_flags & ~(supported_flags & RFR_VALID_FLAGS)) == 0;
> +}

Any reason to even bother with a helper for this?  ->fallocate
seems to be doing fine without the helper, and the resulting code
seems a lot easier to understand to me.

> @@ -1759,10 +1779,9 @@ struct file_operations {
>  #endif
>  	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *,
>  			loff_t, size_t, unsigned int);
> -	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t,
> -			u64);
> -	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t,
> -			u64);
> +	int (*remap_file_range)(struct file *file_in, loff_t pos_in,
> +				struct file *file_out, loff_t pos_out,
> +				u64 len, unsigned int remap_flags);

Same comment here.  Didn't we have some nice doc tools to avoid this
duplication? :)
