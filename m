Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40945C169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 18:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0489A21848
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 18:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="WvSnk2Kl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfA2SD1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 13:03:27 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33911 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbfA2SD1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 13:03:27 -0500
Received: by mail-qt1-f195.google.com with SMTP id r14so23338403qtp.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2019 10:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u/TaAiYoWbP7240IY/kYMSkBBJXbUzJwucfcesH6JKo=;
        b=WvSnk2KlMkSUmGei6M3F+RVybc1jplYSHLnHc/UapOrZOue5zdjNCKTv9CEnNNoRq8
         Uc9+WI0/IpLd+YszS44lv8eU/bgHTpSy392dcnmd6zw4lslZgXASzRPacDgkwsFIaw/o
         BwMokTqOcx0Bj7iOgm8xzRhPD+GZrtnY+dUQnxa7UHnA32u5iICUOglccSPENO6cSbNG
         /OtmnqPG752fIfxJXUAqU/tWSzCW0TFL0RrxcMktxmzco72Dcql3rmhEhu0aiifYiSls
         XYlFHdF0UNbP9zmWaOCovX3BDUqu7SwkOA4NByNoD8cB0zBdzJ8OJKtpPmt3MIZy1/Ij
         dLCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=u/TaAiYoWbP7240IY/kYMSkBBJXbUzJwucfcesH6JKo=;
        b=skaUIo1qwbi7gWJx2aLAcehVCJUIRlWZoSHlkm7wDvDgprZt6gM8uCssyvMmFjNq9E
         Z3SFzNGXCEg5IIyNrnvGrRa5+sqf6SZPpo9RwFzgnUwtWVMqYvvokYeGSHyoPB4TInDq
         Z4nRyWyoRa29r6WJVADqQgMU3kCsb1ILBa5oRlElDyX37tOGW5OAf/bAV0IkefQb7hR/
         8+p5I55sv7br6GoajwPARS/pyhUAb37DeAYRKRK+jhK2zrzHyo45h6qS42mU3lQaOAO7
         uxDqNFtOz4nMpziAvS0qQ9JZVCj4BQN8V5/SKF0vnk2ESBGCo/E40A9EWd50VqlDdoI/
         IDOw==
X-Gm-Message-State: AJcUukdMKKOAS+TyUPj2547I1i6B09tRchSrUQlzrSOjNbNum2FYdOP3
        bgyGtunIlREQ5TMbpQkd6mfn1w==
X-Google-Smtp-Source: ALg8bN48wwZmhd4I1L3oVqEUY9/BIQa2Sqn/AIs1lQf3NDh7lep844U+gvBFjseZnBxddhFda2S8jw==
X-Received: by 2002:a0c:db04:: with SMTP id d4mr25269164qvk.114.1548785006131;
        Tue, 29 Jan 2019 10:03:26 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id o65sm82805598qkl.11.2019.01.29.10.03.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 10:03:25 -0800 (PST)
Date:   Tue, 29 Jan 2019 13:03:24 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] btrfs: unify compression ops with workspace_manager
Message-ID: <20190129180323.l65oih7phhsrwe6f@MacBook-Pro-91.local>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-5-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128212437.11597-5-dennis@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 28, 2019 at 04:24:30PM -0500, Dennis Zhou wrote:
> Make the workspace_manager own the interface operations rather than
> managing index-paired arrays for the workspace_manager and compression
> operations.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
