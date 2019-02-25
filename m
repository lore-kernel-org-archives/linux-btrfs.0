Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F1EDC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 18:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FD912084D
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 18:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbfBYSDZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 13:03:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:45322 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726225AbfBYSDZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 13:03:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B6E80B16A
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 18:03:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7AC06DA83C; Mon, 25 Feb 2019 19:04:40 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: Btrfs progs release 4.20.2
Date:   Mon, 25 Feb 2019 19:04:37 +0100
Message-Id: <20190225180438.4249-1-dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

btrfs-progs version 4.20.2 have been released. This is a quick fix of a problem
with send/receive path checks that break some setups. As there's no proper
fix yet, the patch that caused the regression has been reverted.

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (5):
      btrfs-progs: ci: explicitly request reiserfs support for btrfs-convert
      btrfs-progs: ci: switch to newer build environment
      Revert "Btrfs-progs: fix mount point detection due to partial prefix match"
      btrfs-progs: update CHANGES for v4.20.2
      Btrfs progs v4.20.2

Nikolay Borisov (1):
      btrfs-progs: Use a single tab for 'leafsize (deprecated)' row
