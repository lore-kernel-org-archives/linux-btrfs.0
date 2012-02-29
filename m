From: asj <anand.jain@oracle.com>
Subject: [RFC] [PATCH] Add btrfs autosnap feature
Date: Wed, 29 Feb 2012 10:59:35 +0800
Message-ID: <1330484376-16178-1-git-send-email-anand.jain@oracle.com>
References: <n>
Cc: hugo@carfax.org.uk, chris.mason@oracle.com,
	anand jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <n>
List-ID: <linux-btrfs.vger.kernel.org>

From: anand jain <anand.jain@oracle.com>

Anand Jain (1):
  [RFC] Add btrfs autosnap feature

 Makefile     |    6 +-
 autosnap.c   | 1553 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 autosnap.h   |   81 +++
 btrfs-list.c |  140 +++++-
 btrfs.c      |   46 ++-
 btrfs_cmds.c |  186 +++++++-
 btrfs_cmds.h |    3 +-
 scrub.c      |    1 +
 8 files changed, 1982 insertions(+), 34 deletions(-)
 create mode 100644 autosnap.c
 create mode 100644 autosnap.h

