Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A03C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 14:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4228020874
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 14:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732472AbeLQOZc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 09:25:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:50924 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732468AbeLQOZa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 09:25:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 11823AECF
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 14:25:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DBC93DA781; Mon, 17 Dec 2018 15:25:03 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.cz>
Subject: Next btrfs development cycle open - 4.21
Date:   Mon, 17 Dec 2018 15:24:58 +0100
Message-Id: <20181217142458.9486-1-dsterba@suse.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: David Sterba <dsterba@suse.cz>

Hi,

a friendly reminder of the timetable and what's expected at this phase.

4.19 - current
4.20 - upcoming, urgent regression fixes only
4.21 - development closed, pull request in prep, fixes or regressions only
4.22 - development open, until 4.21-rc5 (at least)

(https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Development_schedule)


Current status
--------------

The pull request for 4.21 will be sent on Wednesday 2018-12-19 because of the
end of year holiday timing and merge window start. This is a hard freeze for
patches that are not in for-next, small updates are pending.

My plan is to pull the 'enospc fixes' branch from Josef, as there are no
significant code changes planned. If this does not work, the fixes will go as
-rc updates.

The base of the pull request branch is misc-next, not yet forked as misc-4.21.


Hilights of 4.20 changes
------------------------

The more detailed description will be in the pull request, brief summary:

* swapfile support

* faster UUID change (incompatible change), does not need to rewrite all
  metadata blocks, only stores the new one in the superblock

* balance prints the filter options to system log

* slightly faster filesystem balance, skips initial phase that tried to make
  some space by shrink/grow


Git development repos
---------------------

  k.org: https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
  devel1: https://gitlab.com/kdave/btrfs-devel
  devel2: https://github.com/kdave/btrfs-devel

Note: git repository at repo.or.cz is discouraged from use

The devel repos should be identical regarding the main development branches
like misc-next or for-next-YYYYMMDD.
