Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52343 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762044Ab3IEGwH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Sep 2013 02:52:07 -0400
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id DD0303EE10C
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:52:05 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id CD99245DE56
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:52:05 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id B597E45DE54
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:52:05 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id A93FCE08001
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:52:05 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 5C8BC1DB8049
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:52:05 +0900 (JST)
Message-ID: <522829F5.5050405@jp.fujitsu.com>
Date: Thu, 05 Sep 2013 15:51:33 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: chris.mason@fusionio.com
Subject: [PATCH v2 0/3] btrfs-progs: prevent mkfs from aborting with small
 volume
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here are 3 patches to avoid undesired aborts of mkfs.btrfs.
These are based on top of Chris's btrfs-progs.git:

  git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

Thanks,
H.Seto


Hidetoshi Seto (3):
      btrfs-progs: error if device for mkfs is too small
      btrfs-progs: error if device have no space to make primary chunks
      btrfs-progs: calculate available blocks on device properly

 ctree.h   |    8 +++++
 mkfs.c    |   23 +++++++++++++
 volumes.c |  104 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 129 insertions(+), 6 deletions(-)


