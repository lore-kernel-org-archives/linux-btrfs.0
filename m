Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8352AC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 14:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31935223DD
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 14:07:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="KW/BZ4j3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31935223DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbeKMABI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 19:01:08 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40355 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbeKMABH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 19:01:07 -0500
Received: by mail-qk1-f194.google.com with SMTP id y16so13417885qki.7
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 06:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fT1v8GMPapAUvjuBm87YwKU+UBAarnJFfjp+HdYav5Q=;
        b=KW/BZ4j32KF4nCWRq+Jj3WkaEJ5B2l6/Pj6o6s/UbLoU1NJCZgGC5mCh4NzvnS+QZg
         Re5+fYYRjq0vREmsMc/dIzw+WhxntzDPRYB1+AAuRlOvAEJND9iO4QFTx7cFYDqcO0Pg
         aooYBnpj2uYQSW5dTrqub1WtHh2XBlplkrSiRiHqh8E0Q1hrJswrc1kwEBKZklslhK83
         NP8PWzSIwkWTpf9K+DHNsC3a4GATJM+7p9OeVi1Odlji12kKzJ2i+i4bYnJ7ofriDwWN
         XT1na/nRv11b/ReMujMGsi5JkPJR7PACJE5AdtyyCZ/VjC6+VbYFauV18/KanZwmrouz
         ou5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fT1v8GMPapAUvjuBm87YwKU+UBAarnJFfjp+HdYav5Q=;
        b=fHlhmhzGjflO8mIVWffFJpiIz2yg7zt95NzY945ff4NwW9bwrnezmLCPBfNb5X8Ll7
         sGiG7N4Yf+jTzMigR9qfvrhudJnfxusFtHwR9kToXehNHWCJQhCnmL5C6vZGeIxRkxAF
         4NRHk1ZiUdWfJQ73P9ltUYUzAM5PLY2Kf4Q38m2I4Sy/qqzrnvTm/0FbVKVWd+cmP3Ju
         XgiDaReejL/mtUsQNSufuh1i3onT5o+WCKq3s48o92i6t5tPPIMigS3dxk/f5e9dIKDb
         Luutw1Xw22IGqMXOwRDmhmIZuZ2vZiH54I8OeSXzzVlmc82Nfc/3Cagleh0gIYDl5H9v
         9NZQ==
X-Gm-Message-State: AGRZ1gLsdu7YIznBGUPLNDSGenBHWswIdFIClxUI9FJRL745WWdESQ++
        f7TAh+5FUFoLcnhU/6dkL45vvw==
X-Google-Smtp-Source: AJdET5fBaQLyye30UsNz4+r5qg9HQZ/EkseKMoni3+b/23SjL2RnF/U0HbPhJ31979a1tPBb6SI6HA==
X-Received: by 2002:ad4:4391:: with SMTP id s17mr1063085qvr.32.1542031661525;
        Mon, 12 Nov 2018 06:07:41 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:d2de])
        by smtp.gmail.com with ESMTPSA id i33sm5757796qtb.97.2018.11.12.06.07.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Nov 2018 06:07:40 -0800 (PST)
Date:   Mon, 12 Nov 2018 09:07:39 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Josef Bacik <jbacik@fb.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [Regression bisected] btrfs: always wait on ordered extents at
 fsync time
Message-ID: <20181112140738.i4u6qtkytdqghepm@MacBook-Pro-91.local>
References: <20181109215148.GF23260@techsingularity.net>
 <20181109225642.GG23260@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109225642.GG23260@techsingularity.net>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 09, 2018 at 10:56:42PM +0000, Mel Gorman wrote:
> On Fri, Nov 09, 2018 at 09:51:48PM +0000, Mel Gorman wrote:
> > Unfortunately, as
> > I'm about to travel, I didn't attempt a revert and a test comparing 4.18,
> > 4.19 and 4.20-rc1 is a few hours away so this could potentially be fixed
> > already but I didn't spot any obvious Fixes commit.
> > 
> 
> Still here a few hours later but the regression still appears to exist
> in mainline and the comparison report is below.  While there are slightly
> differences, the regressions are well outside multiples of the stddev and
> co-efficient of variance so I'm fairly sure it's real. The one positive
> thing is that the actual standard deviation is lower so the results are
> more stable but that is a thin silver lining.
> 

Yeah unfortunately this was expected, though in my tests I didn't see as harsh
of a regression.  I'll start working on making the regression suck less, thanks
for running this down Mel,

Josef
