Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C445C282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 16:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E4D6218D3
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 16:54:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="1IVuH/9z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfBGQyc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 11:54:32 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40022 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfBGQyc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 11:54:32 -0500
Received: by mail-qt1-f193.google.com with SMTP id j36so606873qta.7
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2019 08:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=zT+Vd/xGJo3GVQC3WLQGMluTS5AB/R7V3xhbszljkyg=;
        b=1IVuH/9z2F9hOOnykSqY+DRCKppZ+malqXZl9zcv+x5/OuoTbdPE1mDdtOdYa3/VwM
         FOWKJuW/ipGDanoC1JSpvvgqNZcT05vcA7CNbcotZpVBpuqczA28JRvmtBsJGz7KioDn
         T+o1POXPuonluJBT+UmYsxppqpdQ6mDAT+pj7Hg/KDccHbtiZ78Va9JtRvhM6ujl1qj8
         /uPCMw/I6/SU0wbuS98iZTKVEtg9ONnoQIqY0Z5F+8tv3dJpuGORnrhRucdMjzgszfLF
         9nAzQg+rGLxV5wXu2GToL2NlBcr6rPMqxqND2DQIL6CuHBn0vhjIw9e9Z3JpTb7k6oH2
         VgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=zT+Vd/xGJo3GVQC3WLQGMluTS5AB/R7V3xhbszljkyg=;
        b=B9ZZXY0tORrtOIUvJoH3YIKfqgihyha+WpzqZDSPAEJhUlMrh0AkjDqdOSGvETN0Du
         n3zVYBxv7c/b+BJLRhxAS7bylDM/PXJDhbrSONV6V52Q8XWBUA8ZoDuKQF0THuonoU63
         MRL8CVKAynvdOBxUSrekYyhHmVVq5qJQQK3rV717aBMVEPuZzG3v/ylv1KRCOTVtbFt0
         h1gNSKff96VEa4PsJ5TGQv1F0ztf1JzRGU+wSMWJ2LtMX3KjNnEf4pHliHq7OOZFd5Gf
         6NItuBefhO9XejC4nHVZNyAx1tafjRh25Sy8SumDg4LdfkTPRvpsJGdZ5aorE33VNhMv
         jbEA==
X-Gm-Message-State: AHQUAubm02WpJHzttXLTqLhhmQyliO85n/1tEPs3b18A8fbeuHVuxXX3
        y8h5cv3qfi+KvXADCw5VOwWWj8h27Ro=
X-Google-Smtp-Source: AHgI3IaeAb+sUKtH7kIIkifZfUDExW61oin/fmCn+tgq7wtF8fmK9qTghBFNFLuCi8nrwz9wMQ72Ew==
X-Received: by 2002:ac8:2502:: with SMTP id 2mr12830314qtm.53.1549558470970;
        Thu, 07 Feb 2019 08:54:30 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id q30sm5119570qtq.20.2019.02.07.08.54.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Feb 2019 08:54:30 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 0/2] Reserve more space for property inheritance
Date:   Thu,  7 Feb 2019 11:54:24 -0500
Message-Id: <20190207165426.15866-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We've been seeing messages on our build servers where we fail to reserve space
for the compression property and thus fail to create the property at inode
creation time.  This is because we do not pre-reserve the space, instead opting
to use NO_FLUSH which can fail transiently, and create these messages.  Instead
just pre-reserve an extra items worth of space, and use that space when we
inherit our property.  We only have the compression property right now, so we
can get away with this, and if we add any more properties we have the backup
method of doing the NO_FLUSH reservation.  However in the future we may want to
take a more nuanced approach to property space reservation if we add a bunch of
new properties.  Thanks,

Josef
