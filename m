Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F42C169C4
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 20:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 508B0217F9
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 20:46:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="RTXuAmEC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfBFUqT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Feb 2019 15:46:19 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35331 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfBFUqT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2019 15:46:19 -0500
Received: by mail-qt1-f195.google.com with SMTP id v11so9556830qtc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Feb 2019 12:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=UJw9r7elGpR9pPhmGMak4yG3MUgz21XDNU4bYTx5nRA=;
        b=RTXuAmECPrgTEvbVlxkrtXWfk1BV1TMNF1twxRkJHsxmGEFwS2Di2HX1G7ygNu033Q
         rsdpkk+2yflOjXnOD2FTfcrFmm3zr+jEq5UGmhfsVIq/a4m8hPxXvqx/XrUkffMWHfea
         IPlvLRNnGqVVBlLpOjnQGrnlVJwSv5J7CLaSvmSW+GqPoSdZRBiUctVx0+oxjyB3vWn4
         qaOIpb5lNGys2Y0lG0YFNXBJz8EFCC0WVEycb/DshzlyBBkeFlj5QLcRnDSclBECYAOi
         jiujYhnaOi7cakeE4Bk+SoS+6c53kCMr+uqEs9LAXWq4P50jQEnVahKXK64+8gpm8QtL
         MTMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=UJw9r7elGpR9pPhmGMak4yG3MUgz21XDNU4bYTx5nRA=;
        b=frTXY83rM3AI9vohTseSu5i1JXZtdir06Pu7k5wDjJ3tvhmE5JZ7hXQlTqcocbL7VU
         MMxSlJtmB17vppdO0fE7Ma/H2eX1yALbrf0fbH8aPWVfCd6wuQ16JfMpEKk0Lg+VQ824
         c6S5e79Lgh+x8THDFHLF5Kcys9ZlcnNeEZKyzMfPEhAB7m8bpSxE0K0K+wJnOjde9WCN
         xAfz8PfDwpf5r05rGQ2I/9PiYSSXJaGsc6fPC8sGlnH67TacQb1bo/90xydMYlFvuI9l
         CPiYq0m8wELohXFUpt0fT03uLVhm37lKCG8+JjjL1J3Jb8y46TMkEa3sKjTEV0nOQ7ZX
         ZW+A==
X-Gm-Message-State: AHQUAuamQDN+QkmIWWBq3kjffP+QyMwd9VDFkeDydp3cUjlSjvqN4Tny
        jJEfzI145U3RUNe1KkcSLje4WBWHj7U=
X-Google-Smtp-Source: AHgI3Ia5rmUv5IdvcM+usogcX9HKJPkK1WcxJRTH26LQzULRnehw6tXKexkGdtqGhVUgP4HuYemNjg==
X-Received: by 2002:aed:34e6:: with SMTP id x93mr9448515qtd.156.1549485978083;
        Wed, 06 Feb 2019 12:46:18 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id b77sm12733924qka.5.2019.02.06.12.46.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Feb 2019 12:46:17 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 0/2] Fix missing reference aborts when resuming snapshot delete
Date:   Wed,  6 Feb 2019 15:46:13 -0500
Message-Id: <20190206204615.5862-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

With my delayed refs rsv patches in place we started hitting issues in our build
servers that do a lot of snapshot deletions.  Turns out there was a bug in
btrfs_end_transaction_throttle() that caused it to basically always commit the
transaction, which uncovered this particular bug.

The gory details are in the change logs for both patches, but generally speaking
it's a problem with how we update our root_item->drop_progress key.  We will
skip updating it some times even though we will have dropped references to
blocks.  If we crash or unmount at these times we will start at a point earlier
in our delete than we should be and try to free blocks that we already freed,
thus ending up with a transaction abort because we couldn't find the extent
reference.

There are 2 patches, 1 patch to deal with already broken file systems, and 1
patch to keep this problem from happening in the first place.

The steps to reproduce this easily are sort of tricky, I had to add a couple of
debug patches to the kernel in order to make it easy, basically I just needed to
make sure we did actually commit the transaction every time we finished a
walk_down_tree/walk_up_tree combo.

The reproducer

1) Creates a base subvolume.
2) Creates 100k files in the subvolume.
3) Snapshots the base subvolume (snap1).
4) Touches files 5000-6000 in snap1.
5) Snapshots snap1 (snap2).
6) Deletes snap1.

I do this with dm-log-writes, and then replay to every FUA in the log and fsck
the fs.  Without these patches this falls over pretty quickly.  With just the
first patch we can mount the fs at the point that the fsck fails and it cleans
everything up properly.  With both patches applied the fsck never fails and
we're golden.  Thanks,

Josef
