Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from psi.thgersdorf.net ([176.9.98.78]:57765 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab2JHTIK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 15:08:10 -0400
From: Dieter Ries <mail@dieterries.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: Dieter Ries <mail@dieterries.net>
Subject: [PATCH 0/4] Resend: btrfs-progs: Some cosmetic changes (mainly) to btrfsck
Date: Mon,  8 Oct 2012 21:07:46 +0200
Message-Id: <1349723270-12773-1-git-send-email-mail@dieterries.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I sent an earlier version of this patchset before, and didn't get any response,
so here is the next try:

This patch series implements some mainly cosmetic changes to.
btrfs-progs, most in btrfsck.

As this is my first contribution here, I'd kindly ask you for feedback,
and if work like this is appreciated in general.

Cheers,

Dieter

Dieter Ries (4):
  btrfs-progs: Remove redundant "Btrfs" string from version string
  btrfs-progs: btrfsck: Print which filesystem to be checked to stdout
  btrfs-progs: btrfsck: Print feedback about fscking to stdout.
  btrfs-progs: btrfsck: Remove binary error code output

 btrfsck.c  |   29 ++++++++++++++++++++++-------
 version.sh |    2 +-
 2 files changed, 23 insertions(+), 8 deletions(-)

-- 
1.7.3.GIT

