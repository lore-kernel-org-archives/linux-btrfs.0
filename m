Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:51591 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbbEDH2X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 May 2015 03:28:23 -0400
Message-ID: <55471F95.5040303@profihost.ag>
Date: Mon, 04 May 2015 09:28:21 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs send slow / how to improve performance
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

i was trying to clone / copy a 4TB Raid 50 Array (mdadm) using btrfs send.

But btrfs send is sending with just 2MB/s. Is there any way to speed up
btrfs send?

There's nearly no I/O while running btrfs send but 100% CPU Load of the
btrfs command.

Kernel: 3.18.12
btrfs progs: 3.19.1

Greets,
Stefan
