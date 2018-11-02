Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,T_DKIMWL_WL_MED,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A69AC32789
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 087EF2082D
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="eBkpwCov"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 087EF2082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbeKCGi5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 02:38:57 -0400
Received: from mail-it1-f180.google.com ([209.85.166.180]:55870 "EHLO
        mail-it1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbeKCGi5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2018 02:38:57 -0400
Received: by mail-it1-f180.google.com with SMTP id b7-v6so5071137itd.5
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2018 14:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xGHmjJSgP2tM9i80ZZu60FKAt8QRPGm8ZUy7FYLpuRI=;
        b=eBkpwCovVRlKfni0lQAORWikqWirrT8M/ynPPwaGwlyUvy0PTCGTEE9JrrS/cWRz+j
         QzMToLGo3eCoMyzhfIfYCbCAMIvOaMny2PwSHJHW2OYCdGRWxC3IlWVdpkSM9xA0Rru6
         7jsjXsX6nysAlyAgai4gHwzVrVl9iSj5cbldouHJb+W/S1EKb8I5faWXZeu2hod2Klfi
         7Z8kVUqKVzT6EIa2kmrvGNaIzpKDAMHafthCVQ3T/69/G3+08MHnCykhhC4OmxN5sctu
         598f4uW14aeCiVgTUw+ZAu9uPvldTcJk3PPQUsDBCmTq7CQ+ryXfeV+Ark9HW7bpHvVx
         EtCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xGHmjJSgP2tM9i80ZZu60FKAt8QRPGm8ZUy7FYLpuRI=;
        b=WV5RTfZKC55P78MW/j2fvuNMqafj+KW6L/y8gaXPCCBfp5ZL5kufwq7HxWf5ANphD+
         Q0kXTOhfwOA8JuVjIos7aKpDwwy8HGoaqCTIQ5Wq59kTBQtpDsVrS5XanJAOWy4H1Sco
         nZ8R1Kn29qvwGuwt8+9idTN0JmfRJL9lSbEys0RYq+u/1XS2DDUK43t5jFdMu7tSngkx
         45loNF3MdvqUwWjOBnJl5zpVCz1FyakaOfkhm2at+qUet6yx+3R62ih/TSF4Ipu0cmtg
         7JIrcVqOTV6SGVeXOBuQZdkJTIByqWCJg26IFE+aOD4sFxs69/KEVyxsWQpybHQtfddO
         Cf4Q==
X-Gm-Message-State: AGRZ1gKJgkMC+GWZJcKISQ1MUFfA7RES6yII1gDbnGssSafgDJtW0cbm
        iN/M7hMfeVszrJeaJwDB7YX8cw==
X-Google-Smtp-Source: AJdET5evsBpTOAlQG58/2iRmxj5p8hNNcDMxLvnaWsg6m92Ps7s3q6cfIdVB+280x9Be1Xbq/KQWjw==
X-Received: by 2002:a24:f883:: with SMTP id a125-v6mr328557ith.78.1541194209432;
        Fri, 02 Nov 2018 14:30:09 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::4:e24f])
        by smtp.gmail.com with ESMTPSA id n130-v6sm929419itb.36.2018.11.02.14.30.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 14:30:08 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     fstests@vger.kernel.org
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 0/7] fstests: test Btrfs swapfile support
Date:   Fri,  2 Nov 2018 14:29:35 -0700
Message-Id: <cover.1541193856.git.osandov@fb.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

This series fixes a couple of generic swapfile tests and adds some
Btrfs-specific swapfile tests. Btrfs swapfile support is scheduled for
4.21 [1].

1: https://www.spinics.net/lists/linux-btrfs/msg83454.html

Thanks!

Omar Sandoval (7):
  generic/{472,496,497}: fix $seeqres typo
  generic/{472,496}: fix swap file creation on Btrfs
  btrfs: test swap file activation restrictions
  btrfs: test invalid operations on a swap file
  btrfs: test swap files on multiple devices
  btrfs: test device add/remove/replace with an active swap file
  btrfs: test balance and resize with an active swap file

 tests/btrfs/173     | 55 ++++++++++++++++++++++++++++++
 tests/btrfs/173.out |  5 +++
 tests/btrfs/174     | 66 ++++++++++++++++++++++++++++++++++++
 tests/btrfs/174.out | 10 ++++++
 tests/btrfs/175     | 73 ++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/175.out |  8 +++++
 tests/btrfs/176     | 82 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/176.out |  5 +++
 tests/btrfs/177     | 64 +++++++++++++++++++++++++++++++++++
 tests/btrfs/177.out |  6 ++++
 tests/btrfs/group   |  5 +++
 tests/generic/472   | 16 ++++-----
 tests/generic/496   |  8 ++---
 tests/generic/497   |  2 +-
 14 files changed, 391 insertions(+), 14 deletions(-)
 create mode 100755 tests/btrfs/173
 create mode 100644 tests/btrfs/173.out
 create mode 100755 tests/btrfs/174
 create mode 100644 tests/btrfs/174.out
 create mode 100755 tests/btrfs/175
 create mode 100644 tests/btrfs/175.out
 create mode 100755 tests/btrfs/176
 create mode 100644 tests/btrfs/176.out
 create mode 100755 tests/btrfs/177
 create mode 100644 tests/btrfs/177.out

-- 
2.19.1

