Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4A7C43219
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 13:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AFD92077B
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 13:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfDZNNs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 09:13:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:41718 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726013AbfDZNNs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 09:13:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 23F0BABF5
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2019 13:13:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4E70BDA847; Fri, 26 Apr 2019 15:14:49 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.cz>
Subject: Next btrfs development cycle open - 5.3
Date:   Fri, 26 Apr 2019 15:14:47 +0200
Message-Id: <20190426131447.15070-1-dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: David Sterba <dsterba@suse.cz>

Hi,

a friendly reminder of the timetable and what's expected at this phase. Sorry
for not sending it last time, I think it's useful so will try to keep the
habit.

5.0 - current
5.1 - upcoming, urgent regression fixes only
5.2 - development closed, pull request in prep, fixes or regressions only
5.3 - development open, until 5.2-rc5 (at least)

(https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Development_schedule)


Current status
--------------

The branch misc-next is almost ready to be forked as misc-5.2 and sent as the
first pull.  There are 2 patchsets that have been in for-next and are eligible
to be merged right away once some updates to changelogs arrive.

There is one known bug causing hang of generic/500, it'll be resolved before
misc-5.2 is branched.


Hilights of 5.2 changes
------------------------

The more detailed description will be in the pull request, brief summary:

- better read time and write checks to catch errors early and before writing
  data to disk (to catch potential memory corruption on data that get
  checksummed)

- tree-checker updates to catch inconsistencies in various b-tree items
  ("inspired by fuzzing tools")

- tracing events for b-tree locks

- qgroups+metadata relocation: last speed up patch, there should be no overhead
  with and without qgroups when balancing metadata


Git development repos
---------------------

  k.org: https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
  devel1: https://gitlab.com/kdave/btrfs-devel
  devel2: https://github.com/kdave/btrfs-devel


Usual points
------------

* the current patch queue (as is in misc-next) looks stable, so no big
  changes are going to be applied at this time. The usual exceptions are
  bugfixes or obvious cleanups.

* the base of the patches should be the last announced pull request,
  which is going to be named 'for-5.2' in my k.org tree.  Reviewed
  patches will be collected in a branch that's usually named 'misc-next'
  in my devel git repos and is part of the for-next at k.org git repo.

* merging of new patches to misc-next will be slow during the
  merge window, also because there's a btrfs-progs release scheduled

* everybody is encouraged to review and test other's patches
