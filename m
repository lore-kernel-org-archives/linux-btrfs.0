Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A62C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C926D20835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="tjRXB/88"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C926D20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbeJLDXU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:20 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:37814 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbeJLDXU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:20 -0400
Received: by mail-qt1-f170.google.com with SMTP id d14-v6so11349704qto.4
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=xaE6qQW6Itsw5+0UA8hoR6m5XWTXtZnUGU4IgwPLkVw=;
        b=tjRXB/889+8odsc1fr9TCKCtdJ0wbke4Pbqxo+fAzLk6XGz6PRbaKrPDr32sREyt8M
         +Qw/8NqYmnddrVn0LhwDvb99iNERszJdkW0A8mOQ3zfBoLncmT2lfLXfnfz5IBfWp+DL
         10Iey+lJkf5U9k51jbQxTy1QcKw3uVzv38y1Yk1MUYpCIUmg92nezmHHE2Xqv+c4KEyZ
         oMwvwKzs2afNf/iIUVVwa10rG6Lef6muEn9KK5DlOXHbuU6dn/gHWkotrTUlHtYW9QF8
         9LtFdmmtsO5yv1A6ZepJadzdcP4qK6jpUuhn3JeCKhoOao9vwLEDI2U1Yv6Pypg2mnUp
         vbhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=xaE6qQW6Itsw5+0UA8hoR6m5XWTXtZnUGU4IgwPLkVw=;
        b=Pu+LESu7oCrfz1UtDXucLvJGgSHzqiFX1EaAVXDltUdYDzSS8Vb1cbZ+lOmBM5mvQ/
         XrR3ZS1O48ZxkoxsR2HyiPWICA5LlfDh0QTEgknvzea1bkAZNlHy430VdG29YHsRXHxT
         JPUUs3cyBaqb/f3GMTY0zKxDO80aLDtUfrDrPCDYZrzBkRPNFSB+CdyazS4LgHHLGMQq
         L+xQaNb568K5TTBtMAfWLwQLyRH3K/EGt9fm6DYMKTXIAnpT7Rqe4Pd3DV1ApCKviDr5
         hgfD3YHLfFme89C7KlqH9yqcGjoEiCJaiOoHgaYP96EGUAsMa2WlsACU+LfwBr7oD9ZU
         WBbg==
X-Gm-Message-State: ABuFfogIIl9WTsOw9LUqj2dAFycfyoiZDu29K6HBEzUdtQ41Ehr5FXgB
        FdXI+LAhEHdXP2Ps53PvSmqRoQ==
X-Google-Smtp-Source: ACcGV62AR9Qm54PZNHzjcWOIagpiXKJ1PL3zbWSlCox3It5hcN5BdGoZ5h89a066m/lmh7mBO5raNQ==
X-Received: by 2002:a0c:967b:: with SMTP id 56mr3090594qvy.62.1539287673646;
        Thu, 11 Oct 2018 12:54:33 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id z3-v6sm5552324qkl.23.2018.10.11.12.54.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:54:32 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 00/42][v4] My current patch queue
Date:   Thu, 11 Oct 2018 15:53:49 -0400
Message-Id: <20181011195431.3441-1-josef@toxicpanda.com>
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
