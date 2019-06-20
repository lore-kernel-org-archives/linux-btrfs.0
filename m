Return-Path: <SRS0=S96U=UT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA04C43613
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Jun 2019 19:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 504F8206BA
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Jun 2019 19:38:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="qFIW1NJn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfFTTiL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Jun 2019 15:38:11 -0400
Received: from mail-yw1-f46.google.com ([209.85.161.46]:42897 "EHLO
        mail-yw1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbfFTTiL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jun 2019 15:38:11 -0400
Received: by mail-yw1-f46.google.com with SMTP id s5so1662515ywd.9
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2019 12:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=M8tAGAl8pq9Ij65BX0XKVNdv3hBzhBqGkLD1ieC8MhE=;
        b=qFIW1NJntr5WX/0B02AVJ+r//x3o9Cflk9krr6CPkKrILNMCO03xrqyStzYisUsVHH
         C0bvlidnFNZ8qHxO+HfySEThmK25p3DIFnml6nhFgiHo41rz3NfFGlfN3R4+lHKNweaL
         h4JzJGmKNypCvHbpQjGxdi4bc/wY8Ld8sZtnoNJb/41FxLfLMYf1MG4TMu56FXbbJ0QO
         VYMq+xBN4jri+5Q0pGQ859J3RM8h4CWauYOuvMmoFkhC6OSByeG0qFOybkPp+c7jX18y
         g+dzG4wzBgn9VnllMiw+n+dNxETSArJU+8Xf8QpoUHXzmL6uAiPJxzttAAqVjTaCwszx
         wvpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=M8tAGAl8pq9Ij65BX0XKVNdv3hBzhBqGkLD1ieC8MhE=;
        b=UTZZFCszDNWHWX0nDuq749wxZ6i89zmyEXg6SlhAzOERxqfPPssdDf8puZN8mq9hqQ
         MUEPorKxRKzBk+2anYc4c5rPxm2avNAKd5/xJDGcJ+/CGwTg/i0PrvdLlh0VVvbJuMo4
         t4hQkf2x5QBj6v0kYfFhWuoDnxYvpwcnEd7L2NWIIN77+uVgIIGiEgTP1VFKpMnyfVup
         I2pdd6R85HvrvR7bCFPtooIaK1iSnwxWfNj9mXoNGCqsQ56Yibwgl/nCXSMQZixpuIgA
         MRBHjuGPu922QTYh8dMr9DNqigbT+tjVOGoTTTpr3Lad0wG1WgnKZoLipvXKS7X3xQ8m
         +MVw==
X-Gm-Message-State: APjAAAUnf+cL+ek7e5uOCby7upqHXNiVJF7sFrPuM5WJiHxST3xXfM4q
        +RX1C2kbRs0Mydcn2kNopekYUr7oeJKgaA==
X-Google-Smtp-Source: APXvYqy4iGaND7QlB9v5kqSo0PkGAyNfhg5wwnXSCX9FD/T6wxE3z4i8FgkGZ3q+vsHKVGhY3dXsuQ==
X-Received: by 2002:a81:3956:: with SMTP id g83mr73156186ywa.183.1561059490020;
        Thu, 20 Jun 2019 12:38:10 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id j9sm104400ywc.43.2019.06.20.12.38.09
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Jun 2019 12:38:09 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 00/25] btrfs: migrate the block group code
Date:   Thu, 20 Jun 2019 15:37:42 -0400
Message-Id: <20190620193807.29311-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is the series to migrate the block group code out of extent-tree.c.  This
is a much larger series than the previous two series because things were much
more intertwined than block_rsv's and space_info.  There is one code change
patch in this series, it is

btrfs: make caching_thread use btrfs_find_next_key

This is so I didn't have to copy the simple helper from extent-tree.c into
block-group.c as well.  It's straightforward, but warrants a close look.

The rest is purely moving code around, no code changes at all.  I temporarily
export some functions at different points and then clean it all up at the end.

This patchset brings extent-tree.c down to ~5500 loc.  Thanks,

Josef
