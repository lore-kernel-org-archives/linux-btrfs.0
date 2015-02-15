Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from port-92-195-78-184.dynamic.qsc.de ([92.195.78.184]:46041 "EHLO
	richtercloud.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbbBOI7a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Feb 2015 03:59:30 -0500
Received: from [192.168.178.20] (unknown [192.168.178.20])
	by richtercloud.de (Postfix) with ESMTPSA id 5CB678004D
	for <linux-btrfs@vger.kernel.org>; Sun, 15 Feb 2015 08:50:50 +0000 (UTC)
Message-ID: <54E05DCD.3050508@richtercloud.de>
Date: Sun, 15 Feb 2015 09:50:21 +0100
From: Karl-Philipp Richter <richter@richtercloud.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs check --init-csum-tree removes csums again
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
After running `btrfs check --init-csum-tree` 3.18.2 and 3.19-rc2 on a
btrfs all checksums are gone (thousands of line in the form of `no csum
found for inode X start Y` in `/var/log/kern.log`). I know that this
behavior (to delete all csums) was a stub in a dev version and remember
that it was fixed and that I even fixed a csum tree at one point. Could
someone please confirm and maybe even point me to a working version?

Any help or pointers are appreciated.

Best regards,
Kalle
