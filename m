Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:41558 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3GISuV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jul 2013 14:50:21 -0400
Received: by mail-wg0-f43.google.com with SMTP id z11so5025017wgg.34
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jul 2013 11:50:20 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 0/2] Remove duplicated and useless code in cmds-restore
Date: Tue,  9 Jul 2013 19:49:52 +0100
Message-Id: <1373395794-29140-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following patch series are just a cleanup for cmds-restore.c,
removing some duplicated code and code that never gets executed.

Filipe David Borba Manana (2):
  Btrfs-progs: remove duplicated code in cmds-restore.c
  Btrfs-progs: remove unneeded leaf checks in cmds-restore

 cmds-restore.c |  170 ++++++++++++--------------------------------------------
 1 file changed, 37 insertions(+), 133 deletions(-)

-- 
1.7.9.5

