Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bl2on0124.outbound.protection.outlook.com ([65.55.169.124]:16633
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751145AbbLUDRr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Dec 2015 22:17:47 -0500
From: "Langhorst, Brad" <Langhorst@neb.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: recover from multi-device filesystem 
Date: Mon, 21 Dec 2015 02:45:06 +0000
Message-ID: <CCE2FA8C-9352-4692-B40E-CCB005ECCBF5@neb.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi:

I just attempted a recover from a 6 device btrfs fs, but failed.

A bunch of data came back, but not the whole fileâ€¦
The "device 6 is missingâ€ (see below for transcript)  sounds like btrfs restore canâ€™t find the other disks.

Should I be using a UUID here somehow (didnâ€™t see anything in the docsâ€¦ but maybe)?

Thanks for any advice!


Brad


sudo ./btrfs restore -v -o -t 25606820544512  --path-regex ^/\(\|deer\(\|/masurca\(\|/quorum_mer_db.jf\)\)\)$ /dev/sdd1 ~/recover/
parent transid verify failed on 25606820544512 wanted 21614 found 21591
parent transid verify failed on 25606820544512 wanted 21614 found 21591
parent transid verify failed on 25606820544512 wanted 21614 found 21591
parent transid verify failed on 25606820544512 wanted 21614 found 21591
Ignoring transid failure
parent transid verify failed on 25606820560896 wanted 21591 found 21611
parent transid verify failed on 25606820560896 wanted 21591 found 21611
parent transid verify failed on 25606820560896 wanted 21591 found 21611
parent transid verify failed on 25606820560896 wanted 21591 found 21611
Ignoring transid failure
leaf parent key incorrect 25606820560896
Couldn't setup extent tree
parent transid verify failed on 25606820560896 wanted 21591 found 21611
Ignoring transid failure
leaf parent key incorrect 25606820560896
Couldn't setup device tree
Could not open root, trying backup super
warning, device 6 is missing
warning, device 7 is missing
bytenr mismatch, want=25606758596608, have=0
Couldn't read chunk root
Could not open root, trying backup super
warning, device 6 is missing
warning, device 7 is missing
bytenr mismatch, want=25606758596608, have=0
Couldn't read chunk root
Could not open root, trying backup super


â€”
Brad Langhorst, Ph.D.
Development Scientist
New England Biolabs

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
