Return-Path: <SRS0=XB0s=7L=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05201C433E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 May 2020 13:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0CC2206B6
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 May 2020 13:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgE2NFy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 May 2020 09:05:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:40368 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbgE2NFx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 May 2020 09:05:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 97BD3AE0F;
        Fri, 29 May 2020 13:05:51 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 33F0CDA7BD; Fri, 29 May 2020 15:05:46 +0200 (CEST)
Date:   Fri, 29 May 2020 15:05:46 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Joe Perches <joe@perches.com>
Cc:     Yi Wang <wang.yi59@zte.com.cn>, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.liang82@zte.com.cn, Liao Pingfang <liao.pingfang@zte.com.cn>
Subject: Re: [PATCH] btrfs: Replace kmalloc with kzalloc in the error message
Message-ID: <20200529130546.GR18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Joe Perches <joe@perches.com>,
        Yi Wang <wang.yi59@zte.com.cn>, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.liang82@zte.com.cn, Liao Pingfang <liao.pingfang@zte.com.cn>
References: <1590714057-15468-1-git-send-email-wang.yi59@zte.com.cn>
 <5418df56f217437bd33c4cb70098db29c177d5b3.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5418df56f217437bd33c4cb70098db29c177d5b3.camel@perches.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, May 28, 2020 at 07:03:45PM -0700, Joe Perches wrote:
> On Fri, 2020-05-29 at 09:00 +0800, Yi Wang wrote:
> > From: Liao Pingfang <liao.pingfang@zte.com.cn>
> > 
> > Use kzalloc instead of kmalloc in the error message according to
> > the previous kzalloc() call.
> []
> > diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> []
> > @@ -632,7 +632,7 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
> >  
> >  	selected_super = kzalloc(sizeof(*selected_super), GFP_NOFS);
> >  	if (NULL == selected_super) {
> > -		pr_info("btrfsic: error, kmalloc failed!\n");
> > +		pr_info("btrfsic: error, kzalloc failed!\n");
> 
> As there is a dump_stack() done on memory allocation
> failures, these messages might as well be deleted instead.

I wouldn't bother changing the strings, removing them entirely sounds
like a better idea to me.
