Return-Path: <SRS0=zKcM=XL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3978C4CEC7
	for <linux-btrfs@archiver.kernel.org>; Mon, 16 Sep 2019 08:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8341120890
	for <linux-btrfs@archiver.kernel.org>; Mon, 16 Sep 2019 08:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfIPIR3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 04:17:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:43584 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726128AbfIPIR3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Sep 2019 04:17:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 59C25AFA9;
        Mon, 16 Sep 2019 08:17:28 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH for-4.14 0/2] btrfs compression type validation fix
Date:   Mon, 16 Sep 2019 10:17:24 +0200
Message-Id: <20190916081726.7983-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Greg,

Here's the backport of aa53e3bfac72 ("btrfs: correctly validate compression
type") for v4.14 with it's prerequisite e128f9c3f724 ("btrfs: compression:
add helper for type to string conversion").

David Sterba (1):
  btrfs: compression: add helper for type to string conversion

Johannes Thumshirn (1):
  btrfs: correctly validate compression type

 fs/btrfs/compression.c | 31 +++++++++++++++++++++++++++++++
 fs/btrfs/compression.h |  3 +++
 fs/btrfs/props.c       |  6 +-----
 3 files changed, 35 insertions(+), 5 deletions(-)

-- 
2.16.4

