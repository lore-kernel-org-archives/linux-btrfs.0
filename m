Return-Path: <SRS0=Sb/y=M2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C893C7112A
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 17:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEAE620876
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 17:21:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZkjoG4hl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEAE620876
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbeJOBDQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 14 Oct 2018 21:03:16 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52688 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeJOBDQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Oct 2018 21:03:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zMfmuy3oCWvCBCyrsPjtL6VQOlQWRwEO22h7Ulis0OQ=; b=ZkjoG4hlaYamJ9XYWzBkk3feS
        KBuZKa05gVSXn3KxiM4mmspbbr00PwlbnXLzNqtNjeuUyJ6BIewmGv5Nsl5qkZvGY5d3OEmRvSPZk
        u9mNWC6/7Vf8pvcdQNkMXjSUlkPr/SVRVCDOdVRAlN8HkyiL/kWzfSFM9YvGtlXyrpGtdlxy5QdoC
        ylLBWu6kuaxY62FvOxf0WSuV55DEm9HhyTEIObJpOWTZ/phbSiDfhIf6dI25mQaVq5D7LTQs8Mvui
        v5IGyJbM1XNJpqTiZD5l+bpkcNn7/eZxWxhTeA++EyWjr5y+cHDxIu/tn3yOpBNPaBcIy+QD0VDyA
        V/Wu0Plvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gBk55-0005F0-Hm; Sun, 14 Oct 2018 17:21:31 +0000
Date:   Sun, 14 Oct 2018 10:21:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 10/25] vfs: create generic_remap_file_range_touch to
 update inode metadata
Message-ID: <20181014172131.GE30673@infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938921180.8361.13556945128095535605.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153938921180.8361.13556945128095535605.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> +/* Update inode timestamps and remove security privileges when remapping. */
> +int generic_remap_file_range_touch(struct file *file, bool is_dedupe)
> +{
> +	int ret;
> +
> +	/* If can't alter the file contents, we're done. */
> +	if (is_dedupe)
> +		return 0;
> +
> +	/* Update the timestamps, since we can alter file contents. */
> +	if (!(file->f_mode & FMODE_NOCMTIME)) {
> +		ret = file_update_time(file);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/*
> +	 * Clear the security bits if the process is not being run by root.
> +	 * This keeps people from modifying setuid and setgid binaries.
> +	 */
> +	return file_remove_privs(file);
> +}
> +EXPORT_SYMBOL(generic_remap_file_range_touch);

The name seems a little out of touch with what it actually does.
Also why a bool argument instead of the more descriptive flags which
introduced a few patches ago?
