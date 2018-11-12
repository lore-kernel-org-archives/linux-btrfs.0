Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C6CEC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 22:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B8542241E
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 22:15:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="kxID03uw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B8542241E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729715AbeKMIKl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 03:10:41 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51804 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbeKMIKl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 03:10:41 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.22/8.16.0.22) with SMTP id wACMC9Tg027099
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 14:15:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=EmWOq26TSVwHKR8ygDGXHTvdvag7E1Q8recchvZP8IU=;
 b=kxID03uwD0PmTibBv6GXMtQIm4xxrKAj/9LQ0ICnq7kEb13DaLhcMHfMUDXY4WlvKCVr
 xQaacb8iPTISclKTZk75gjVkSByF9e1K/yQSbgTdRj5CeRORZlD9LPNwU8EMraVRESZJ
 Je4gFDFrt/8k+fhyaa7+xEDjpFGwBp0nphA= 
Received: from maileast.thefacebook.com ([199.201.65.23])
        by m0001303.ppops.net with ESMTP id 2nqeudgnys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 14:15:33 -0800
Received: from mx-out.facebook.com (2620:10d:c0a1:3::13) by
 mail.thefacebook.com (2620:10d:c021:18::175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1531.3;
 Mon, 12 Nov 2018 14:15:32 -0800
Received: by devvm3802.prn3.facebook.com (Postfix, from userid 32154)
        id C909236884CC; Mon, 12 Nov 2018 14:15:30 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Nick Terrell <terrelln@fb.com>
Smtp-Origin-Hostname: devvm3802.prn3.facebook.com
To:     Nick Terrell <terrelln@fb.com>
CC:     David Sterba <dsterba@suse.cz>, <kernel-team@fb.com>,
        <linux-btrfs@vger.kernel.org>, <grub-devel@gnu.org>,
        Daniel Kiper <dkiper@net-space.pl>
Smtp-Origin-Cluster: prn3c11
Subject: [PATCH v5 0/2] btrfs: Add zstd support to grub btrfs
Date:   Mon, 12 Nov 2018 14:14:44 -0800
Message-ID: <20181112221446.2154944-1-terrelln@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-12_14:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all,

This patch set imports the upstream zstd library, adds zstd support to the
btrfs module, and adds a test case. I've also tested the patch set by storing
my boot partition in btrfs with and without zstd compression and rebooting.

Best,
Nick Terrell

Changelog:

v1 -> v2:
- Switch to upstream zstd-1.3.6 and drop all the local patches.
- Fix comments from Daniel Kiper.

v2 -> v3:
- Remove an extra file accidentally included in the first patch.
- Use grub_error() to set grub_errno in grub_btrfs_zstd_decompress().
- Fix style and formatting comments.

v3 -> v4:
- Put zstd in its own module.
- Update commit messages.
- Use attribute unused.
- Rebase on top of RAID patchset.

v4 -> v5:
- Add change lists to the top of the commit messages.
- Add a header to zstd's moudle.c file.
- Clarify where zstd's dependencies are coming from.
- Add module.c to Makefile.util.def.
- Clarify some error logging.
- Explain why I changed lzo's include.

Nick Terrell (2):
  Import upstream zstd-1.3.6
  btrfs: Add zstd support to grub btrfs

 Makefile.util.def                    |   11 +-
 grub-core/Makefile.core.def          |   17 +-
 grub-core/fs/btrfs.c                 |  108 +-
 grub-core/lib/zstd/bitstream.h       |  458 ++++
 grub-core/lib/zstd/compiler.h        |  133 ++
 grub-core/lib/zstd/cpu.h             |  215 ++
 grub-core/lib/zstd/debug.c           |   44 +
 grub-core/lib/zstd/debug.h           |  123 +
 grub-core/lib/zstd/entropy_common.c  |  236 ++
 grub-core/lib/zstd/error_private.c   |   48 +
 grub-core/lib/zstd/error_private.h   |   76 +
 grub-core/lib/zstd/fse.h             |  708 ++++++
 grub-core/lib/zstd/fse_decompress.c  |  309 +++
 grub-core/lib/zstd/huf.h             |  334 +++
 grub-core/lib/zstd/huf_decompress.c  | 1096 +++++++++
 grub-core/lib/zstd/mem.h             |  374 ++++
 grub-core/lib/zstd/module.c          |   21 +
 grub-core/lib/zstd/xxhash.c          |  876 ++++++++
 grub-core/lib/zstd/xxhash.h          |  305 +++
 grub-core/lib/zstd/zstd.h            | 1516 +++++++++++++
 grub-core/lib/zstd/zstd_common.c     |   81 +
 grub-core/lib/zstd/zstd_decompress.c | 3108 ++++++++++++++++++++++++++
 grub-core/lib/zstd/zstd_errors.h     |   92 +
 grub-core/lib/zstd/zstd_internal.h   |  257 +++
 tests/btrfs_test.in                  |    1 +
 tests/util/grub-fs-tester.in         |    2 +-
 26 files changed, 10545 insertions(+), 4 deletions(-)
 create mode 100644 grub-core/lib/zstd/bitstream.h
 create mode 100644 grub-core/lib/zstd/compiler.h
 create mode 100644 grub-core/lib/zstd/cpu.h
 create mode 100644 grub-core/lib/zstd/debug.c
 create mode 100644 grub-core/lib/zstd/debug.h
 create mode 100644 grub-core/lib/zstd/entropy_common.c
 create mode 100644 grub-core/lib/zstd/error_private.c
 create mode 100644 grub-core/lib/zstd/error_private.h
 create mode 100644 grub-core/lib/zstd/fse.h
 create mode 100644 grub-core/lib/zstd/fse_decompress.c
 create mode 100644 grub-core/lib/zstd/huf.h
 create mode 100644 grub-core/lib/zstd/huf_decompress.c
 create mode 100644 grub-core/lib/zstd/mem.h
 create mode 100644 grub-core/lib/zstd/module.c
 create mode 100644 grub-core/lib/zstd/xxhash.c
 create mode 100644 grub-core/lib/zstd/xxhash.h
 create mode 100644 grub-core/lib/zstd/zstd.h
 create mode 100644 grub-core/lib/zstd/zstd_common.c
 create mode 100644 grub-core/lib/zstd/zstd_decompress.c
 create mode 100644 grub-core/lib/zstd/zstd_errors.h
 create mode 100644 grub-core/lib/zstd/zstd_internal.h

--
2.17.1
