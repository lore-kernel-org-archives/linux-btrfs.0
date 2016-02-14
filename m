Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:36544 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbcBNVDQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 16:03:16 -0500
Received: from [192.168.0.32] (adsl.bouton.name [82.234.193.23])
	by mail.bouton.name (Postfix) with ESMTP id 428E8B943
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Feb 2016 22:03:15 +0100 (CET)
From: Lionel Bouton <lionel-subscription@bouton.name>
Subject: Auto-rebalancing script
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <56C0EB92.8050102@bouton.name>
Date: Sun, 14 Feb 2016 22:03:14 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm using this Ruby script to maintain my BTRFS filesystems and try to
avoid them getting in a position where they can't allocate space even
though there is still plenty of it.

http://pastebin.com/39567Dun

It seems to work well (it maintains dozens of BTRFS filesystems, running
balance on them on occasions and avoiding too much I/O stress if any
most of the time) but there might be bugs or inefficiencies so I publish
it in case it can be useful to others or benefit from criticism.

Lionel
