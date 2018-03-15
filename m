Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:56815 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbeCOIKC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 04:10:02 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id A4A9FAC00C7
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 17:09:57 +0900 (JST)
Received: from G01JPEXCHYT13.g01.fujitsu.local (G01JPEXCHYT13.g01.fujitsu.local [10.128.194.52])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 070CD58436C
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 17:09:57 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v2 0/3] btrfs: Add three new unprivileged ioctls to allow
 normal users to call "sub list/show" etc.
Message-ID: <d185536f-a946-626e-6b7a-72f743a45b90@jp.fujitsu.com>
Date: Thu, 15 Mar 2018 17:09:52 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

changelog:
v1 -> v2
  - completely reimplement 1st/2nd ioctl to have user friendly api
  - various cleanup, remove unnecessary goto
===

This adds three new unprivileged ioctls:

1st patch: ioctl which returns subvolume information of ROOT_ITEM and ROOT_BACKREF
2nd patch: ioctl which returns subvolume information of ROOT_REF (without subvolume name)
3rd patch: user version of ino_lookup ioctl which also peforms permission check.

They will be used to implement user version of "subvolume list/show" etc in user tools.
See each commit log for more details.

The rfc implementation of btrfs-progs can be found in the ML titled as follows: 
  [RFC PATCH v2 0/8] btrfs-progs: Allow normal user to call "subvolume list/show"

Tomohiro Misono (3):
  btrfs: Add unprivileged ioctl which returns subvolume information
  btrfs: Add unprivileged ioctl which returns subvolume's ROOT_REF
  btrfs: Add unprivileged version of ino_lookup ioctl

 fs/btrfs/ioctl.c           | 413 +++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h |  84 ++++++++++
 2 files changed, 497 insertions(+)

-- 
2.14.3

