Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36394 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbbI2RK7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 13:10:59 -0400
Received: by wicgb1 with SMTP id gb1so158778305wic.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 10:10:58 -0700 (PDT)
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 00/11] using of calloc instead of malloc+memset
Date: Tue, 29 Sep 2015 19:10:35 +0200
Message-Id: <cover.1443546000.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1443459879.git.silvio.fricke@gmail.com>
References: <cover.1443459879.git.silvio.fricke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi btrfs,

please review my patches about switching from malloc with memset to calloc.
Thanks for that and eventual inclusion of my patches.

Silvio

Silvio Fricke (11):
  btrfs-progs: use calloc instead of malloc+memset for btrfs-image.c
  btrfs-progs: use calloc instead of malloc+memset for btrfs-list.c
  btrfs-progs: use calloc instead of malloc+memset for chunk-recover.c
  btrfs-progs: use calloc instead of malloc+memset for cmds-check.c
  btrfs-progs: use calloc instead of malloc+memset for disk-io.c
  btrfs-progs: use calloc instead of malloc+memset for extent_io.c
  btrfs-progs: use calloc instead of malloc+memset for mkfs.c
  btrfs-progs: use calloc instead of malloc+memset for qgroup.c
  btrfs-progs: use calloc instead of malloc+memset for quick-test.c
  btrfs-progs: use calloc instead of malloc+memset for volumes.c
  btrfs-progs: check: fix memset range

 btrfs-image.c   |  3 +--
 btrfs-list.c    |  9 +++------
 chunk-recover.c |  6 ++----
 cmds-check.c    | 12 ++++--------
 disk-io.c       |  7 ++-----
 extent_io.c     |  3 +--
 mkfs.c          |  3 +--
 qgroup.c        |  9 +++------
 quick-test.c    |  3 +--
 volumes.c       |  3 +--
 10 files changed, 19 insertions(+), 39 deletions(-)

-- 
2.5.3

