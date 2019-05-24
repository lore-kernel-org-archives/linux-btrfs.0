Return-Path: <SRS0=C3Vb=TY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D36CC072B5
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 May 2019 09:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D678B2175B
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 May 2019 09:02:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ApcSK+t0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389730AbfEXJCN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 24 May 2019 05:02:13 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41208 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389425AbfEXJCM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 May 2019 05:02:12 -0400
Received: by mail-pf1-f196.google.com with SMTP id q17so93384pfq.8;
        Fri, 24 May 2019 02:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SbKoyQ8gCjmC4kBKgwLkfFIYV2qtRVoHIqOJrTt55sk=;
        b=ApcSK+t0qIoP2H3NLiVaHiMmnlj7iF1qaSZ1W/DVqiV6DVDj7J4BY4HygrwfuR5z6C
         tWNmk9Yeh19WMpM/5/3X1HILtUblySPIS1Sayh4nBtkoWznMtGsZZfFu0MtDOhN7c7tR
         B9cucdoTahx6YeoK73ZekPDNLjgtEKbHJL5YwR4m07lD9OyTLm1DPTLdieVs775bt9dU
         BJZX/wCHqRC90sgZ3VErztVETgtFo5OPTHH+OAppB9sibTmqRruSKlkinwJZU44f6a1e
         0zC7C10FEl5JIIFGDNJZrVXhiw5E7hS3bd1geAjfv/VpCkNL4G8lg08IAnTGyBcYNF0o
         wqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SbKoyQ8gCjmC4kBKgwLkfFIYV2qtRVoHIqOJrTt55sk=;
        b=BzmMBRcl6dBB2YGS8Aek1Xyuhx1gnqzt2P9Vikyy/dZa6QfZIdiqhBTMF2HpWTuEBO
         8vbqcnqPQW2JOp0Ot809wIzNmQOH05Et7JqXJB/yrZ8ot3upkgWrdRaoqpWHqfvQgYJt
         MwcJYrtteIS54QdB/eb0q3/p54HT59reQ9BFK8r2QiDkhgv4QOjNh0WL/Dyc8qmMxRdP
         hJEvek0TUgWpqCFvqFiRcUWtEMJYVR/pS1D1Hv88msllkgUXbOQoljvPc9OAMJ2ti5my
         XAemoJZpemgVi8InCQNmrz2tzav+ToR7o0GZcu5zDG4PalRH79F1v68iU+Caf/bMNJn2
         bZog==
X-Gm-Message-State: APjAAAW+rkXZjKF5SlGAt6y/R8niUbVSdKZgXyMXbQ12iInlaP15LcQ3
        X9fx/XD0ROlg4L37NauPiOU=
X-Google-Smtp-Source: APXvYqyQ8yGigFUDecOgbZETuEgapcupKMM4qoZWquskmBVmu+ula2IORIFx8n9iituvtUvvSH3FWw==
X-Received: by 2002:a63:b706:: with SMTP id t6mr98333287pgf.305.1558688531676;
        Fri, 24 May 2019 02:02:11 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id y17sm1841967pfn.79.2019.05.24.02.02.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 02:02:10 -0700 (PDT)
Date:   Fri, 24 May 2019 17:02:05 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2] fstests: btrfs: Validate that balance and qgroups
 work correctly when balance needs to be resumed on mount
Message-ID: <20190524090205.GN15846@desktop>
References: <20190523011101.4594-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523011101.4594-1-wqu@suse.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, May 23, 2019 at 09:11:01AM +0800, Qu Wenruo wrote:
> There are two regressions related to balance resume:
> - Kernel NULL pointer dereference at mount time
>   Introduced in v5.0
> - Kernel BUG_ON() just after mount
>   Introduced in v5.1
> 
> The kernel fixes are:
> "btrfs: qgroup: Check if @bg is NULL to avoid NULL pointer
>  dereference"
> "btrfs: reloc: Also queue orphan reloc tree for cleanup to
>  avoid BUG_ON()"
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

The summary seems a bit long, does this look like a proper summary to
describe the test?

"btrfs: resume balance on mount with qgroup"

If so, I'll use this summary on commit.

Thanks,
Eryu
