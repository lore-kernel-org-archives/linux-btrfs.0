Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:16504 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbbGKGqh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jul 2015 02:46:37 -0400
Message-ID: <55A0BBD7.5000400@profihost.ag>
Date: Sat, 11 Jul 2015 08:46:47 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: slowdown after one week
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

while using a 40TB btrfs partition for VM backups. I see a massive 
slowdown after around one week.

The backup task takes usally 2-3 hours. After one week it takes 20 
hours. If i umount and remount the btrfs volume it takes 2-3 hours again.

Kernel 4.1.1

Greets,
Stefan
