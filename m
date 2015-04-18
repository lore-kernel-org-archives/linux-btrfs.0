Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.univ-lille1.fr ([193.49.225.20]:42379 "EHLO
	smtp02.univ-lille1.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbbDRHqD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Apr 2015 03:46:03 -0400
Message-ID: <55320BAE.1030007@gnieh.org>
Date: Sat, 18 Apr 2015 09:45:50 +0200
From: Martin Monperrus <martin.monperrus@gnieh.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: How to repair a BTRFS block?
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Btrfs developers,

For some unknown reasons, my BTRFS filesystem is corrupted. dmesg prints

|BTRFS critical (device sda2): corrupt leaf, slot offset bad:
block=43231330304,root=1, slot=47|

(more than 1000x in the dmesg trace).

btrfs check --repair fails with:

read block failed check_tree_block
incorrect offset 12725 2298746482
items overlap, can't fix
cmds_check.c:2918: fix_item_offset: Assertion 'ret' failed

How to list the files in block #43231330304 affected by the corruption?
How to repair block #43231330304?

Best regards,

--Martin

