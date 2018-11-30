Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0655C04EB8
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 16:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A67D220867
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 16:52:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="cnEvWLOf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A67D220867
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbeLAECN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Nov 2018 23:02:13 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:45628 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbeLAECN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Nov 2018 23:02:13 -0500
Received: by mail-yw1-f67.google.com with SMTP id d190so2517882ywd.12
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 08:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=xGCn3Cunh5e98ke9fS8OMASaq/+O8V/a1QdSYGRoeV4=;
        b=cnEvWLOf5VV/eCuw9kyij6LE98dUqoRXJLWRXwv+r6J7Qq6hjomuzax36ZYG1500wy
         2oporzntId2IQ20KyEqdDWI1BOzO/Ga1vXqo10gqpmgNchZGIVKSVTpSqr1nRVk+Ke44
         MNX4h0lekvZluVutyJDihSecYJz2ltYsglN0EMSFuYNuBGOhAsxJ735dzh1k/qYdc0io
         zO1ewncU56IKqbcGEaO5Ex6UT0tO/Fk+gd1uUm85dkeEuk0jgM3chVdA8MzSllf1lgeY
         nrTqApO/9tjZe76blROyeuG7Wy93EXE8J1RzrMfXQXjjmOcUUtrBSE1DC66SpxOO6jYM
         q2zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=xGCn3Cunh5e98ke9fS8OMASaq/+O8V/a1QdSYGRoeV4=;
        b=PUK6PxbJuFePDpx9J51GCLOR3wj4G6IRl1I/kKBYgb2BgwjFLuNtrs2jl6m2NxnC8L
         ZqhnYiiKTidN49ID4B6zizO+Y4Psw3ELbWHjQPLCyIVRTpmXAeVICVpFyNpdpm/3lUR/
         1ggXhOe5RPyrjmw+5wVaeA1dWlKNlboV1ghKIbyastWGoaczvlYQLljfax4Y8meRqQ3E
         MhY3DPx2PdjgnRHYSUh8TlucYSlt5Hb7iIrbDGa/kNNJ7cEb0jiCV0qt+qjB5/kEfVaq
         44QD2cYsy8DqsZiICSOv4Xb2/+gC4mDyAv6qaVBa0OumbIVOXSETuZH13+gufcs1nxg6
         k1Zw==
X-Gm-Message-State: AA+aEWYe0y+cwjt+em/nj122frqAGt2kYooujfQdtPF+goSlwkdH3VH7
        /LLHXvwwWfnbkQ4lQqgHcCUoIhG4ieI=
X-Google-Smtp-Source: AFSGD/VoXTQagg2ZLv8nzCPgHFVq/4rX0s8m19obKwV1SJisi4dqv1Vc+GwFC9RWgIlG/mLJUgO4RQ==
X-Received: by 2002:a81:7541:: with SMTP id q62mr5836728ywc.499.1543596737459;
        Fri, 30 Nov 2018 08:52:17 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id s189-v6sm1701628ywg.69.2018.11.30.08.52.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 30 Nov 2018 08:52:16 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 0/2] Fix aborts when dropping snapshots
Date:   Fri, 30 Nov 2018 11:52:12 -0500
Message-Id: <20181130165214.17883-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

With more machines running my recent delayed ref rsv patches we started seeing a
spike in boxes aborting in __btrfs_free_extent with being unable to find the
extent ref.  The full details are in 2/2, but the summary is there's been a bug
ever since the original delayed inode item stuff was introduced where it could
run once the snapshot was being deleted, which will result in all sorts of
extent reference shenanigans.  This was tricky to hit before, but with my iput
changes it's become much easier to hit on our build boxes that are heavy users
of snapshot creation/deletion.  Thanks,

Josef
