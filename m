Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:31321 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751549AbdJTBlw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 21:41:52 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 639E4AC019A
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 10:41:47 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id B9245328846
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 10:41:46 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v4 0/2] btrfs-progs: doc: update btrfs device remove
Message-ID: <89bcb689-586e-f69b-2f4f-ac5f99765924@jp.fujitsu.com>
Date: Fri, 20 Oct 2017 10:41:42 +0900
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
v3->v4
 add more description about missing to man

Tomohiro Misono (2):
  btrfs-progs: device: add description of alias to help message
  btrfs-progs: doc: add description of missing and example of device
    remove

 Documentation/btrfs-device.asciidoc | 24 +++++++++++++++++++++++-
 cmds-device.c                       | 10 +++++++++-
 2 files changed, 32 insertions(+), 2 deletions(-)

-- 
2.9.5

