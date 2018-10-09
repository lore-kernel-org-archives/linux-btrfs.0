Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C482C64EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 16:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E583A2086D
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 16:40:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E583A2086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbeJIX6h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 19:58:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:58158 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726567AbeJIX6h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 19:58:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A2644B007
        for <linux-btrfs@vger.kernel.org>; Tue,  9 Oct 2018 16:40:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 84728DAD2B; Tue,  9 Oct 2018 18:40:45 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.cz>
Subject: Next btrfs development cycle open - 4.21
Date:   Tue,  9 Oct 2018 18:40:40 +0200
Message-Id: <20181009164040.17819-1-dsterba@suse.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: David Sterba <dsterba@suse.cz>

Hi,

a friendly reminder of the timetable and what's expected at this phase.

4.18 - current
4.19 - upcoming, urgent regression fixes only
4.20 - development closed, pull request in prep, fixes or regressions only
4.21 - development open, until 4.20-rc5 (at least)

(https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Development_schedule)

Whether the next version is going to be 4.20 or 5.0 I don't know, I'll use the
4.x for references. There will be 4.19-rc8 milestone, probably the last one
before the final release.


Current status
--------------

The branch misc-4.20 contains patches that will be sent in the first 4.20
batch.  There are about 90, fewer than in previous cycles.

There might be 2nd pull sent during the merge window, the reviews are going
slow but there are still patches/fixes that I'd like to get merged.


Hilights of 4.20 changes
------------------------

The more detailed description will be in the pull request, brief summary:

* (performance) relocation with qgroups on -- skip unnecessary qgroup
  accounting work during merging b-trees after relocation, claimed improvement
  is 20-40%+ (run time) but highly depends on the extent layout

* (performance) b-tree path traversal and locking improvements -- no more
  switching between blocking and spinning mode, sample measurements show
  noticeable improvements in latency and run time

* (performance) rb-tree caching -- repeated tree traversal does not need to
  spend time chasing pointers up to the first node


Git development repos
---------------------

  k.org: https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
  devel1: https://gitlab.com/kdave/btrfs-devel
  devel2: https://github.com/kdave/btrfs-devel

Note: git repository at repo.or.cz is discouraged from use

The devel repos should be identical regarding the main development branches
like misc-next or for-next-YYYYMMDD.


Usual points
------------

* the current patch queue (as is in misc-next) looks stable, so no big
  changes are going to be applied at this time. The usual exceptions are
  bugfixes or obvious cleanups.

* the base of the patches should be the last announced pull request,
  which is going to be named 'for-4.20' in my k.org tree.  Reviewed
  patches will be collected in a branch that's usually named 'misc-next'
  in my devel git repos and is part of the for-next at k.org git repo.

* merging of new patches to misc-next will be slow during the
  merge window, also because there's a btrfs-progs release scheduled

* everybody is encouraged to review and test other's patches
