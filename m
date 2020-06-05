Return-Path: <SRS0=RMw4=7S=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CBAC433E0
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Jun 2020 20:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 659E6206FA
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Jun 2020 20:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgFEUsq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 16:48:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:47726 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbgFEUsq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jun 2020 16:48:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B5C6BABE4;
        Fri,  5 Jun 2020 20:48:48 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     darrick.wong@oracle.com
Cc:     linux-btrfs@vger.kernel.org, fdmanana@gmail.com,
        linux-fsdevel@vger.kernel.org, hch@lst.de
Subject: [PATCH 0/3] Transient errors in Direct I/O
Date:   Fri,  5 Jun 2020 15:48:35 -0500
Message-Id: <20200605204838.10765-1-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In current scenarios, for XFS, it would mean that a page invalidation
would end up being a writeback error. So, if iomap returns zero, fall
back to biffered I/O. XFS has never supported fallback to buffered I/O.
I hope it is not "never will" ;)

With mixed buffered and direct writes in btrfs, the pages may not be
released the extent may be locked in the ordered extents cleanup thread,
which must make changes to the btrfs trees. In case of btrfs, if it is
possible to wait, depending on the memory flags passed, wait for extent
bit to be cleared so direct I/O is executed so there is no need to
fallback to buffered I/O.

-- 
Goldwyn


