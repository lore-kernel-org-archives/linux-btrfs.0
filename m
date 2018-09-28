Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555B1C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA5B8215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="q6zB8A8U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA5B8215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbeI1Rln (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:41:43 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]:33190 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1Rln (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:41:43 -0400
Received: by mail-qt1-f180.google.com with SMTP id i10-v6so6191632qtp.0
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=RLmTfSYgvsL1ihM4N2iZ3N4baZd5pms3rbAj4ZqHuGA=;
        b=q6zB8A8UtGammkAcbOf+vzUrdheThEIzrX2g2nfmMI6Y/oypTG8fJw4Da+IjMzlwnf
         cfP6IPvxBQXGbY4oMaKLEkwftIAHL3yjWobhfuITugufeT3qc1iwK8ObtrL2Cer8ZmP6
         7KqAiLBhY5AZtSBvbETew6ZNoT66a84cxBXiO3mEhKJdJbm+JtbM+V7Bh3uJV8kHPnQj
         NSZHdVa+W8/E4HQGYMH7Ig8LZ7DAeh7/mekI4ESV0PNk2OksSdxIYmfHeIYW6x7fJpyX
         ksZPmqLzUzpIEFe1K/Cxgn/KKTaURlkAu9kc1YLUl4UnvYVu1oLS1kkIRcTXRu38+Y1S
         LgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=RLmTfSYgvsL1ihM4N2iZ3N4baZd5pms3rbAj4ZqHuGA=;
        b=rzrueZMZLbkgoxf4+TAWbhgSJ4q6WqzfDxi57zkQglsMzofxY7eRFMr8J7rZb7apfu
         BdHhqiZVKmN03WoHGGn5TVyI6XRSChYDjQUrhXfGSurJF9XGQbNFqrAOxDwlMHTDmtaS
         Y46wWxF0raVUM9ePhzn3TBjVc0U9DGU5qkIVPBDrPwxq/5AKkyngHWKIJUHIJttO00nU
         eO8uVGbQgOtjuNYl8ZnrI0y0/C9r99o/qRoFulI55+/59qQceypVYQcPow4DLn03KJ0n
         vCc9k7R4PBuPN126Oj+6zhdidwGRWnO3FIs/7DNMBeVHEfh49dm90nQd1pAmgTwq7/Z9
         BTaw==
X-Gm-Message-State: ABuFfoj+ThPO8rIEsaw+dWXdF8K+OdNe3FNI8bvk9WLWfrpy0TVkwlRV
        Hpz71g6Bt1jmwTbwCchPz8Jp2f8C1Vs=
X-Google-Smtp-Source: ACcGV63dLjOYswkhdOAZfx2ZdjbFqdpw/lejiFXlnQ9WCeyx18yLfjLEmpnCZkNIjjnpDmkLU0oOgQ==
X-Received: by 2002:a0c:ad37:: with SMTP id u52-v6mr11462259qvc.132.1538133505068;
        Fri, 28 Sep 2018 04:18:25 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id q10-v6sm2548602qtp.7.2018.09.28.04.18.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:23 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 00/42][v3] My current patch queue
Date:   Fri, 28 Sep 2018 07:17:39 -0400
Message-Id: <20180928111821.24376-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v2->v3:
- reworked the truncate/evict throttling, we were still occasionally hitting
  enospc aborts in production in these paths because we were too aggressive with
  space usage.
- reworked the delayed iput stuff to be a little less racey and less deadlocky.
- Addressed the comments from Dave and Omar.
- A lot of production testing.

v1->v2:
- addressed all of the issues brought up.
- added more comments.
- split up some patches.

original message:

This is the current queue of things that I've been working on.  The main thing
these patches are doing is separating out the delayed refs reservations from the
global reserve into their own block rsv.  We have been consistently hitting
issues in production where we abort a transaction because we run out of the
global reserve either while running delayed refs or while updating dirty block
groups.  This is because the math around global reserves is made up bullshit
magic that has been tweaked more and more throughout the years.  The result is
something that is inconsistent across the board and sometimes wrong.  So instead
we need a way to know exactly how much space we need to keep around in order to
satisfy our outstanding delayed refs and our dirty block groups.

Since we don't know how many delayed refs we need at the start of any
modification we simply use the nr_items passed into btrfs_start_transaction() as
a guess for what we may need.  This has the side effect of putting more pressure
on the ENOSPC system, but it's pressure we can deal with more intelligently
because we always know how much space we have outstanding, instead of guessing
with weird global reserve math.

This works similar to every other reservation we have, we reserve the worst case
up front, and then at transaction end time we free up any space we didn't
actually use for delayed refs.

My performance tests show that we are bit faster now since we can do more
intelligent flushing and don't have to fall back on simply committing the
transaction in hopes that we have enough space for everything we need to do.

That leads me to the 2nd part of this pull, there's a bunch of fixes around
ENOSPC.  Because we are a bit faster now there were a bunch of things uncovered
in testing, but they seem to be all resolved now.

The final chunk of fixes are around transaction aborts.  There were a lot of
accounting bugs I was running into while running generic/435, so I fixed a bunch
of those up so now it runs cleanly.

I have been running these patches through xfstests on multiple machines for a
while, they are pretty solid and ready for wider testing and review.  Thanks,

Josef
