Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:53001 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab3A2XHj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 18:07:39 -0500
Received: from twilight.demius.net (c-297271d5.013-195-6c756e10.cust.bredbandsbolaget.se [213.113.114.41])
	by nitrogen.vapor.com (Postfix) with ESMTPSA id 4741E40C14F
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 00:07:37 +0100 (CET)
Received: from lori.pomac.com (lori.local [10.0.0.13])
	by twilight.demius.net (Postfix) with ESMTP id 7BE878E04E5
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 00:07:35 +0100 (CET)
From: Ian Kumlien <pomac@demius.net>
To: linux-btrfs@vger.kernel.org
Subject: [RFC] Move btrfsck in to the btrfs command
Date: Wed, 30 Jan 2013 00:03:52 +0100
Message-Id: <1359500633-7219-1-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

NOTE: in order to apply this patch you should:
	git mv btrfsck.c cmd-fsck.c

This patch moves btrfsck in to "btrfs fsck".

It also adds support for symlinks to the btrfs binary to
retain compablity, =)

I think something should be done to the help description but i'm not
sure what... Anyway, feedback is welcome.

