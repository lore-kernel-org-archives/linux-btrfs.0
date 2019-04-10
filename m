Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72AA5C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 19:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B46620830
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 19:56:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="opR1t9m7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbfDJT4Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 15:56:16 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:46394 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbfDJT4Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 15:56:16 -0400
Received: by mail-qt1-f174.google.com with SMTP id z17so4342832qts.13
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 12:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=BQMTvB83ZHd70wjxuNdTlIHWzDlLECGNwHho2KBHMs4=;
        b=opR1t9m7RHJJ/QpVR8AnU6R+nlrj6X07cV7BrrszT03xBrLUD2UGGhjHtjt/l5dfvb
         p5MWlbfV+o/qZYr3CKWmecnJ5OPhIm4ZQpYyJ1fe9dSWySL8I7wj8sSXdDaWeodGFXv2
         dpj/erotArLGxjMLVjhpgIVPwSzvk05RzsQOp3PMrE3LnCCxqYYJdxbV1p/MAXGXC183
         6Iy8vGzJcSMS8ioCsKc+ww7IDq2C+bqDlIorshFX2wYdTfqpO9279miMuaXmtEWMvvxG
         70VSxvY4WjnV7R4RgKGrBxKdqdpYxbPiHEukI1FxpDPuA177Nr7Pha1PHZrimlU3rfLw
         PoNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=BQMTvB83ZHd70wjxuNdTlIHWzDlLECGNwHho2KBHMs4=;
        b=Y1BLSsZDkfMst1RWAjzOIoel3q9Zo5VFFR0dhaIQwlw0VS68eBoaQmerSAPlOMrcdv
         6UaXPl9pxNK+CnEUhlCsKvzGnBoRn6xXLLRCOhXt7omqPaqF6bgdYE7AtPSETKTnFiLm
         VYL4gCCrQAwDEeh9GeQN6MyqodsByScDLwVzZpP3PotajINVbvYPN+XfMhFMqHzkN94n
         OHs8sZ1usFuzNOaVcgZQwyJj7Ijxg8onGD2j0+i5ShMaUstHfYTc+I3m/A28YXG46x/H
         36W6f5xYJIA0MQT6jul7nP6VA80X2ek4LZTxLthjsfVmOQg1+veDwZkLOqexfGqWOF5U
         S2Mw==
X-Gm-Message-State: APjAAAXRJm2DQrfqE1wAwecwl2MI+Ejt2PV5Dh0agIJPZ4kfypdyjRdl
        eWbMawTjNI+gSWPw2PvxbhTtAoA+6mgdsQ==
X-Google-Smtp-Source: APXvYqzA9MmDXnsuhYRb/bQDKWjT83UFpB7glTXjeAVL0/JUKn44yboaZs28UkI7iLVsVRZ4aiw40w==
X-Received: by 2002:a0c:b581:: with SMTP id g1mr10566995qve.97.1554926174702;
        Wed, 10 Apr 2019 12:56:14 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id e18sm4754826qki.82.2019.04.10.12.56.13
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Apr 2019 12:56:14 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] ENOSPC refinements
Date:   Wed, 10 Apr 2019 15:56:08 -0400
Message-Id: <20190410195610.84110-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.13.5
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I noticed our continuous testing for btrfs started timing out recently, and dug
down to discover that generic/224 was taking upwards of an hour to run.  This
test should take seconds to run, so this is a problem.

Fix this by reworking how we do delalloc metadata reservations, as described in
patch 2/2.

I also noticed we don't quite do the right thing when we are mostly O_DIRECT,
and addressed this in patch 1/2.  I've run these through xfstests and everything
is back to normal.  Thanks,

Josef
