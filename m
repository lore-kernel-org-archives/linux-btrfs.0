Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6A1C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Mar 2021 20:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D36164F04
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Mar 2021 20:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbhCQUCZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Mar 2021 16:02:25 -0400
Received: from mail-qk1-f174.google.com ([209.85.222.174]:37336 "EHLO
        mail-qk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbhCQUCS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Mar 2021 16:02:18 -0400
Received: by mail-qk1-f174.google.com with SMTP id s7so40230039qkg.4
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Mar 2021 13:02:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fnzH94MNJV0M/I0n0poISZw+N7PhJjGhM1WIS1MMhIk=;
        b=C4l4hhEagsv3okj+Nc2PRnIlD1oXUuy2+7qiDedPbsNiT/+NShD3KRSpWjENTmsFOm
         N6Yl0EXeM5h2iAmuh4qvOaK9jR0F/RHcvAocxEnwxWz6OT+DiIb77EmBNg/iQC/rjg6f
         VN4RCPrjB57px9Lh2tRvB1lAOBXkNYgcusel09nf/xiRh6AJxaTBFg9cS9or/b6Ygj4b
         0gQFpdVvtLW+OC3WyocXqpfoQW11tydH3m2PkW4Gs2poRwBXVRBRcU7i4yAce3uJLTOV
         LN8jdV5sPl6ta0BKMTmMv0PXEW9jO2Sg0vLNd7zOR1JW9/i4OWXuED/NEQqmFhpoAAb7
         gkew==
X-Gm-Message-State: AOAM532cKUKV80ggync/CVgm6AHGCDXo54cVLTcktoRbuzFQ264IwJIE
        c+YN8feEinRhKq5Q0nTzCn5gyjFhgEb9zdHP
X-Google-Smtp-Source: ABdhPJygiIYWu0c2m9+nIm36/O0FlL3N+OAYgIiWZaH3C3LKXFLveUyRFFBs1tvan2j4Sj+SGnc9Lg==
X-Received: by 2002:a37:a941:: with SMTP id s62mr972885qke.404.1616011337672;
        Wed, 17 Mar 2021 13:02:17 -0700 (PDT)
Received: from Belldandy-Slimbook.datto.net (ool-18e49371.dyn.optonline.net. [24.228.147.113])
        by smtp.gmail.com with ESMTPSA id q65sm11772qkb.51.2021.03.17.13.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 13:02:17 -0700 (PDT)
From:   Neal Gompa <ngompa@fedoraproject.org>
To:     linux-btrfs@vger.kernel.org
Cc:     Neal Gompa <ngompa@fedoraproject.org>,
        Omar Sandoval <osandov@fb.com>,
        David Sterba <dsterba@suse.com>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH 0/1] btrfs-progs: libbtrfsutil: Relicense to LGPLv2.1+
Date:   Wed, 17 Mar 2021 16:01:43 -0400
Message-Id: <20210317200144.1067314-1-ngompa@fedoraproject.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is a patch requesting all substantial copyright owners to sign off
on changing the license of the libbtrfsutil code to LGPLv2.1+ in order
to resolve various concerns around the mixture of code in btrfs-progs
with libbtrfsutil.

Each significant (i.e. non-trivial) commit author has been CC'd to
request their sign-off on this. Please reply to this to acknowledge
whether or not this is acceptable for your code.

Neal Gompa (1):
  btrfs-progs: libbtrfsutil: Relicense to LGPLv2.1+

 libbtrfsutil/COPYING              | 1130 ++++++++++++-----------------
 libbtrfsutil/COPYING.LESSER       |  165 -----
 libbtrfsutil/btrfsutil.h          |    2 +-
 libbtrfsutil/btrfsutil_internal.h |    2 +-
 libbtrfsutil/errors.c             |    2 +-
 libbtrfsutil/filesystem.c         |    2 +-
 libbtrfsutil/python/btrfsutilpy.h |    2 +-
 libbtrfsutil/python/error.c       |    2 +-
 libbtrfsutil/python/filesystem.c  |    2 +-
 libbtrfsutil/python/module.c      |    2 +-
 libbtrfsutil/python/qgroup.c      |    2 +-
 libbtrfsutil/python/setup.py      |    4 +-
 libbtrfsutil/python/subvolume.c   |    2 +-
 libbtrfsutil/qgroup.c             |    2 +-
 libbtrfsutil/stubs.c              |    2 +-
 libbtrfsutil/stubs.h              |    2 +-
 libbtrfsutil/subvolume.c          |    2 +-
 17 files changed, 495 insertions(+), 832 deletions(-)
 delete mode 100644 libbtrfsutil/COPYING.LESSER

-- 
2.30.2

