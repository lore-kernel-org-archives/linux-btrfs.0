Return-Path: <SRS0=UEav=BA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7649BC433E2
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51DEC20702
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:22:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="BM43V9fs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgGUOWi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 10:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGUOWi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Jul 2020 10:22:38 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317E2C061794
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2020 07:22:38 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id m9so9380604qvx.5
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2020 07:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UoA1QH/hftFnnlL16Z7w8tSlR0z1Si7hwiyNX3VQ2xg=;
        b=BM43V9fsjYlJRa7tW+MTEiCTUYVthP3xKXITNbN/qINTanOCEVe7lkZJO+gCsBI/c5
         4+ELkRbKQeX9pVAsuTiOwxHYcPqF/dI/Q7HhDvnu/Ew9tRK5FRRBqQlr+/QxPcbi4tq0
         9yxrreoeUb9HSYfEUTiww902+xaHjPEZVtrU3sl2UZpf3pAXfVZB6INxviN5N5u65V5x
         wAjVtBcLIOAdH72F7bV/dEMUm6aBe8gk416cNeFIchQGGNdISLyQgpWkoP9n7Ewasl1g
         ogFO12U1/Xt3RmW7V6Ae2yL7dMs4Enm+OQaGliIugjtMTYwst1GzkBFJf8/wH5Q/Qrn+
         LcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UoA1QH/hftFnnlL16Z7w8tSlR0z1Si7hwiyNX3VQ2xg=;
        b=MeTmxK597vvh5LpdfRt2m5oYQAGj/n78+aUvL0nrzI1rM3T8WkoJhgavKD0XtQVtKq
         zYzrHL+sFRSIrLnSOzt5zIBawX3rj4rQlsQgUm/8DFdj8wJC9X0rTarPVZDoswUlEDx3
         UYC4PsmvC8nc429eoslpyrixrnyjJdqkiRupEG5vuzoN3Q36lSVelgJnkFdWCgc725Ab
         G5drqYDljNqgDhFAcm0vjNtCdF9yEVoRnaQuC3Spid3X0idGDnvWAVsZQE2QF7Ekj2fN
         GE8moaAzBmexMp+toAEscmdxjR5gk5nNRrrt+2CuFEmWflgwzhdBrY8Zzd3FlxEe7BqT
         E3+A==
X-Gm-Message-State: AOAM532XpG76+mEuBlvQ0yaiGepQWJ43ceJCd+yYGWhC9uOGkXvvbuc4
        38uNv51dWl6xI81ccgcHmo1dACaCoBlWog==
X-Google-Smtp-Source: ABdhPJwPRYsnDQzFyhbhGR/MUuKAg1Oq/MYBPcFTAIm04FU9EfCG5qM6jV8yPfC8epPaxwCvfjzglw==
X-Received: by 2002:a05:6214:289:: with SMTP id l9mr27011948qvv.238.1595341356741;
        Tue, 21 Jul 2020 07:22:36 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id a28sm2413910qko.45.2020.07.21.07.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 07:22:36 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 00/23][v4] Change data reservations to use the ticketing infra
Date:   Tue, 21 Jul 2020 10:22:11 -0400
Message-Id: <20200721142234.2680-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v3->v4:
- Rebased onto a recent misc-next, slight fixup because of commenting around the
  flush states.

v2->v3:
- Rebased onto a recent misc-next

v1->v2:
- Adjusted a comment in may_commit_transaction.
- Fixed one of the intermediate patches to properly update ->reclaim_size.

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

