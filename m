Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:25982 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdJPEzq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 00:55:46 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 25E56AC03DD
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 13:55:39 +0900 (JST)
Received: from G01JPEXCHKW16.g01.fujitsu.local (G01JPEXCHKW16.g01.fujitsu.local [10.0.194.55])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 6D79C6923B9
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 13:55:38 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v3 0/2] btrfs-progs: doc: update btrfs device remove
Message-ID: <7dcb7f01-ce39-18a6-9a16-9230b76baf77@jp.fujitsu.com>
Date: Mon, 16 Oct 2017 13:55:34 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This updates help/doc of "btrfs device remove".

First patch adds the explanation that delete is the alias of remove to help message.
Second patch adds the description of "remove missing", which is currently only
written in wikipage, and example of device removal.

v1->v2:
 split the patch and updates the messages
v2->v3
 withdrow "remove missing-all" feature
 
Tomohiro Misono (2):
	btrfs-progs: device: add description of alias to help message
	btrfs-progs: doc: add description of missing and example of device remove

 Documentation/btrfs-device.asciidoc | 20 +++++++++++++++++++-
 cmds-device.c                       | 9 +++++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

-- 
2.9.5

