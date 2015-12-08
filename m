Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52435 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbbLHPGj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 10:06:39 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1a6Jqg-0004aF-Rs by authid <merlin>
	for <linux-btrfs@vger.kernel.org>; Tue, 08 Dec 2015 07:06:38 -0800
Date: Tue, 8 Dec 2015 07:06:38 -0800
From: Marc MERLIN <marc@merlins.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Scrub: no spae left on device
Message-ID: <20151208150638.GL27889@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Howdy,

Why would scrub need space and why would it cancel if there isn't enough of
it?
(kernel 4.3)

/etc/cron.daily/btrfs-scrub:
btrfs scrub start -Bd /dev/mapper/cryptroot
scrub device /dev/mapper/cryptroot (id 1) done
	scrub started at Mon Dec  7 01:35:08 2015 and finished after 258 seconds
	total bytes scrubbed: 130.84GiB with 0 errors
btrfs scrub start -Bd /dev/mapper/pool1
ERROR: scrubbing /dev/mapper/pool1 failed for device id 1 (No space left on device)
scrub device /dev/mapper/pool1 (id 1) canceled

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
