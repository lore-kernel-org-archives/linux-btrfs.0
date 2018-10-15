Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4855C04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 13:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 618E02089D
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 13:18:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sT0AiCvp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 618E02089D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbeJOVDW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 17:03:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55102 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbeJOVDW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 17:03:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=noO556np7PLnC0EbG0kfLb06OsVy6hTfjFnpj6rnwII=; b=sT0AiCvpDwYymXZlSiGXH2+V7
        tglPSTP2qwQ/xVzBSs/bq1NFKTqstnyZ5aCv86KmnzleI/CdH+ubaFyPvmxp1hVg3o1LE70jlIu8i
        /OKqqsSqKnb2ipff994QQfkSLRU6lErPgrbSi9LWEQXNMLI7mo6UMYTWnE45b3+HUEzlygUHj2j0v
        mso495Fb1qk/2UmGO0wspT7kGE64m+cfo1h170Pp5AZ2rzj9DNt+nbyRppRJThU6OIywxVN2SyPbQ
        bCl2HGdzZ+88xXX1Lf/GfegqyzBVUfQsJVxrYjp1rCyVKdCgmJfuS9RBGzoACbaD0op7gnjTH8NUx
        iqh7toVxQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gC2l1-00060V-Ko; Mon, 15 Oct 2018 13:18:03 +0000
Date:   Mon, 15 Oct 2018 06:18:03 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com,
        sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 07/25] vfs: combine the clone and dedupe into a single
 remap_file_range
Message-ID: <20181015131803.GA9845@bombadil.infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938919123.8361.13059492965161549195.stgit@magnolia>
 <20181014171927.GD30673@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181014171927.GD30673@infradead.org>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Oct 14, 2018 at 10:19:27AM -0700, Christoph Hellwig wrote:
> >  	unsigned (*mmap_capabilities)(struct file *);
> >  #endif
> >  	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *, loff_t, size_t, unsigned int);
> > -	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> > -	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
> > +	int (*remap_file_range)(struct file *file_in, loff_t pos_in,
> > +				struct file *file_out, loff_t pos_out,
> > +				u64 len, unsigned int remap_flags);
> 
> None of the other methods in this file name their parameters.  While
> I generally don't like people leaving them out, in the end consistency
> is even more important.

I would agree with you *except* that the parameters do not follow memcpy()
traditional order (dst, src, len).  Instead they are (src, dst, len), so we
should probably name them to advise the poor sod who has to implement this
that we've chosen an inconsistent API.

Or we could fix it.

