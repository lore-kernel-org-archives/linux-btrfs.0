Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DA5C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 15:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A35B220675
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 15:21:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="DcbvWmBE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbfAKPVI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 10:21:08 -0500
Received: from mail-qk1-f172.google.com ([209.85.222.172]:43660 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbfAKPVI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 10:21:08 -0500
Received: by mail-qk1-f172.google.com with SMTP id z18so6700994qkj.10
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2019 07:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=2/6ol2inuIb3c0nCcO+qg1oQ9oUW6ihPFAUnrG4yywo=;
        b=DcbvWmBEg7GWHnE3eOkIdAv0R2qsyuSLNyhHFxAS3SHZIlkX3MH/T2AUnUPIW8paiO
         vbNQdmVpQn5aktGFjZYfNbQeqZd4Z9K7iUaiIOdNVMfpCUl+RXw0Id0XqUDxnS9OEqEe
         9s8BoVxna9kpbIGm6uRylkNGrZtA0Qqnr5qzNXDUlpG6FkSMoJv5ORLGql3/3svoGQjw
         ClTor+xSUQC5PvE44I1vllYzsOI29p0+Nd0rHt4YQG5YbcdaAGwqOZ9SIDbAsgcT85Q9
         aWHoQu85E/eBW4GRdiZ7piphNPiN5uQ9VcNCjlABbSdqsqDA8r3/IVtkyNz9a8vqXLJz
         /4+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=2/6ol2inuIb3c0nCcO+qg1oQ9oUW6ihPFAUnrG4yywo=;
        b=egsNQW/FkehYLwlo/K3o/g7CgDs2vn0Vt2b7y9A0cQWoVSEA++BAJKg8/l/m05frKx
         5aG901rwrQkFls/ygyktIfbnBUbICSW9JYp9J1gddAwZXSvF+qOa7s5WK6mNpOtEPark
         TVVa5MAWy07mPOuDKJHmn8WXFiHczNIFFQ1kvyl3MQPKuemZWsZf/YxHC8C2nKZ1H/Jc
         Z4rG4leQRcCdku3x2Jn/6YsVYLbGm42ZlrSuD+B6RbZ0+hAi8lvQzWSzx63DuwGcIY1H
         80jB/0wazODbQuA+xzubqkyozCbAr5vxIzGYViM09WngzJ3AY4ll0Be0CY3yn7G8/o8W
         cKdg==
X-Gm-Message-State: AJcUukfMGHAkok80zo/8pzo7IJRs/ejZKZwl7KR+RvcYqJxeBqNF76cD
        UemCJDCz74ALjJqsoXq/6yAwKB9f+eI=
X-Google-Smtp-Source: ALg8bN7L4ZmkxKAs0uSf3c6Sv69GVNsKoQXqMENPWSFWZJXMY4oOk3UWRhS+7InftDZJq0TURGUZbQ==
X-Received: by 2002:a37:1a1c:: with SMTP id a28mr13082619qka.99.1547220066504;
        Fri, 11 Jan 2019 07:21:06 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id n72sm44090815qki.26.2019.01.11.07.21.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Jan 2019 07:21:05 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 0/3][V3] Delayed iput fixes
Date:   Fri, 11 Jan 2019 10:21:00 -0500
Message-Id: <20190111152103.17001-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v1->v2:
- only wakeup if the cleaner isn't currently doing work.
- re-arranged some stuff for running delayed iputs during flushint.
- removed the open code wakeup in the waitqueue patch.

-- Original message --

Here are some delayed iput fixes.  Delayed iputs can hold reservations for a
while and there's no real good way to make sure they were gone for good, which
means we could early enospc when in reality if we had just waited for the iput
we would have had plenty of space.  So fix this up by making us wait for delayed
iputs when deciding if we need to commit for enospc flushing, and then cleanup
and rework how we run delayed iputs to make it more straightforward to wait on
them and make sure we're all done using them.  Thanks,

Josef
