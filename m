Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B99C6783C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 13:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72E552086A
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 13:52:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="K/Qs631e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72E552086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbeJLVZZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 17:25:25 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39996 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbeJLVZY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 17:25:24 -0400
Received: by mail-qt1-f196.google.com with SMTP id b4-v6so13856228qtc.7
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 06:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Mr/0DvOb4sa3U1zN4UmCC17Bw9k0oX0zM6/opELVYzA=;
        b=K/Qs631ekSsKJLNwqMJAcpBeWRrL2bKe6s4L4WZ+OvGmGFIwLJG+L95yW+PPam8Cd7
         +E7oHfo+lzOYgDTbxKEHoOL+yhVcL6EoLT2YjxdjImQ+iGERh1lk+V4X4oAOJT/9X+lk
         lPydBg3AVpbMwhXibdLSeZ1h9sdH2ud0hFzZwfociR8whX2LIFnJKkgeotQt3L961wqd
         xw9y+QzcMo9l0PuAcxsZzHsjfsmy4cu613hhyEQjiC6heodYYf22estuoY1Kd9RQHrdI
         e9DbRyR10c9sUT6BbTSPCc4xbjoXT60p0iNbM14z/DA9McGBN7iy2Hd3IuPpoemaxEPT
         XwZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Mr/0DvOb4sa3U1zN4UmCC17Bw9k0oX0zM6/opELVYzA=;
        b=gPzzgET2ALaxsXfpODl3lsALhjzGaLu+IEqweoScDy6m8cVAcguA8c46q5DghApiEt
         hoBg/8YbBkzSvDF3Yvf3eSyA4hKjMzO0EuWjTsuKmtSp3E3jJOo8x4OQ/u+fNEOYn0Cb
         z92F//p82X23c1rA2E1fc037n6aEgY+JspXOhqf+DyrJ5ntPYHhNfcUeutelPLAqBLvl
         M/5bREBkuIsJMJrRRVK+Bc3UDxf4tG6LogEX4/nCbDtl/YmNViuFf0fEFW9q4LNWbtu3
         IRCDdWBKFadjgY1fVTa3PsGLOcKnU6BItgzry3qBnumnqH6B462cBCIVCFnlQ9XI1r1B
         ZpgQ==
X-Gm-Message-State: ABuFfoh/05Irz59t9U00mY2RG1GPwzF7LsdB+FB/bqgF87LDBAtgrncc
        Wi7S/fYiXJCT69wKPq0dyXjvvg==
X-Google-Smtp-Source: ACcGV61KzekUgvZr8yhQlsd3oqlAIpMUENysJErEg/ZqZzrXbBeJGpd8/PeJ4z7rWAMMAvsyuAZYug==
X-Received: by 2002:ac8:2bf0:: with SMTP id n45-v6mr5904082qtn.152.1539352371343;
        Fri, 12 Oct 2018 06:52:51 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id p7-v6sm728961qkp.73.2018.10.12.06.52.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 06:52:50 -0700 (PDT)
Date:   Fri, 12 Oct 2018 09:52:49 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/4] btrfs: Introduce find_free_extent_ctl structure
 for later rework
Message-ID: <20181012135248.ll72gqjqe4yuxlxv@destiny>
References: <20181012061819.19482-1-wqu@suse.com>
 <20181012061819.19482-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012061819.19482-2-wqu@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 02:18:16PM +0800, Qu Wenruo wrote:
> Instead of tons of different local variables in find_free_extent(),
> extract them into find_free_extent_ctl structure, and add better
> explanation for them.
> 
> Some modification may looks redundant, but will later greatly simplify
> function parameter list during find_free_extent() refactor.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
