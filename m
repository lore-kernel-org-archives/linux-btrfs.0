Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7511DC677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B8002054F
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:34:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="MjNfdmU1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B8002054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbeJLCCX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 22:02:23 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38008 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728229AbeJLCCX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 22:02:23 -0400
Received: by mail-qk1-f194.google.com with SMTP id 204-v6so6103987qkd.5
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 11:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0z6jvyw6BUb80rGpWEeO1OK9RmhuhGj/3aIEwPTLHTQ=;
        b=MjNfdmU1oXExRJGOBWtWlwAweJgKy88m/FrLnhz+dUEQuRQGVZYmkSX3wLOix0/Ki6
         q/Hs/gTXB4hdcsQX38KYZTBo0nQnW79DEiZAo/gsXRWUJoDS9mfcAkxt9TEiIalFWWll
         sBU54OCx1e/UNHu6eiBY9NcoJyhuFoQibHYyI8PazExtUDvcwjPlS0JALhP6F1TmGYvd
         4hZbNB9w+ayL33ATXoWIXKAsl0AIR5Oqs1MHTDp2kNbPJh9XnYl238NMPxfPSItAl33C
         GfkznkZbA/9Qv0u3u7n6pNhEmzhsxMqDI2J1ECaoF+FVXz3uRnJLmYXFuKENpNgg6zIu
         1WeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0z6jvyw6BUb80rGpWEeO1OK9RmhuhGj/3aIEwPTLHTQ=;
        b=pjtiS1aP1D+7KFG9L8q/Xj4S4ir3sgK3p9vF4D4STz203lLDgaN0jrIkD1yKniyxd5
         OEKgzcYI0+UWMVBeSn06kpEQyDcniTKH3VebzB/Q5zfbXRZgECYsvbHC0SknCc12QP7q
         +C/bWzK7IAhEB7nvyz4PluJ0qlhN+aIhQs6GrNzqRQhpMappPDKtj4G2ESFjuYJgZKLV
         Cacf5Rb4mWuhy3oaW4FtTWHzC+Jo1IyiVGuVqd+WJFY3xCcyLtIm+dCs/XUM8AZESMX+
         KgXfQybsaxwnPFqREgeyK7Yj1LimEZQbvc3ZG9SjWoO1BExV0wQFAaCJEPDR8s7Hdncr
         E4CA==
X-Gm-Message-State: ABuFfoglKd1W0wD0jMtr3zP9/+BWDZ/PfOGyAzXtr270V3VxLXRPPveP
        R4+S8DWd5ZsLjsQGBk1g9PpRBg==
X-Google-Smtp-Source: ACcGV60Z6smjxTqaHJnsZuIvnpt4V6Arf6RUKmb56PEWdBh4KhwIRK8ktAPChkjvovoF8KIC3LSJkA==
X-Received: by 2002:a37:cb8a:: with SMTP id u10-v6mr2816648qkl.324.1539282837511;
        Thu, 11 Oct 2018 11:33:57 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id p3-v6sm11690839qtp.55.2018.10.11.11.33.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 11:33:56 -0700 (PDT)
Date:   Thu, 11 Oct 2018 14:33:55 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/42] btrfs: check if free bgs for commit
Message-ID: <20181011183354.mxcpedy4dmbirgri@destiny>
References: <20180928111821.24376-1-josef@toxicpanda.com>
 <20180928111821.24376-8-josef@toxicpanda.com>
 <20181004112424.GC29418@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181004112424.GC29418@twin.jikos.cz>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 01:24:24PM +0200, David Sterba wrote:
> On Fri, Sep 28, 2018 at 07:17:46AM -0400, Josef Bacik wrote:
> > may_commit_transaction will skip committing the transaction if we don't
> > have enough pinned space or if we're trying to find space for a SYSTEM
> > chunk.  However if we have pending free block groups in this transaction
> > we still want to commit as we may be able to allocate a chunk to make
> > our reservation.  So instead of just returning ENOSPC, check if we have
> > free block groups pending, and if so commit the transaction to allow us
> > to use that free space.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > Reviewed-by: Omar Sandoval <osandov@fb.com>
> > ---
> >  fs/btrfs/extent-tree.c | 33 +++++++++++++++++++--------------
> >  1 file changed, 19 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 1213f573eea2..da73b3e5bc39 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -4830,10 +4830,18 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
> >  	if (!bytes)
> >  		return 0;
> >  
> > -	/* See if there is enough pinned space to make this reservation */
> > -	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
> > -				   bytes,
> > -				   BTRFS_TOTAL_BYTES_PINNED_BATCH) >= 0)
> > +	trans = btrfs_join_transaction(fs_info->extent_root);
> > +	if (IS_ERR(trans))
> > +		return -ENOSPC;
> 
> Why do you set override the error to ENOSPC, instead of passing
> PTR_ERR(trans)? There are more reasons why btrfs_join_transaction could
> fail: EROFS after error, EDQUOT when quotas say no, ENOMEM from
> ulist_add, that's just a sample I quickly found.

(argh I hit r instead of g, sending again)

Because may_commit_transaction is only called during flushing, we don't actually
care about the value, just that it failed.  Thanks,

Josef
