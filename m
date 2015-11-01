Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:23747 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbbKAUto (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Nov 2015 15:49:44 -0500
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        mfasheh@suse.de
Cc: jbacik@fb.com, Chris Mason <clm@fb.com>
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Regression in: [PATCH 4/4] btrfs: qgroup: account shared subtree
 during snapshot delete
Message-ID: <56367AE8.9030509@profihost.ag>
Date: Sun, 1 Nov 2015 21:49:44 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this one: http://www.spinics.net/lists/linux-btrfs/msg47377.html

adds a regression to my test systems with very large disks (30tb and 50tb).

btrfs balance is super slow afterwards while heavily making use of cp 
--reflink=always on big files (200gb - 500gb).

Sorry didn't know how to correctly reply to that "old" message.

Greets,
Stefan
