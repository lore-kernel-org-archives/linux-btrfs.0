Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BEB7C04EB8
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 17:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F233D20834
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 17:19:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="DKgOGq4z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F233D20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbeLAE3Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Nov 2018 23:29:16 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:39118 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbeLAE3Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Nov 2018 23:29:16 -0500
Received: by mail-yw1-f68.google.com with SMTP id j6so2565292ywj.6
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 09:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OleK8vP2G4+fJMCJqed76XwNsWVaSd4DvZwnB6IJnF8=;
        b=DKgOGq4zuzup/8OEnuLEITnj0SlLszgTQElYovgQ686vOiOD987faNU5Sp4z3uQURq
         nYxcHk0BCOBUwVwM4MMys3sbz1b+OJ5WI82eic+kbPzE4ZB6hFQP+Rk+xx44nUGP974I
         J9hcpiFpcfflY5MxvDZkvJQfjce+eJkCgVhUnRh+I71YUoc5zi+fCnzvMFxTCLuP1247
         12Cj5kSAeM1MeoUaabicfRsMOgA7YsH5LKwXh/xfXsPdOdsImzKQJ9ybdLCfngnZpaeG
         ugVxfV9Q6Dauyf8JgGb9tSqVDHFMnsoTEQV/2tk+nfs+Ff9rxuXnptiJ49JB/ly1qFV7
         Pxuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OleK8vP2G4+fJMCJqed76XwNsWVaSd4DvZwnB6IJnF8=;
        b=PRwmczm+IJY8kTmRx0Qm7PZ/mSJLoWhVJtx7TWugsPOOlh+DUF8hCjtt8KpBIm/NNh
         BqDTAgNVNy9Gt1IcUaZ0exWGX9ApxyfOx2Ao5jTKxJSDyyShs7Z1/kEj3jUJ4IL+onEn
         h8MCc88RABw0w6UBpk04dQCerizWpXQ1MHx01hrhaZs1sl0Pv1iFSCV0ll2CO8qS+tky
         tH8+XKNDYHTMTvGKxDlqEfCPFc0QKNzuaSS5tkBouDCDSjWYrt3m1olT7AklxEj/cak8
         tmVM8CkgkO8yQvWGvJB1BIsjwPFZftfA+c1DHGNLCI6fKOonbcy44VGV87+m+u10tDsi
         9obw==
X-Gm-Message-State: AA+aEWbJGVZPMOTLBiJBoz1XoS9Hc0RdMu80tbCQe8cvLo1TV9V4SjLc
        WKEG0cG66lFEgugDiq3BnLksjw==
X-Google-Smtp-Source: AFSGD/W+4Bi+L91gArbtgwvBxRMjC8k8pvsT1B2pFeiyxXHCuIsIWwvLUImrGLRaCm1EWW4u/43lug==
X-Received: by 2002:a81:c709:: with SMTP id m9mr6171718ywi.322.1543598356431;
        Fri, 30 Nov 2018 09:19:16 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:4c4c])
        by smtp.gmail.com with ESMTPSA id x4sm8603799ywj.80.2018.11.30.09.19.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Nov 2018 09:19:15 -0800 (PST)
Date:   Fri, 30 Nov 2018 12:19:18 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 1/2] btrfs: catch cow on deleting snapshots
Message-ID: <20181130171917.oce3tpl6kjsujpia@macbook-pro-91.local.dhcp.thefacebook.com>
References: <20181130165214.17883-1-josef@toxicpanda.com>
 <20181130165214.17883-2-josef@toxicpanda.com>
 <CAL3q7H6o=TiqyiQ9Ljy8=4Gc9+-ww-S1ATc-MNq=8k3F_BsLzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H6o=TiqyiQ9Ljy8=4Gc9+-ww-S1ATc-MNq=8k3F_BsLzQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 30, 2018 at 05:14:54PM +0000, Filipe Manana wrote:
> On Fri, Nov 30, 2018 at 4:53 PM Josef Bacik <josef@toxicpanda.com> wrote:
> >
> > From: Josef Bacik <jbacik@fb.com>
> >
> > When debugging some weird extent reference bug I suspected that we were
> > changing a snapshot while we were deleting it, which could explain my
> > bug.  This was indeed what was happening, and this patch helped me
> > verify my theory.  It is never correct to modify the snapshot once it's
> > being deleted, so mark the root when we are deleting it and make sure we
> > complain about it when it happens.
> >
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/btrfs/ctree.c       | 3 +++
> >  fs/btrfs/ctree.h       | 1 +
> >  fs/btrfs/extent-tree.c | 9 +++++++++
> >  3 files changed, 13 insertions(+)
> >
> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > index 5912a97b07a6..5f82f86085e8 100644
> > --- a/fs/btrfs/ctree.c
> > +++ b/fs/btrfs/ctree.c
> > @@ -1440,6 +1440,9 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
> >         u64 search_start;
> >         int ret;
> >
> > +       if (test_bit(BTRFS_ROOT_DELETING, &root->state))
> > +               WARN(1, KERN_CRIT "cow'ing blocks on a fs root thats being dropped\n");
> 
> Please use btrfs_warn(), it makes sure we use a consistent message
> style, identifies the fs, etc.
> Also, "thats" should be "that is" or "that's".
> 

Ah yeah, I was following the other convention in there but we should probably
convert all of those to btrfs_warn.  I'll fix the grammer thing as well, just a
leftover from the much less code of conduct friendly message I originally had
there.  Thanks,

Josef
