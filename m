Return-Path: <SRS0=P7ik=AL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B4FC433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jun 2020 13:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B18F20774
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jun 2020 13:59:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="2SrI5JfQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388152AbgF3N70 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 09:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbgF3N70 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jun 2020 09:59:26 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD791C061755
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2020 06:59:25 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id b185so8023015qkg.1
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2020 06:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dGlU64j+IYmpghyFKsjHAPoNaXOhNLrqJLcq9W+Savo=;
        b=2SrI5JfQuqtupKYyR3FrK7kp/XzUd8iCwy/oCvrDYelHXQ2N/hqYK/kDAWHKiIck5D
         jjYN0gS7WAx1AIM5qwAgKR+W17rfYHvFYJrmWdNlGTyb8NimPrkInZfxOPtByW6YTcpP
         LDSjxV0poQyigzwUoM55AeKtUON6b6KB6VVP9IsehGdD/PFGbUX4IIib9pFCMXpbFpEF
         jvMStlSzUztW6V4fOIFbBGWY1gKZ2IO9dOVzWq6CsZ2XcGoYuoBVhz5z2vIz1nqdghIF
         5peXOovDE5QY2mBjLTPQGY1NsET+wNfNYQx/5Hh0hrPVjlWiVS9LNszlsCi/XSAN3X3R
         hw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dGlU64j+IYmpghyFKsjHAPoNaXOhNLrqJLcq9W+Savo=;
        b=hOaI9629pG2XWmpfeV/yc+Hid4teepfI4IBRUaIb1e9jhg1frLfAbqKOUkEpzKNFwf
         yI+wJmQZvw5NTXBfZN3idBUI2xukF/boOaYpEMnGuVMVAuPwiD2vH354sn07CrPtZkke
         LBD/D9ZHl4wuZAA7vTquxF2St+flQ4dkF3h75tY+m09X8oF+4kz6RXluaKkjHm0lG9C0
         l/sH2OntFyL/VCDv0tFMLcJ7+JnvMvkZOXUa3JvANXAL7Yh6latn0FvGkiYP8Sp1WURK
         jVqFHI2kWdk+SLgTB6fhn83InYVxBTEZkuu1nYhmvmd9mEUiw6uWcBi3jVpUZ1zuKAWB
         f28Q==
X-Gm-Message-State: AOAM532jEL2pVgDAuKcpDnSreD3nei2QYJ8v7wD23ABQ4I5iw2QVUbH1
        2nkKPiHS2HGkjHvBs5Ptg64USPm/iT+4rg==
X-Google-Smtp-Source: ABdhPJxfmAxpRoiIz28IPn3ucx2qIcyR43aUGeaIt8KZKqEdEwrYzYte6KGPEkNMKpVWrxJpH4g8gQ==
X-Received: by 2002:a37:6894:: with SMTP id d142mr19866819qkc.440.1593525564600;
        Tue, 30 Jun 2020 06:59:24 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id l46sm3514651qtf.7.2020.06.30.06.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 06:59:24 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 00/23] Change data reservations to use the ticketing infra
Date:   Tue, 30 Jun 2020 09:58:58 -0400
Message-Id: <20200630135921.745612-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We've had two different things in place to reserve data and metadata space,
because generally speaking data is much simpler.  However the data reservations
still suffered from the same issues that plagued metadata reservations, you
could get multiple tasks racing in to get reservations.  This causes problems
with cases like write/delete loops where we should be able to fill up the fs,
delete everything, and go again.  You would sometimes race with a flusher that's
trying to unpin the free space, take it's reservations, and then it would fail.

Fix this by moving the data reservations under the metadata ticketing
infrastructure.  This gets rid of that problem, and simplifies our enospc code
more by consolidating it into a single path.  Thanks,

Josef

