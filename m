Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0177BC71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC2E921470
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="M4adTLcJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC2E921470
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbeJMDHB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:01 -0400
Received: from mail-qt1-f171.google.com ([209.85.160.171]:46162 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbeJMDHA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:00 -0400
Received: by mail-qt1-f171.google.com with SMTP id d8-v6so15039097qtk.13
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=xaE6qQW6Itsw5+0UA8hoR6m5XWTXtZnUGU4IgwPLkVw=;
        b=M4adTLcJGnDl8KRY6A8i9D/b+BUetsYXSUPxg9lo+RTvUDNyKnQ2NvCdNQIe0gtGR9
         kw6HKvb5dDFQKEFlfGyOcarldNgwFGsqhnhcaCUzG4/Xm7Lop8INytxZ/kdIKCzy4J7W
         xKH6lXApU+DTkPkNY98zk3XYR/hCpmLrFWmSZ86FsdtryDZ3ge1di7cZzeU0KI4weflR
         hUctZWdgJ/pJIszuy/hbOoyMQ8whQksf4qi4gVvSaXQcFxt7dE3mlMv5Ss11We47HB0t
         YM4WKd2GqoihMD8LERl1Qv97HRNa84/XjdCnduUW1Sxf+65CneSAonjxEFJ+0YSgiAIz
         +HNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=xaE6qQW6Itsw5+0UA8hoR6m5XWTXtZnUGU4IgwPLkVw=;
        b=murutROhTFGbywWlJlvl2853YhA7BXmZh8GpQQY4OTA33jNDdmD2Wa7Cj1x3qw8C5P
         PIIa9bJHUaW7pBzzLoZ2n2lIiDBRZbPsZJuFPBgXVUH+F4FxClcMcpFTltceZVQstamz
         +KHWbAGHIILMoGQ9XokUL3xUhru+xDFuLpUSAc1ZiX7LoWRZl3gRoyx9sFyZo7Wez5Xi
         vADpJ7QSkxVqApVC95lcvMwdtAB9oGnJc6iH2S0aT7KBa2matskiiA4WjTYDP/IU1OWP
         Vf98ojdF8mAdNuwtO2UPOmSZAAcjyI+sJMWj9YIyFOEgFVNRqEHBjrxzwfwr7c0A6y2B
         66dA==
X-Gm-Message-State: ABuFfoiWDMaXxoUukcOGuaSbyT3rdKWlunsHO1ajcDT3hCZNbFzFTCY5
        UWvc3T0w/tmgz50UbXEQOilq82yjpug=
X-Google-Smtp-Source: ACcGV63uiyxkI+sLrB3l7RUWGLOP8E1EmMX5+RjgiDwYSCsRKS5qk1qWouOp16sjty8hEPBhgeN2rg==
X-Received: by 2002:aed:2166:: with SMTP id 93-v6mr7244279qtc.24.1539372779637;
        Fri, 12 Oct 2018 12:32:59 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id t22-v6sm1840326qtt.1.2018.10.12.12.32.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:32:58 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 00/42][v5] My current patch queue
Date:   Fri, 12 Oct 2018 15:32:14 -0400
Message-Id: <20181012193256.13735-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v3->v4:
- added stacktraces to all the changelogs
- added the various reviewed-by's.
- fixed the loop in inode_rsv_refill to not use goto again;

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

