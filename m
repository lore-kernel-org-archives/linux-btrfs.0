Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C61B5C04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EEC420834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Do5cBWNL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EEC420834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbeLCPUn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:20:43 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:41835 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeLCPUn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:20:43 -0500
Received: by mail-yb1-f195.google.com with SMTP id t13-v6so5410230ybb.8
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=65kvr22rmQkWIJM7Q3OgY3lmilLwgOmqwcx6cMlfjMk=;
        b=Do5cBWNLsUh9V+gy0btQXSahku61nE41I3CgpgcTV40PgQNn1fCovxIhQeBCY/sovD
         2Wks6ob0QtmQ47+FCqhZvRnheBSgkAq44UM2dopQFkiUozDbWjXjSs5LdNg96+IhayVD
         EYut9P2v3Hk+xvP7cTKa6UF2ySzMH6kgTCYf/TaSrqBGf3B1KKbszytTcrdrP0PPlclk
         yvg7Y2L662oBQNkAn8a9RCoxJHzkY2xMwRhvV/+GyHV4URDeBpX4bh3o7VwbVBLphxYN
         irH2Qg7qzq5njcsOOOYGKUhA0VqrP4053OEBOV2ch5g51pg6OTud1M3Y4EiveEyGYE6u
         uoEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=65kvr22rmQkWIJM7Q3OgY3lmilLwgOmqwcx6cMlfjMk=;
        b=pLeFUaHHuLUHMApJKxCpLueAZkiDJaFHgYLoeQQc2kUvxFqVwCsCoRjejD3u3yKMzC
         Ma0UQzO+65/LzpJ3080Wn6B5Bwki7BB8j1njJJ4qnyJ+CQ5Y2CxrUmxyDYC/6LseFU/d
         dA64Vb9kS+CGSFoMCQzmLULZTui7GlmqJdTA7jVDC1Rq6gtQzSMVaf+X0vvnutQ9IFAZ
         fNoEUZI6mfLtQf5szjnRW6nsFRTfFlZfIND8CDrUkGUXh41nu3tCtQPA3P9CI3cjJ18O
         8lDWWDnJ6tR8ZJz3cmimzSpgwA1voFdyvSooENL41WGSA7RUssztEH9ZULN/0M6CUEmF
         LhOg==
X-Gm-Message-State: AA+aEWZK5z7xBUGwcDlSfp14W64LQFM5X3K9X7FtkJr9CW2oX7kzQg5Z
        Gw5HASxu5lXbrUV+HBDKNma4VofGgHI=
X-Google-Smtp-Source: AFSGD/XXR0sKRfEOr+hqumD8ozQ1crMiOIYZ4D85DoDDOnJFIaMb24Wvv4UgVucY5LQH71GZUxWvSA==
X-Received: by 2002:a25:73cd:: with SMTP id o196mr9259229ybc.374.1543850441012;
        Mon, 03 Dec 2018 07:20:41 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id u81sm4510331ywf.6.2018.12.03.07.20.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:20:40 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 00/10][V2] Delayed refs rsv
Date:   Mon,  3 Dec 2018 10:20:28 -0500
Message-Id: <20181203152038.21388-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v1->v2:
- addressed the comments from the various reviewers.
- split "introduce delayed_refs_rsv" into 5 patches.  The patches are the same
  together as they were, just split out more logically.  They can't really be
  bisected across in that you will likely have fun enospc failures, but they
  compile properly.  This was done to make it easier for review.

-- Original message --

This patchset changes how we do space reservations for delayed refs.  We were
hitting probably 20-40 enospc abort's per day in production while running
delayed refs at transaction commit time.  This means we ran out of space in the
global reserve and couldn't easily get more space in use_block_rsv().

The global reserve has grown to cover everything we don't reserve space
explicitly for, and we've grown a lot of weird ad-hoc hueristics to know if
we're running short on space and when it's time to force a commit.  A failure
rate of 20-40 file systems when we run hundreds of thousands of them isn't super
high, but cleaning up this code will make things less ugly and more predictible.

Thus the delayed refs rsv.  We always know how many delayed refs we have
outstanding, and although running them generates more we can use the global
reserve for that spill over, which fits better into it's desired use than a full
blown reservation.  This first approach is to simply take how many times we're
reserving space for and multiply that by 2 in order to save enough space for the
delayed refs that could be generated.  This is a niave approach and will
probably evolve, but for now it works.

With this patchset we've gone down to 2-8 failures per week.  It's not perfect,
there are some corner cases that still need to be addressed, but is
significantly better than what we had.  Thanks,

Josef
