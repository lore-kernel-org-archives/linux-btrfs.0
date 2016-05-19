Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31154 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbcESFNT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 01:13:19 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 0/3] btrfs-progs: fixes on top of latest integration branch
Date: Thu, 19 May 2016 13:13:11 +0800
Message-Id: <1463634794-591-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

  Your latest branch integration-20160517 is failing with
  make install, 1/3 will fix it. While here can you also
  apply 2/3 and 3/3 as below, however they aren't related
  though.

Thanks


Anand Jain (3):
  btrfs-progs: fix make install failure
  btrfs-progs: add clean-all to the usage
  btrfs-progs: clean up commands.h

 Makefile.in | 3 ++-
 commands.h  | 6 ------
 2 files changed, 2 insertions(+), 7 deletions(-)

-- 
2.7.0

