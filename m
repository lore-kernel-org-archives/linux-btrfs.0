Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D23ECDE30
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC6C221527
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:28:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ccjsNwHJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC6C221527
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbeJQQWu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 12:22:50 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45834 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbeJQQWu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 12:22:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=I//trNap4/hnFzWIHZZrFzHWxQ1uDTNS9EuR32LjvRA=; b=ccjsNwHJyafEgHn50xkfsMPXv
        xwNGNcQIka5Wk882Nxc0YZt8BDQgiaRWRmADEKxBgp42ArfiqHaEHvHzaxUWzc+w+1Z91qDzf9jy2
        xJ1husrLKNV0qcmIdabTdaCOx+n7swX+aNJAEVlnkjn3YoYyerrDZ4VN1d3tEuHEiT9bZ2o+FKFke
        4lFbaulbHFo+dsLvcmQIrZ3OiY0hTIRhHjrxEULiRKXfoYD5R+KQ12rldB0PU6wAoIO/3ETbSS7NI
        6FCXLzU+FqBcFBz3WQpuXBeq7wDzeyf0Vo54CU9sCVPWslGq6d1FWDpeHJtjqNvX2e9D13W3Eepv0
        MfeMilVcA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gChBe-00068E-8P; Wed, 17 Oct 2018 08:28:14 +0000
Date:   Wed, 17 Oct 2018 01:28:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 10/26] vfs: combine the clone and dedupe into a single
 remap_file_range
Message-ID: <20181017082814.GB16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153965946503.1256.14921970220584184352.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153965946503.1256.14921970220584184352.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> +/* All valid REMAP_FILE flags */
> +#define REMAP_FILE_VALID_FLAGS		(REMAP_FILE_DEDUP)

It looks like this still isn't used after the whole series.

With it removed:

Reviewed-by: Christoph Hellwig <hch@lst.de>
