Return-Path: <SRS0=y5XK=V5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 264A4C433FF
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Aug 2019 22:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D702E206A2
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Aug 2019 22:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="zEg1A1gC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389404AbfHAWTl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Aug 2019 18:19:41 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]:37577 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbfHAWTk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Aug 2019 18:19:40 -0400
Received: by mail-qt1-f172.google.com with SMTP id y26so71982767qto.4
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Aug 2019 15:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rb6MFAdbwhxbjpO3IRBkEQaArW2BgW96wHIBULUjBc8=;
        b=zEg1A1gCvcKjitNURE/NeK6VUUXiGHWHgqARLz3oVKaMhNYxE1U5WOQskY7Rn5dXHl
         ejEbvTKRzIS+NZ4GVz0qKh7bzFKJkqFUbszjm2it6OlGgUnqMY0BpeUo6gpO9IXhERod
         qB+k2ON1CasX91iS2QdTr+wULstMZbDl+tdobSm1HbO+w+6I48a9uU+2kWI6Ho2NsxTY
         0ZXTOAUNrHNL+0km08jV4GdoUmJNN569/UemtF8K7efj2hc7Nx0Zs5FK5hdZL2VkX/ZD
         NBMV+RP5FOriBq080tV/E5VFIiOT5wSubdkLp5qY9pSC3jjwCEraIGvUeX75KlfsTRgR
         bWCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rb6MFAdbwhxbjpO3IRBkEQaArW2BgW96wHIBULUjBc8=;
        b=H5jQ2O4DHHDVpDomDmoLiTlYtGXMsincKw5L1RPBzZoGnbHhh5w+T1aCku4UXWJ7+t
         tIpD69svPTtcpKsQrXm3+t3imC7IVEg2KQzWUQDd6MwelzTdxc6vijjqzwN1EI4h0vAJ
         Gp89XhWU9Gp/Uv1fqO91qroir/7eCiJekh3trfKaGo2TfwdDDXN9g10wlSDb78v4NJc2
         2jE5t/0WebHJJmb3polNK8mUVoJbeXBIBFBlFN60hOp3EStZosjsHLwqW24AZ+dk3lch
         cJYTcmm6/6QFeqi1kiGb7hQfVjzuIDYp8fJAuCNHn8eAnffXrTtfiIZFiMhywdSeHXxC
         9Vdg==
X-Gm-Message-State: APjAAAUZgRMEA2IUBF5Yfl8hwLA6nAJ4pW+UKaMMy4geCUniL+tDqubl
        GGzlzqY51YczfQ4JR6qq/2eUdhabpG4=
X-Google-Smtp-Source: APXvYqxcR/jTvZbYFXyxJtKkwa21rdnioEZbqK15BerVIajZEzfl5fEUoMl5ssDqxwJGnqv2ZG3wAA==
X-Received: by 2002:ac8:7349:: with SMTP id q9mr92450275qtp.151.1564697979450;
        Thu, 01 Aug 2019 15:19:39 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id h18sm29929766qkk.93.2019.08.01.15.19.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 15:19:38 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 0/5] Rework eviction space flushing
Date:   Thu,  1 Aug 2019 18:19:32 -0400
Message-Id: <20190801221937.22742-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is a set of patches to address how we do space flushing for inode
evictions.  Historically we've only been allowed to do a few things to reclaim
space for inode evictions, mostly because we'd deadlock with iput.  But we have
delayed iputs in place to make sure we're always doing iput where it's
completely safe to do an iput.

However we do run iputs for flushing, so we can't just do FLUSH_ALL, otherwise
we could deadlock.  Also we still want to prioritize evictions for space
reclamation because we likely will free up space for other people to make
reservations.

The first 4 patches are preparation patches, just refactoring so we can add this
new flushing time for eviction.  This allows us to clean up our current ad-hoc
loop we have for reclaiming space for evictions and use the common helpers that
everybody else uses.  Thanks,

Josef

