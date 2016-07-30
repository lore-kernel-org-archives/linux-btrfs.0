Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay03.ispgateway.de ([80.67.31.41]:42731 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbcG3Mdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jul 2016 08:33:49 -0400
Received: from p4fce2116.dip0.t-ipconnect.de ([79.206.33.22] helo=[127.0.0.1])
	by smtprelay03.ispgateway.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
	(Exim 4.84)
	(envelope-from <hendrik@friedels.name>)
	id 1bTTSb-0000j2-39
	for linux-btrfs@vger.kernel.org; Sat, 30 Jul 2016 14:33:45 +0200
From: "Hendrik Friedel" <hendrik@friedels.name>
To: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Subject: bad tree blcok start & faild to read chunk root
Date: Sat, 30 Jul 2016 12:33:38 +0000
Message-Id: <em96468365-7c33-4ccc-9530-ce73be9e87a8@laptophendrik>
Reply-To: "Hendrik Friedel" <hendrik@friedels.name>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

from this https://www.spinics.net/lists/linux-btrfs/msg57405.html
I still have damaged btrf file system (the partition was recovered. 
Thanks Chris).

When mounting, I get:
[15681.255356] BTRFS info (device sda1): disk space caching is enabled
[15681.255690] BTRFS error (device sda1): bad tree block start 0 
20987904
[15681.255786] BTRFS error (device sda1): bad tree block start 0 
20987904
[15681.255805] BTRFS: failed to read chunk root on

So I ran chunk-recover (output below).
Total Chunks:           5
  Recoverable:          0
  Unrecoverable:        5

Is there anything else, I can do, or is that it?

Regards,
Hendrik

root@homeserver:~# btrfs rescue chunk-recover -v /dev/sda1
All Devices:
        Device: id = 1, name = /dev/sda1

Scanning: DONE in dev0
DEVICE SCAN RESULT:
Filesystem Information:
        sectorsize: 4096
        leafsize: 16384
        tree root generation: 22444670
        chunk root generation: 233419

All Devices:
        Device: id = 1, name = /dev/sda1

All Block Groups:
        Block Group: start = 7776239616, len = 1073741824, flag = 1
        Block Group: start = 61496885248, len = 536870912, flag = 24
        Block Group: start = 62033756160, len = 536870912, flag = 24
        Block Group: start = 71697432576, len = 1073741824, flag = 1
        Block Group: start = 102835945472, len = 1073741824, flag = 1

All Chunks:

All Device Extents:

CHECK RESULT:
Recoverable Chunks:
Unrecoverable Chunks:
  Chunk: start = 7776239616, len = 1073741824, type = 1, num_stripes = 0
      Stripes list:
      Block Group: start = 7776239616, len = 1073741824, flag = 1
      No device extent.
  Chunk: start = 62033756160, len = 536870912, type = 24, num_stripes = 0
      Stripes list:
      Block Group: start = 62033756160, len = 536870912, flag = 24
      No device extent.
  Chunk: start = 61496885248, len = 536870912, type = 24, num_stripes = 0
      Stripes list:
      Block Group: start = 61496885248, len = 536870912, flag = 24
      No device extent.
  Chunk: start = 71697432576, len = 1073741824, type = 1, num_stripes = 0
      Stripes list:
      Block Group: start = 71697432576, len = 1073741824, flag = 1
      No device extent.
  Chunk: start = 102835945472, len = 1073741824, type = 1, num_stripes = 
0
      Stripes list:
      Block Group: start = 102835945472, len = 1073741824, flag = 1
      No device extent.

Total Chunks:           5
  Recoverable:          0
  Unrecoverable:        5

Orphan Block Groups:

Orphan Device Extents:

Couldn't map the block 62034313216
No mapping for 62034313216-62034329600
Couldn't map the block 62034313216
bytenr mismatch, want=62034313216, have=0
Couldn't read tree root
open with broken chunk error
Chunk tree recovery failed


---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

