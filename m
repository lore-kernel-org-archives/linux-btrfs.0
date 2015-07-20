Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:57145 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbbGTRKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jul 2015 13:10:10 -0400
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: out of space on big devices > 30tb
Message-Id: <ADB57FC2-77F1-466E-A609-4DC50434248A@profihost.ag>
Date: Mon, 20 Jul 2015 19:10:06 +0200
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

I get constantly no space messages friends m btrfs on big volumes. Btrfs balance always fixes it for 2-3 days. Now I'm in the process to recreate the fs. Are there any options I could pass to mods.btrfs which help to prevent this? Special use case heavy usage of cp reflink and modifications afterwards.

Kernel: 3.18, 4.1 or 4.2-rc2 same result

Greets,
Stefan

