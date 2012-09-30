Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from psi.thgersdorf.net ([176.9.98.78]:44043 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab2I3OYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 10:24:47 -0400
From: Dieter Ries <mail@dieterries.net>
To: linux-btrfs@vger.kernel.org
Cc: Dieter Ries <mail@dieterries.net>
Subject: [PATCH 0/3] btrfs-progs: Some cosmetic changes (mainly) to btrfsck
Date: Sun, 30 Sep 2012 16:18:27 +0200
Message-Id: <1349014710-16089-1-git-send-email-mail@dieterries.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this patch series implements some mainly cosmetic changes to 
btrfs-progs, most in btrfsck.

As this is my first contribution here, I'd kindly ask you for feedback,
and if work like this is appreciated in general.

Cheers,

Dieter

Dieter Ries (3):
  btrfs-progs: Remove redundant "Btrfs" string from version string
  btrfs-progs: btrfsck: Print which filesystem to be checked to stdout
  btrfs-progs: btrfsck: Print feedback about fscking to stdout.

 btrfsck.c  |   21 ++++++++++++++++-----
 version.sh |    2 +-
 2 files changed, 17 insertions(+), 6 deletions(-)

-- 
1.7.3.GIT

