Return-Path: <SRS0=op+e=4M=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A056C11D2F
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 17:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 321F420838
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 17:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582564346;
	bh=3CLbZp1/ymA+n5pUw91BHvucJD0VLJnrM8qIVB0h7so=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=fwA2PUNsEpm0QWiwbGTgX4kbzWd+WNRF2RoB0OY3B3T9KmSoGecmETwvQMasI+no5
	 UmsK3gXcoEtJErIvtqInfh+zWixepy1ZOmGu286/QVBMqpzu3lEgoJiCN/f418Pwyy
	 j2SolsVrlpPO2cZfSc3huscWtQ9JhemMS19X/Z3E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgBXRMZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 12:12:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbgBXRMZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Feb 2020 12:12:25 -0500
Received: from debian5.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19DD020836;
        Mon, 24 Feb 2020 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582564344;
        bh=3CLbZp1/ymA+n5pUw91BHvucJD0VLJnrM8qIVB0h7so=;
        h=From:To:Cc:Subject:Date:From;
        b=m7iDMnSuOsIr/6yz8SYfxJAHFAacukCiplCyx93wjUWkSTEgcDzAU2lcPYbRjeTvy
         PmXcMb69D5WKwGqSMJ5ngs1dy3Ovy1WTErPfxZ2YPmmrOZtciI0n4m4iYE4sBLaoyj
         V/EqwJ8GuhT1yvm+uq1C3/UFDbbuLWeRKndxSTmg=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     josef@toxicpanda.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 0/3] Add full support for cloning inline extents
Date:   Mon, 24 Feb 2020 17:12:19 +0000
Message-Id: <20200224171219.3655117-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

This patchset adds support for currently unsupported cases of reflink
operations that cover a file range that has inline extents, more details
on why/how in patch 4/4.

It also starts by moving all the reflink code out of ioctl.c into a new
file named reflink.c (like xfs does) since this code is quite significant
in size and has grown over the years.

V3: Updated first patch to introduce reflink.h as well, besides reflink.c.

V2: Removed third patch from the previous patchset version. Since the full
    page ends up getting written, it's not necessary to read it before
    writing to it in case it's not uptodate. The final patch, which is
    now patch number 3, ends up being simpler as well.

*** BLURB HERE ***

Filipe Manana (3):
  Btrfs: move all reflink implementation code into its own file
  Btrfs: simplify inline extent handling when doing reflinks
  Btrfs: implement full reflink support for inline extents

 fs/btrfs/Makefile  |   2 +-
 fs/btrfs/ctree.h   |   3 -
 fs/btrfs/file.c    |   1 +
 fs/btrfs/ioctl.c   | 733 ------------------------------------------
 fs/btrfs/reflink.c | 782 +++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/reflink.h |  12 +
 6 files changed, 796 insertions(+), 737 deletions(-)
 create mode 100644 fs/btrfs/reflink.c
 create mode 100644 fs/btrfs/reflink.h

-- 
2.25.0

