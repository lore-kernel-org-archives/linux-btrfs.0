Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940A0C5ACCC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 04:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59F8621476
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 04:54:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59F8621476
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ZenIV.linux.org.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbeJRMxm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 08:53:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42178 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbeJRMxm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 08:53:42 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gD0KL-0007g0-JT; Thu, 18 Oct 2018 04:54:29 +0000
Date:   Thu, 18 Oct 2018 05:54:29 +0100
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 09/29] vfs: combine the clone and dedupe into a single
 remap_file_range
Message-ID: <20181018045429.GF32577@ZenIV.linux.org.uk>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
 <153981631706.5568.6473120432728396978.stgit@magnolia>
 <20181018004826.GB12386@ZenIV.linux.org.uk>
 <20181018044718.GT28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018044718.GT28243@magnolia>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 17, 2018 at 09:47:18PM -0700, Darrick J. Wong wrote:

> > > +#define REMAP_FILE_DEDUP		(1 << 0)
> > > +
> > > +/*
> > > + * These flags should be taken care of by the implementation (possibly using
> > > + * vfs helpers) but can be ignored by the implementation.
> > > + */
> > > +#define REMAP_FILE_ADVISORY		(0)
> > 
> > ???
> 
> Sorry if this wasn't clear.  How about this?
> 
> /*
>  * These flags signal that the caller is ok with altering various aspects of
>  * the behavior of the remap operation.  The changes must be made by the
>  * implementation; the vfs remap helper functions can take advantage of them.
>  * Flags in this category exist to preserve the quirky behavior of the hoisted
>  * btrfs clone/dedupe ioctls.
>  */

Something like "currently we have no such flags, but some will appear
in subsequent commits", removed once such flags do appear, perhaps?
