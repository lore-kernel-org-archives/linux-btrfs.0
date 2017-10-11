Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:52262 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752099AbdJKCOe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 22:14:34 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id A1072AC00B1
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 11:14:30 +0900 (JST)
Received: from G01JPEXCHKW17.g01.fujitsu.local (G01JPEXCHKW17.g01.fujitsu.local [10.0.194.56])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id EEB6DBD6728
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 11:14:29 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v2 0/3] btrfs-progs: device: update btrfs device remove
 missing
Message-ID: <bb58e829-77d4-1bd1-4021-2db996809a6e@jp.fujitsu.com>
Date: Wed, 11 Oct 2017 11:14:26 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This series updates "btrfs device remove missing".

Currently, the document lacks the description of "remove missing" which is
written only in wikipage. First and second patch updates the documents.
Third patch introduces new keyword "missing-all" to remove the all missing
devices at once for improving usability.

changelog:
v1->v2:
 split the patch and add missing-all
 
Tomohiro Misono (3):
	btrfs-progs: device: add description of alias to help message
	btrfs-progs: doc: add description of missing and example of device remove
	btrfs-progs: device: add remove missing-all

 Documentation/btrfs-device.asciidoc | 20 +++++++++++++++++++-
 cmds-device.c                       | 32 +++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 2 deletions(-)

-- 
2.9.5

