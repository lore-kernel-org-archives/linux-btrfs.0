Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07ABCC04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 16:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCDEA20834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 16:06:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="oSYRpi6m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCDEA20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbeLCQHB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 11:07:01 -0500
Received: from mail-yb1-f175.google.com ([209.85.219.175]:35229 "EHLO
        mail-yb1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbeLCQHB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 11:07:01 -0500
Received: by mail-yb1-f175.google.com with SMTP id z2-v6so5491601ybj.2
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 08:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=2/6ol2inuIb3c0nCcO+qg1oQ9oUW6ihPFAUnrG4yywo=;
        b=oSYRpi6m6vT3WavtpWvYkO6bbmPogsXRbDk8TnaUdl3PJJ9QTSFDeXzbuLKFJFagmM
         g3f7R12ftqng6sfESSQZpTEBSmXo1LHSe1bkVivupSsJdmo8b5TGoJCK8wTRhR1G/zOf
         UXtnIy9lEdl8/jyGoZT9GjwaSz2CINyX6CEHvfL20t7DC9iqz3V2vqAEOl6E+3YP7BRQ
         YfzTxw+ObwXPngfmyjNqfSLutOuzRVf4alekii8kPsx6/ESF8wNp1VlAqRo419dkbhZP
         /2FYXfAIMfbXeu/NAUAt86j8nNKC5aWWkU3O71v7wTknCA3wAJi4A4ofY5xDaGo0unKf
         iO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=2/6ol2inuIb3c0nCcO+qg1oQ9oUW6ihPFAUnrG4yywo=;
        b=bx/kzvNHUPwEVtH8ZYX29O27No84btfXe/tFJ1GqaWJ6zRHmCBgt/hWw7Yhb9jtIzg
         sz3k+wKV+AMGHA2ZVPG7GBFM33nylj32b32Yo1ZJGvajM0dnAY7IGMWV1GGCBILX/JjJ
         UgV64wPk/RvO7lWXx9XJqGv3Fg9OTuZpt+ylM4FqsHXkY4M9/VJs0LfnN+sy3YGa/7kW
         wFPhSneEwKtBk/8imLk+I/CIrACRYmxGK1f9m7MTcOGfU3GYzEgp/MpVYMw14iIYWq3l
         EzbY11t43omvgf6NENPIyfAgGD3r3KXbU6upH7mA2CsSfjwTdy6E/AXMsh03KQiOCDcW
         2DHA==
X-Gm-Message-State: AA+aEWZCB0CNfmWksXcnkz+gcrL15nusAz2yPzEHn+kg72Q6hfh5C1y9
        GM9JEY3gEzvta8lGh0nuPyWt3Rbp2Qg=
X-Google-Smtp-Source: AFSGD/X4eDHkQiJ9xc/pPhXI5iNKZVWKOatJ6dTSxAB4jOOrj9zmo5DCbdas8sQDCcx2ec+WladjHQ==
X-Received: by 2002:a25:4184:: with SMTP id o126-v6mr15600878yba.166.1543853214581;
        Mon, 03 Dec 2018 08:06:54 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id i21sm11520310ywg.5.2018.12.03.08.06.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 08:06:53 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 0/3][V2] Delayed iput fixes
Date:   Mon,  3 Dec 2018 11:06:49 -0500
Message-Id: <20181203160652.25078-1-josef@toxicpanda.com>
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
