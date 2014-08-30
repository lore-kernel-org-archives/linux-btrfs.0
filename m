Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:52837 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751007AbaH3MsQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Aug 2014 08:48:16 -0400
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: linux-btrfs@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH 0/2] Build system fixes/improvements
Date: Sat, 30 Aug 2014 14:48:08 +0200
Message-Id: <1409402890-22860-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Here are two patches that we have in the Buildroot embedded Linux
build system against btrfs-progs. The first patch allows to disable
the build and installation of the docmentation, the second patch
improves static building and installation.

Thanks,

Thomas

Gustavo Zacarias (1):
  Add support for DISABLE_DOCUMENTATION

Thomas Petazzoni (1):
  Improve static building and installation

 Makefile | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

-- 
2.0.0

