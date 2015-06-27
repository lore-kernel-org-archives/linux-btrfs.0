Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:51395 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbbF0PcD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jun 2015 11:32:03 -0400
Message-ID: <558EC1F4.1050301@profihost.ag>
Date: Sat, 27 Jun 2015 17:32:04 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: clm@fb.com
Subject: kernel 4.1: no space left on device
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

while having some big btrfs volumes (44TB + 37TB).

I see on a regular basis the "no space left on device" message. I'm only 
able to "fix" this. By running btrfs balance AND unmounting and 
remounting the btrfs volume.

Is there any way to debug / workaround this one?

Greets,
Stefan
