Return-Path: <SRS0=FriU=YS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52901CA9EA0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Oct 2019 12:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EEDD21D71
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Oct 2019 12:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504409AbfJYMPZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 08:15:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:60632 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504407AbfJYMPZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Oct 2019 08:15:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E7ED2B189
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2019 12:15:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 82C81DA785; Fri, 25 Oct 2019 14:15:35 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: Btrfs progs release 5.3.1
Date:   Fri, 25 Oct 2019 14:15:35 +0200
Message-Id: <20191025121535.28802-1-dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

btrfs-progs version 5.3.1 have been released.

This fixes (only) linking against libbtrfs (reported by snapper users).
I did houpefully enough testing, the CI is green, builds on various arches, and
snapper running with the library from 5.3.1 works.

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (5):
      btrfs-progs: libbtrfs: add list of exported symbols
      btrfs-progs: build: add missing symbols to libbtrfs
      btrfs-progs: preload libbtrfs for libbtrfs-test
      btrfs-progs: update CHANGES for 5.3.1
      Btrfs progs v5.3.1
