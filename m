Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76AC3C65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 18:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CF9420811
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 18:28:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="fnFEZm37"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CF9420811
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbeLMS24 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 13:28:56 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:40285 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbeLMS2z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 13:28:55 -0500
Received: by mail-yb1-f193.google.com with SMTP id e12so1193754ybq.7
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Dec 2018 10:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ew/8G5n87V8okF1EBjelje4vhS/HP5cqXG3h7cnzqYg=;
        b=fnFEZm37tAltePgY/eKXYWSBs789yGL4zRLZaEpBQjyy5rJNwI9N4NA+KNzv4WF5Mk
         /eeSIXalvTcWgN8SS7tkXC/ErF+TUNwWTqteO0b7yBscHF1T63WgW7UGHCPvFw1eR9JE
         cKCd7b6Pzp5ocua4RHemK3PZoLrK/4zi0vJHdELVNXE929EhWZ5MhGQNK8kbwNVnrLJG
         KCqujbp4u6yx0w+jTQ8HCmZ8HfydUAbkwm+fb6RhXzq7zPn/hVpJZbfIjl3G6FFG0jV8
         oBy1r24gkDpu3M1QWhqWsxWe4AxQdWJqWN3BLvblIRfh0eFpiNBmOeSAvyjigAowoPtN
         qDdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ew/8G5n87V8okF1EBjelje4vhS/HP5cqXG3h7cnzqYg=;
        b=Ep8acWOL3xMM98nWNlVCCK4rJrdiCN9TEgmpcmWvEplZeRuDFOa4tSx4Le1o5I9aQa
         6HEriV0BS3PliovJxNaKDywANoRizGGy2SKOYet4uIZzG+M1q+ATRCi0Bw53EDdmbW4o
         x1f8C0gEYDvNXG55+UL7nlKxQn4nKeNiBlR+gV/EnCZ/Y24bJIEiSf6x5nRGQidHGDni
         sOOxNm7mKels2HHFqySDmFNz1VacDOKsAhzeNwtwwCEBpOWioHYIlYupA4GVK04K6ei0
         itTjO6/QU0+te/LPy9cVCHI3Mh1TFtn/NbRIBFUDBXHM+jCId4fSiTTT+AUnIkuHPezX
         wanw==
X-Gm-Message-State: AA+aEWYH27Af/UKzlnY3bAu7KcxTkFMcpApsDNkRdojTMF/CJWEG6AvI
        bzAjZWrkXemAeDLixtQENyU7Gw==
X-Google-Smtp-Source: AFSGD/XhJxay4sdfO1zHa8w/Zjsk3QFZR3MR/nz6mewJb0dyaX2oaEvIVfLePICVdthS0NZ4XB55Og==
X-Received: by 2002:a25:2304:: with SMTP id j4mr25643145ybj.249.1544725734410;
        Thu, 13 Dec 2018 10:28:54 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id u28sm905115ywh.75.2018.12.13.10.28.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 10:28:53 -0800 (PST)
Date:   Thu, 13 Dec 2018 13:28:52 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     David Sterba <dsterba@suse.cz>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 0/8][V2] Enospc cleanups and fixeS
Message-ID: <20181213182850.qyyaegqzc5qijodx@MacBook-Pro-91.local>
References: <20181203152459.21630-1-josef@toxicpanda.com>
 <20181213141111.GC23615@twin.jikos.cz>
 <20181213144554.pec3brfojs53smiv@macbook-pro-91.dhcp.thefacebook.com>
 <20181213181741.GJ23615@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181213181741.GJ23615@twin.jikos.cz>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 13, 2018 at 07:17:41PM +0100, David Sterba wrote:
> On Thu, Dec 13, 2018 at 09:45:55AM -0500, Josef Bacik wrote:
> > On Thu, Dec 13, 2018 at 03:11:11PM +0100, David Sterba wrote:
> > > On Mon, Dec 03, 2018 at 10:24:51AM -0500, Josef Bacik wrote:
> > > > v1->v2:
> > > > - addressed comments from reviewers.
> > > > - fixed a bug in patch 6 that was introduced because of changes to upstream.
> > > > 
> > > > -- Original message --
> > > > 
> > > > The delayed refs rsv patches exposed a bunch of issues in our enospc
> > > > infrastructure that needed to be addressed.  These aren't really one coherent
> > > > group, but they are all around flushing and reservations.
> > > > may_commit_transaction() needed to be updated a little bit, and we needed to add
> > > > a new state to force chunk allocation if things got dicey.  Also because we can
> > > > end up needed to reserve a whole bunch of extra space for outstanding delayed
> > > > refs we needed to add the ability to only ENOSPC tickets that were too big to
> > > > satisfy, instead of failing all of the tickets.  There's also a fix in here for
> > > > one of the corner cases where we didn't quite have enough space reserved for the
> > > > delayed refs we were generating during evict().  Thanks,
> > > 
> > > One testbox reports an assertion failure on current for-next,
> > > generic/224. I'm reporting it under this patchset as it's my best guess.
> > > Same host running misc-next (with the delayed rsv patchset) was fine and
> > > the run with for-next (including this patchset) fails. The assertion is
> > > 
> > >  5225 static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
> > >  5226                                     struct btrfs_space_info *space_info,
> > >  5227                                     u64 orig_bytes,
> > >  5228                                     enum btrfs_reserve_flush_enum flush,
> > >  5229                                     bool system_chunk)
> > >  5230 {
> > >  5231         struct reserve_ticket ticket;
> > >  5232         u64 used;
> > >  5233         u64 reclaim_bytes = 0;
> > >  5234         int ret = 0;
> > >  5235
> > >  5236         ASSERT(orig_bytes);
> > >  ^^^^
> > > 
> > 
> > Looking at your for-next branch on your github (I assume this is what you are
> > testing)
> > 
> > https://github.com/kdave/btrfs-devel/blob/for-next-20181212/fs/btrfs/extent-tree.c
> > 
> > at line 5860 there's supposed to be a 
> > 
> > if (num_bytes == 0)
> > 	return 0
> > 
> > that's what I changed in v2 of this patchset, as I hit this bug as well.  It
> 
> What does 'this' refer to? The patchset in this mail thread? If yes,
> then something's wrong, because in the patch
> 
> https://patchwork.kernel.org/patch/10709827/
> 
> there's a clear ASSERT(orig_bytes) in the context of one hunk:
> 
> @@ -5210,6 +5217,7 @@  static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
>  {
>  	struct reserve_ticket ticket;
>  	u64 used;
> +	u64 reclaim_bytes = 0;
>  	int ret = 0;
>  
>  	ASSERT(orig_bytes);
> ---
> 
> > looks like you still have v1 of this patchset applied.  Thanks,
> 
> I looked up the patch series on patchwork too to double check that I haven't
> missed it in my mailboxes but no.
> 
> The assert was introduced by "Btrfs: introduce ticketed enospc infrastructure"
> which is quite old. The v2 of that patch is
> 
> https://lore.kernel.org/linux-btrfs/1463506255-15918-1-git-send-email-jbacik@fb.com/
> 
> and also has the assert and not if (orig_bytes). Confused.

I mean I hit this ASSERT() in testing, and this patch series has the fixed patch

https://patchwork.kernel.org/patch/10709829/

this is what fixes the problem that is causing the ASSERT(), it appears your
next branch doesn't have this updated patch, but the previous one which trips
that ASSERT.  Thanks,

Josef
