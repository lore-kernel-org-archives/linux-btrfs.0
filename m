Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F379C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EFCC21780
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="qX6yifnV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4EFCC21780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbeKNRtT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 12:49:19 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39729 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbeKNRtT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 12:49:19 -0500
Received: by mail-pf1-f194.google.com with SMTP id c72so2797861pfc.6
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 23:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w78MFz+wFzoJsP6szv9l7x3xRldPZ8s2tW52TRJW/qw=;
        b=qX6yifnVMtyExN5tCrI+5T8IlFu0012d6/MLP292dWpJxmW/5wEncaQyoSnZu51NmX
         BK42dY3OHRdzaa75aZWafU+xjPF4SbEZ0MEqPFcMiTOn+q5k6RfMTg4V7nz13zS5RzrL
         SjaWT3Wo8tOtl87TrzDOw5DVQTvPITruNXR2U4iJv6mgkBf2r8URCbWQLg5zLCiGHV3R
         aiL5XVwGa9E6Z/Somoj9IaZHUaTxb5kJXH5WwBEaslbg7Pl/T9kD2rj6KLIYwuUty4vh
         oRnlRfgbkcuJ0T2UVIq4i8uET9AbnOyk/9Di7qs+FnxY/88TE/d8JmsNEGn3DxhVQNuN
         sl/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w78MFz+wFzoJsP6szv9l7x3xRldPZ8s2tW52TRJW/qw=;
        b=rZe0Yaq15+tF1zlVvr+FGDNWuqTmLWs+pT2PsPMQ0IsGxVquaglfhqoGt7E3K0CQ4Y
         xV4IVeAw5mKJ1SQfGsC0byb+fqB6SgPEX4CH25GmbeFoAaMP+xlxlHZBFm64Ura4utWz
         Cv4B1mh/at1TnzlHcANzs5pL7rVUMSJgBYQTFH5XtTXeBTNkgB6SA8NBGlybRzTsF/6+
         2tryTF2WiV4Z78CRP4td4KAdaV/R4KhEfUXgUI9VRo6MZY7FCS+UT2sJRyONWyra4V5n
         /FN0Iphg79y18v11MuY6/XHrLrn3I76Q2URpjvF6JmB1tIGAn2cM/+YEA3J20JVqXETD
         DD9Q==
X-Gm-Message-State: AGRZ1gI39ZZR/E5XcR8re1QgDQQYTgDAT+/x6/vDXGp7r9k7dn75+d+p
        TkkzSJSUSFvxTPAtKDGw2Z8x+FlTPK/C5A==
X-Google-Smtp-Source: AJdET5egeKVZaUMxiqxZjQAQvKYQa3zRZIb5Xh5vT2tpif5qzbJJmdrWwuPP+wWlfxUbwSD3s7KndQ==
X-Received: by 2002:a63:de4c:: with SMTP id y12mr795946pgi.198.1542181633813;
        Tue, 13 Nov 2018 23:47:13 -0800 (PST)
Received: from vader.psav.com ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id 18-v6sm34835727pfu.129.2018.11.13.23.47.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 23:47:13 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 00/10] btrfs-progs: my libbtrfsutil patch queue
Date:   Tue, 13 Nov 2018 23:46:55 -0800
Message-Id: <cover.1542181521.git.osandov@fb.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Hi,

This series contains my backlog of libbtrfsutil changes which I've been
collecting over the past few weeks.

Patches 1-4 are fixes. Patches 5-6 add functionality to the unit tests
which is needed for patches 7-8. Patches 7-8 add support for the
unprivileged ioctls added in Linux 4.18; more on those below. Patch 9
bumps the library version. Patch 10 adds documentation for the available
API along with examples.

Patches 7-8 are based on Misono Tomohiro's previous patch series [1],
with a few important changes.

- Both subvolume_info() and create_subvolume_iterator() now have unit
  tests for the unprivileged case.
- Both no longer explicitly check that top == 0 in the unprivileged
  case, since that will already fail with a clear permission error.
- Unprivileged iteration is much simpler: it uses openat() instead of
  fchdir() and is based more closely on the original tree search
  variant. This fixes a bug in post-order iteration in Misono's version.
- Unprivileged iteration does _not_ support passing in a non-subvolume
  path; if this behavior is desired, I'd like it to be a separate change
  with an explicit flag.

Please take a look.

Thanks!

1: https://www.spinics.net/lists/linux-btrfs/msg79285.html

Omar Sandoval (10):
  libbtrfsutil: use top=0 as default for SubvolumeIterator()
  libbtrfsutil: change async parameters to async_ in Python bindings
  libbtrfsutil: document qgroup_inherit parameter in Python bindings
  libbtrfsutil: use SubvolumeIterator as context manager in tests
  libbtrfsutil: add test helpers for dropping privileges
  libbtrfsutil: allow tests to create multiple Btrfs instances
  libbtrfsutil: relax the privileges of subvolume_info()
  libbtrfsutil: relax the privileges of subvolume iterator
  libbtrfsutil: bump version to 1.1.0
  libbtrfsutil: document API in README

 libbtrfsutil/README.md                      | 422 +++++++++++++++++++-
 libbtrfsutil/btrfsutil.h                    |  21 +-
 libbtrfsutil/errors.c                       |   8 +
 libbtrfsutil/python/module.c                |  17 +-
 libbtrfsutil/python/subvolume.c             |   6 +-
 libbtrfsutil/python/tests/__init__.py       |  66 ++-
 libbtrfsutil/python/tests/test_subvolume.py | 215 +++++++---
 libbtrfsutil/subvolume.c                    | 407 ++++++++++++++++---
 8 files changed, 1029 insertions(+), 133 deletions(-)

-- 
2.19.1

