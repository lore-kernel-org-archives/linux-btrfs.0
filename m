Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CEFC282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 13:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BE0521848
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 13:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbfAWNDh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 08:03:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:44818 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725991AbfAWNDh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 08:03:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8FFD9ADD8
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2019 13:03:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2DBF5DA795; Wed, 23 Jan 2019 14:03:05 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: Btrfs progs release 4.20.1
Date:   Wed, 23 Jan 2019 14:03:04 +0100
Message-Id: <20190123130305.2583-1-dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

btrfs-progs version 4.20.1 have been released. This is a fix of build failure
of 3rd party tools that use libbtrfs, snapper in this case.

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (4):
      btrfs-progs: build: fix libbtrfs build
      btrfs-progs: ci: enable library-test
      btrfs-progs: update CHANGES for v4.20.1
      Btrfs progs v4.20.1
