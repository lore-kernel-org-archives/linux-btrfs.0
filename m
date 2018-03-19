Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:41332 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754511AbeCSH1T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 03:27:19 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id BA3C1AC0127
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:27:12 +0900 (JST)
Received: from g01jpexchkw37.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 1191BBD645A
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:27:12 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v3 0/3] btrfs: Add three new unprivileged ioctls to allow
 normal users to call "sub list/show" etc.
Message-ID: <cef1bb9a-5a32-066b-e9f6-b0010803c8bf@jp.fujitsu.com>
Date: Mon, 19 Mar 2018 16:27:09 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

changelog:

v2-> v3
 - fix kbuild test bot warning
v1 -> v2
  - completely reimplement 1st/2nd ioctl to have user friendly api
  - various cleanup, remove unnecessary goto
===

This adds three new unprivileged ioctls:

1st patch: ioctl which returns subvolume information of ROOT_ITEM and ROOT_BACKREF
2nd patch: ioctl which returns subvolume information of ROOT_REF (without subvolume name)
3rd patch: user version of ino_lookup ioctl which also peforms permission check.

They will be used to implement user version of "subvolume list/show" etc in user tools.
See each commit log for more detals.

The rfc implementation of btrfs-progs can be found in the ML titled as follows: 
  [RFC PATCH v3 0/7] btrfs-progs: Allow normal user to call "subvolume list/show"


Tomohiro Misono (3):
  btrfs: Add unprivileged ioctl which returns subvolume information
  btrfs: Add unprivileged ioctl which returns subvolume's ROOT_REF
  btrfs: Add unprivileged version of ino_lookup ioctl

 fs/btrfs/ioctl.c           | 413 +++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h |  84 ++++++++++
 2 files changed, 497 insertions(+)

-- 
2.14.3

