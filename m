Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:48441 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab3AVUvj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 15:51:39 -0500
Received: from eastrmimpo306 ([68.230.241.238]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130122205139.TCEI17456.eastrmfepo201.cox.net@eastrmimpo306>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 22 Jan 2013 15:51:39 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>
Subject: [PATCH] Fix Makefile for gzip
Date: Tue, 22 Jan 2013 15:51:18 -0500
Message-Id: <1358887879-6297-1-git-send-email-gene@czarc.net>
In-Reply-To: <20130121164628.GK19967@twin.jikos.cz>
References: <20130121164628.GK19967@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the patch that "6 of 13" should have been and was not.

Here is the original posting:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg19264.html

Christian Hesse (1):
  fix btrfs-progs build

 man/Makefile | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

-- 
1.8.1

