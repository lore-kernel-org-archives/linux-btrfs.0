Return-Path: <SRS0=E4Z9=YI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5957AC10F14
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Oct 2019 18:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 245B42086A
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Oct 2019 18:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571164551;
	bh=3xZTmm/DKQnokwIbaSO8QdPNuxVUr+KVmcXMXLWy678=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=zzXnagC1ZkSgpSjsmKEVMaoAvA01P8Bp1WRvVN1wEtWvsWKXIl5Em/nnZ3eXeHGQv
	 1+d+RpQh7oRoTs5TtrWyBjobVQg8276E2MGbLCsXQWSMxGDFmGN8nQO5X3cKQrzCeX
	 69nAZqy7N16/8UnWfOI4BXKkQ9WP746taqjF9pdE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389167AbfJOSfu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 14:35:50 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36687 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731670AbfJOSfu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Oct 2019 14:35:50 -0400
Received: by mail-qt1-f196.google.com with SMTP id o12so32071162qtf.3
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2019 11:35:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cbf9KouzCj4Rk91NTGApiuMiuM2to68kq4QUypARpwo=;
        b=g0ZCY7wsUyI6F4xawuzCpKeFROYgf402ct1ghwA5LlGCh/FX1pnbHwFmCQQVCCaQqq
         GazAMN2qgSEr1rLwFp6b7BcwGqAKzPdiqhgHbkAKr0Jw4Ql9hyZo1VNEXLNS7a0z0DDX
         25XjMdh1pY3FyMuq/b0c45td3qaMESlTeHG3BCJ/FyuhUwODV9lN3nge6aYYka34uElf
         fMnbnWS8NJNrecp1KFEYh6+L7YfJCiMF69CfPPmlfpDzf9sktRAtTnjHy1iGPV1nLouu
         iH+TJ7e9WFZb3z5pPosl+d+QFo9OsyLSMUEqgr5hv1aGcqy3SOD1k4TI2MGr5NGkszY2
         4psA==
X-Gm-Message-State: APjAAAXu9g2cCniMPD8uTRDQPaMLR/bTC+tw/DY/KY/Hb03PSdyj0ZDq
        1SRHiBxna6Jn62RR7TORZfA=
X-Google-Smtp-Source: APXvYqx/DeJgvKxF3KyXf0CtWnawI3z9984J1EzYoeejMoMwmWEilmtxSgCYjVZqeCeHHb5DV/5pfA==
X-Received: by 2002:ad4:42af:: with SMTP id e15mr38099654qvr.186.1571164549364;
        Tue, 15 Oct 2019 11:35:49 -0700 (PDT)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:500::c97c])
        by smtp.gmail.com with ESMTPSA id c16sm10456920qkg.131.2019.10.15.11.35.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 11:35:48 -0700 (PDT)
Date:   Tue, 15 Oct 2019 14:35:46 -0400
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     Dennis Zhou <dennis@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/19] bitmap: genericize percpu bitmap region iterators
Message-ID: <20191015183546.GA82683@dennisz-mbp.dhcp.thefacebook.com>
References: <cover.1570479299.git.dennis@kernel.org>
 <d2efb06e5e5400007a709bb1269b25e16b435169.1570479299.git.dennis@kernel.org>
 <20191007202612.mer74bok5ymyxae6@MacBook-Pro-91.local>
 <20191007222419.GA26876@dennisz-mbp.dhcp.thefacebook.com>
 <20191015121102.GT2751@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015121102.GT2751@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 15, 2019 at 02:11:02PM +0200, David Sterba wrote:
> On Mon, Oct 07, 2019 at 06:24:19PM -0400, Dennis Zhou wrote:
> > > > + * Bitmap region iterators.  Iterates over the bitmap between [@start, @end).
> > > 
> > > Gonna be that guy here, should be '[@start, @end]'
> > 
> > I disagree here. I'm pretty happy with [@start, @end). If btrfs wants to
> > carry their own iterators I'm happy to copy and paste them, but as far
> > as percpu goes I like [@start, @end).
> 
> It's not clear what the comment was about, if it's the notation of
> half-closed interval or request to support closed interval in the
> lookup. The orignal code has [,) and that shouldn't be changed when
> copying. Or I'm missing something.

I think there was just confusion based on the notation where '[' means
inclusive and ')' means exclusive. That got cleared up.

Thanks,
Dennis
