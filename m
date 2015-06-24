Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5376 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbbFXQJv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 12:09:51 -0400
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t5OG9nbs012962
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 09:09:50 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1v7yn200v4-3
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 09:09:50 -0700
From: Omar Sandoval <osandov@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: Omar Sandoval <osandov@fb.com>
Subject: [PATCH 0/2] btrfs device remove alias
Date: Wed, 24 Jun 2015 09:09:15 -0700
Message-ID: <cover.1435161735.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The opposite of btrfs device add is btrfs device delete. This really
should be btrfs device remove.

Changes from v1:
- Add support for flags to cmd_struct and a CMD_ALIAS flag which only
  prints the one-line usage string
- Rearrange the command wrappers in a way that could be made generic if
  needed

Thanks!

Omar Sandoval (2):
  btrfs-progs: replace struct cmd_group->hidden with flags
  btrfs-progs: alias btrfs device delete to btrfs device remove

 Documentation/btrfs-device.asciidoc |  5 ++++-
 cmds-device.c                       | 35 ++++++++++++++++++++++++++---------
 cmds-filesystem.c                   |  2 +-
 commands.h                          |  9 +++++++--
 help.c                              | 12 +++++++-----
 5 files changed, 45 insertions(+), 18 deletions(-)

-- 
2.4.4

