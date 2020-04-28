Return-Path: <SRS0=dRQQ=6M=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F7FCC8300A
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Apr 2020 11:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50ABD206D9
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Apr 2020 11:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588072302;
	bh=TomQ4WFT+ik0YmVkGjiJ/NZ1fqaFN52+rmAvBpbOi+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XHWpheQ7mAtlhVL7RIuVpTTYypXLPRSclpCocuO4BExdMCaaeaM35o1DSyp0luxKO
	 Em7jQXkr2c/2IxZaRJxb5VCWdAvD+34UB1z108B6HeOyGrdBoFDTtR66E1tzsrCtlo
	 N0D7bkaS9OlNxNga4nw4OLXwVXvytdDowrPO1yjk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgD1LLl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 07:11:41 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:45432 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgD1LLi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Apr 2020 07:11:38 -0400
Received: by mail-wr1-f49.google.com with SMTP id t14so24128207wrw.12
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2020 04:11:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gYDydGQtXvgBW1agdD/MU4YV2iQTL3pAF8uLk1Fg8hQ=;
        b=RpfjtEBGEPDD1RhHudYbM3dRhyEmVz1C8vNRHW3DlykON2/kxklpkbZrptx+0u5GrT
         W61bjOcPrCsCMRW01p5lRX2qEN6KJxT6rsb/BLQF78XtBpIUTAkmlECuiBW4RDsAVuk+
         6J6/xXPyz7avy9RgrQwJnQoBte9YVLQWXFa1YFPaS773nmLaUgQ2/Wp1y5Xh5SmHMkGp
         yqqssoqlcK630z0NC9chj4kvTmr86ERZvz9jqE3JXsP8wOU8TtC33zRxzAVYB9PpdF2H
         Y5EUYAHRQixTNSBa2U8JfBtNWvzfEB+FV4Nf+eEHKyqQFHbbgse057KPnRv4rQ9pCvjb
         IlYQ==
X-Gm-Message-State: AGi0PuYK4L76bRk1NqUD6/N6Rv17Mq/vOBpDOYdDKJMi49cqBotK1UBE
        LtPVfoAjwK5lSXDrcOAnULmrRzawy/AOdg==
X-Google-Smtp-Source: APiQypIk5iuG6nRBf6etQqpQ4ZBKsBm+Sqxy5qY7Moh8plFdJXyT85PZ9Q4OBuyL2UutevEf2aYIfA==
X-Received: by 2002:a5d:5651:: with SMTP id j17mr31882418wrw.406.1588072296774;
        Tue, 28 Apr 2020 04:11:36 -0700 (PDT)
Received: from linux-t19r.fritz.box (ppp-46-244-205-206.dynamic.mnet-online.de. [46.244.205.206])
        by smtp.gmail.com with ESMTPSA id b191sm3126291wmd.39.2020.04.28.04.11.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Apr 2020 04:11:36 -0700 (PDT)
From:   Johannes Thumshirn <jth@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     "linux-btrfs @ vger . kernel . org" <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 0/5] btrfs-progs: support creating authenticated file-systems
Date:   Tue, 28 Apr 2020 13:11:09 +0200
Message-Id: <20200428111109.5687-7-jth@kernel.org>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200428111109.5687-1-jth@kernel.org>
References: <20200428111109.5687-1-jth@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

This series adds support for passing in an authentication key and using
HMAC(SHA256) for mkfs, dump-super and fsck.

Johannes Thumshirn (5):
  btrfs-progs: pass in fs_info to btrfs_csum_data
  btrfs-progs: add auth_key argument to open_ctree_fs_info
  btrfs-progs: Add HMAC(SHA256) support
  btrfs-progs: add --auth-key to dump-super
  btrfs-progs: add auth key to check

 btrfs-find-root.c           |  2 +-
 btrfs-sb-mod.c              |  4 ++--
 check/main.c                | 15 ++++++++++++---
 cmds/filesystem.c           |  2 +-
 cmds/inspect-dump-super.c   | 38 +++++++++++++++++++++++++++-----------
 cmds/inspect-dump-tree.c    |  2 +-
 cmds/rescue-chunk-recover.c |  4 ++--
 cmds/rescue.c               |  2 +-
 cmds/restore.c              |  2 +-
 common/utils.c              |  3 +++
 configure.ac                |  1 -
 convert/common.c            |  2 +-
 crypto/hash.c               | 23 +++++++++++++++++++++++
 crypto/hash.h               |  2 ++
 ctree.c                     |  1 +
 ctree.h                     |  3 +++
 disk-io.c                   | 39 ++++++++++++++++++++++++---------------
 disk-io.h                   |  8 +++++---
 file-item.c                 |  2 +-
 image/main.c                |  5 +++--
 mkfs/common.c               | 10 ++++++++++
 mkfs/common.h               |  3 +++
 mkfs/main.c                 | 25 +++++++++++++++++++++++--
 23 files changed, 150 insertions(+), 48 deletions(-)

-- 
2.16.4

