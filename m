Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.mystoragebox.com ([173.234.39.99]:53810 "EHLO
	mail.mystoragebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062AbaIOUeP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 16:34:15 -0400
Received: from cpe-67-240-76-244.nycap.res.rr.com ([67.240.76.244] helo=[192.168.5.80])
	by mail.mystoragebox.com with esmtpsa (TLS1.0:ECDHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.83)
	(envelope-from <markm-lists@intellasoft.net>)
	id 1XTcyS-0002e9-EE
	for linux-btrfs@vger.kernel.org; Mon, 15 Sep 2014 16:34:12 -0400
Message-ID: <54174D44.9010105@intellasoft.net>
Date: Mon, 15 Sep 2014 16:34:12 -0400
From: Mark Murawski <markm-lists@intellasoft.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Cannot replace drive
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cartman {/etc/rc2.d} root# btrfs fi show /
Label: 'Root'  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
         Total devices 2 FS bytes used 7.43GiB
         devid    1 size 9.31GiB used 8.37GiB path /dev/sdg6
         devid    3 size 9.31GiB used 8.37GiB path /dev/sdd6

cartman {/etc/rc2.d} root# btrfs replace start 1 /dev/sdh6 /
cartman {/etc/rc2.d} root#

Sep 15 16:31:36 localhost kernel: BTRFS: dev_replace from /dev/sdg6 
(devid 1) to /dev/sdh6 started
Sep 15 16:31:42 localhost kernel: BTRFS: btrfs_scrub_dev(/dev/sdg6, 1, 
/dev/sdh6) failed -5


If i do a scrub on /, it will complete with no errors
