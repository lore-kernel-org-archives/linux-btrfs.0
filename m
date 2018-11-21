Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD5EFC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 18:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62F9A214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 18:59:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="SDi7F7qV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62F9A214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731509AbeKVFes (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:34:48 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:40783 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731406AbeKVFer (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:34:47 -0500
Received: by mail-yb1-f195.google.com with SMTP id g9-v6so2629653ybh.7
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 10:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=QDdQ0sEngDFFWuN1haDQW0/dtnEcEBHGwxKPBsbiCHw=;
        b=SDi7F7qVe4UAN4UcmhBycUVJByotVR6rc1OYI1ETnk7oS8Fb8e3tQCAoWYe0tHxGsD
         8qIqif3DdFy4QBbQkqzK23sKVvMF7YCTtQ67n8aB5nRifx/07MVOLsOBzXiEuLks/zFD
         5dwxuSNlj+q0j6n8g4oYvN6CuKh9iarulgXGPAkW8qjl8b+kJxBRZNeojmge0hFE4xWM
         V7lq4ihL/Rcy1hmtHX+mj3ioToTN0qYAz0GHpMq5a+dbCMuVFBofwTfc3GKI01GOh4nh
         FS/5AA2aLdhgm4+zjsZ4nxcNSoUwzHVR7VOS/AzwGJIKxbgxS4GgK+jPFVxeh1Fhojwu
         boiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=QDdQ0sEngDFFWuN1haDQW0/dtnEcEBHGwxKPBsbiCHw=;
        b=qz3d6ag/mXt5aC/YwZPktSsj68y7iyPSKvGBKab9a5EFesUOntErp2t3hvhfSt6gRB
         GZ2p2u0RQ7kMcb16YFk0rxEvGalHXxjcoF46tM23p8oD0SGbhmWwMK2iVoH7JmCkP9+9
         ruD5TFrOO3LNEXN6FgjegOEyC4HO2+HwvA0XWaBaKch0qMqTnAp/toaeQ5yNKckJsObr
         Mi+x1DyyZSIE6upVIW+xdzACQWpJIjr6oe/sgu/TUJMbY3bKnuOTX5UFv6qv1Fsfu4uv
         izCOXn9gprhZadliG12Hio6XoDXHG9fdvkXtkaP/B8ZxFkD1l6jKl1DpE3wGHpHTB60o
         SMsQ==
X-Gm-Message-State: AA+aEWYi0AUz0Q3x5DvDfr3kdIGpncpYmvdpZOa9rkmwy5Bptj/jWDIR
        YjzrpVRtCvUGlb2+vmV1yNsA+2gf9/M=
X-Google-Smtp-Source: AFSGD/UR5DIxpq59HIJ+9gqfSPlrBoyDDp+UpC0lrzz//lzyD+YnyUd+ZH1SGsDdgSUzl3tgfG48Aw==
X-Received: by 2002:a25:5342:: with SMTP id h63-v6mr7346873ybb.473.1542826755666;
        Wed, 21 Nov 2018 10:59:15 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id w70sm13121406yww.76.2018.11.21.10.59.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 10:59:14 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 0/6] Delayed refs rsv
Date:   Wed, 21 Nov 2018 13:59:06 -0500
Message-Id: <20181121185912.24288-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

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
