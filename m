Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64764 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab3JWWfF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 18:35:05 -0400
Received: from 3capp-gmx-bs58.server.lan ([172.19.170.142]) by
 mrigmx.server.lan (mrigmx001) with ESMTP (Nemesis) id
 0Ls6Bl-1VhizA1MZb-013rFg for <linux-btrfs@vger.kernel.org>; Thu, 24 Oct 2013
 00:35:03 +0200
MIME-Version: 1.0
Message-ID: <trinity-4c8c9264-83fb-4016-b1be-434846c23335-1382567703215@3capp-gmx-bs58>
From: "Martin Fahr" <maf@gmx.eu>
To: linux-btrfs@vger.kernel.org
Subject: unrecoverable btrfs
Content-Type: text/plain; charset=UTF-8
Date: Thu, 24 Oct 2013 00:35:03 +0200 (CEST)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 

I have a btrfs filesystem on a USB stick. A few days ago, my cell phone was right next to the stick while both (teh stick and the phone) were in use. I suppose the irradiation from the phone must have interacted badly with the stick. The syslog showed some messages from the btrfs modules complaining about something. Unfortunately, I can't recover any of the messages. I was not able to mount the filesystem again after. Not even -recover would help. I tried to recover some data from the stick, but would not get anything either. None of the rescue tools work. However, I got the feeling there are only a few blocks damaged. Is there anything else I can do to recover the data? Is there anything I could do to help debug the problem?


Following is what I tried to repair the filesystem or to recover data from it. If you're interested in the full output, please let me know. 

Thanks in advance

Martin


#> btrfsck /dev/sdc2
parent transid verify failed on 38158336 wanted 96844 found 97302
parent transid verify failed on 38158336 wanted 96844 found 97302
parent transid verify failed on 38158336 wanted 96844 found 97302
parent transid verify failed on 38158336 wanted 96844 found 97302
Ignoring transid failure
parent transid verify failed on 277680128 wanted 97109 found 97353
parent transid verify failed on 277680128 wanted 97109 found 97353
.... and many more of these ending with....
Ignoring transid failure
leaf parent key incorrect 143196160
parent transid verify failed on 143196160 wanted 96931 found 97350
Ignoring transid failure
leaf parent key incorrect 143196160
btrfsck: cmds-check.c:2063: check_owner_ref: Assertion `!(rec->is_root)' failed.


#>btrfs-find-root /dev/sdc2
Well block 4194304 seems great, but generation doesn't match, have=2, want=97112 level 0
Well block 4206592 seems great, but generation doesn't match, have=3, want=97112 level 0
Well block 38739968 seems great, but generation doesn't match, have=97302, want=97112 level 1
Well block 38866944 seems great, but generation doesn't match, have=97302, want=97112 level 0
Well block 146984960 seems great, but generation doesn't match, have=97350, want=97112 level 1
Well block 146997248 seems great, but generation doesn't match, have=97350, want=97112 level 0
Well block 147001344 seems great, but generation doesn't match, have=97350, want=97112 level 0
Well block 147120128 seems great, but generation doesn't match, have=97350, want=97112 level 0
Well block 171458560 seems great, but generation doesn't match, have=97351, want=97112 level 1
Well block 200921088 seems great, but generation doesn't match, have=97186, want=97112 level 0
Well block 223600640 seems great, but generation doesn't match, have=97352, want=97112 level 1
Well block 223608832 seems great, but generation doesn't match, have=97352, want=97112 level 0
Well block 223612928 seems great, but generation doesn't match, have=97352, want=97112 level 0
Well block 223621120 seems great, but generation doesn't match, have=97352, want=97112 level 0
Well block 223772672 seems great, but generation doesn't match, have=97352, want=97112 level 0
Super think's the tree root is at 278663168, chunk root 20971520
Found tree root at 278663168 gen 97112 level 1


#>btrfs restore -t 278663168 /dev/sdc2 /tmp
parent transid verify failed on 38158336 wanted 96844 found 97302
parent transid verify failed on 38158336 wanted 96844 found 97302
parent transid verify failed on 38158336 wanted 96844 found 97302
parent transid verify failed on 38158336 wanted 96844 found 97302
Ignoring transid failure
parent transid verify failed on 277680128 wanted 97109 found 97353
parent transid verify failed on 277680128 wanted 97109 found 97353
parent transid verify failed on 277680128 wanted 97109 found 97353
parent transid verify failed on 277680128 wanted 97109 found 97353
Ignoring transid failure
parent transid verify failed on 278220800 wanted 97110 found 97394
parent transid verify failed on 278220800 wanted 97110 found 97394
parent transid verify failed on 278220800 wanted 97110 found 97394
parent transid verify failed on 278220800 wanted 97110 found 97394
Ignoring transid failure
parent transid verify failed on 279695360 wanted 97353 found 97113
parent transid verify failed on 279695360 wanted 97353 found 97113
parent transid verify failed on 279695360 wanted 97353 found 97113
parent transid verify failed on 279695360 wanted 97353 found 97113
Ignoring transid failure
leaf parent key incorrect 279695360
Error searching -1


#>btrfs chunk-recover /dev/sdc2
All Devices:
	Device: id = 1, name = /dev/sdd2

DEVICE SCAN RESULT:
Filesystem Information:
	sectorsize: 4096
	leafsize: 4096
	tree root generation: 97112
	chunk root generation: 1311

All Devices:
	Device: id = 1, name = /dev/sdd2

All Block Groups:
	Block Group: start = 0, len = 4194304, flag = 2
	Block Group: start = 4194304, len = 8388608, flag = 4
	Block Group: start = 12582912, len = 8388608, flag = 1
	Block Group: start = 20971520, len = 8388608, flag = 22
	Block Group: start = 29360128, len = 1073741824, flag = 24
	Block Group: start = 1103101952, len = 1073741824, flag = 1
	Block Group: start = 2176843776, len = 1073741824, flag = 1
	Block Group: start = 3250585600, len = 1073741824, flag = 1
	Block Group: start = 4324327424, len = 1073741824, flag = 1
	Block Group: start = 5398069248, len = 1073741824, flag = 1
	Block Group: start = 6471811072, len = 1073741824, flag = 1
	Block Group: start = 7545552896, len = 1073741824, flag = 1
	Block Group: start = 8619294720, len = 1073741824, flag = 1
	Block Group: start = 9693036544, len = 1073741824, flag = 1
	Block Group: start = 10766778368, len = 1073741824, flag = 1
	Block Group: start = 11840520192, len = 1073741824, flag = 1
	Block Group: start = 12914262016, len = 1073741824, flag = 1
	Block Group: start = 13988003840, len = 1073741824, flag = 1
	Block Group: start = 15061745664, len = 1073741824, flag = 1
	Block Group: start = 16135487488, len = 1073741824, flag = 1
	Block Group: start = 17209229312, len = 1073741824, flag = 1
	Block Group: start = 18282971136, len = 1073741824, flag = 1
	Block Group: start = 19356712960, len = 1073741824, flag = 1
	Block Group: start = 20430454784, len = 1073741824, flag = 1
	Block Group: start = 21504196608, len = 1073741824, flag = 1
	Block Group: start = 22577938432, len = 1073741824, flag = 1
	Block Group: start = 23651680256, len = 1073741824, flag = 1
	Block Group: start = 24725422080, len = 1073741824, flag = 1
	Block Group: start = 25799163904, len = 1073741824, flag = 1
	Block Group: start = 26872905728, len = 1073741824, flag = 1
	Block Group: start = 27946647552, len = 1073741824, flag = 1
	Block Group: start = 29020389376, len = 803209216, flag = 1

All Chunks:
	Chunk: start = 0, len = 4194304, type = 2, num_stripes = 1
	    Stripes list:
	    [ 0] Stripe: devid = 1, offset = 0
	Chunk: start = 4194304, len = 8388608, type = 4, num_stripes = 1
	    Stripes list:
	    [ 0] Stripe: devid = 1, offset = 4194304

.... many more of these ....

	Chunk: start = 29020389376, len = 803209216, type = 1, num_stripes = 1
	    Stripes list:
	    [ 0] Stripe: devid = 1, offset = 30102519808

All Device Extents:
	Device extent: devid = 1, start = 0, len = 4194304, chunk offset = 0
	Device extent: devid = 1, start = 4194304, len = 8388608, chunk offset = 4194304
	Device extent: devid = 1, start = 12582912, len = 8388608, chunk offset = 12582912

CHECK RESULT:
Healthy Chunks:
  Chunk: start = 0, len = 4194304, type = 2, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 0
      Block Group: start = 0, len = 4194304, flag = 2
      Device extent list:
          [ 0]Device extent: devid = 1, start = 0, len = 4194304, chunk offset = 0
  Chunk: start = 4194304, len = 8388608, type = 4, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 4194304
      Block Group: start = 4194304, len = 8388608, flag = 4
      Device extent list:
          [ 0]Device extent: devid = 1, start = 4194304, len = 8388608, chunk offset = 4194304
  Chunk: start = 12582912, len = 8388608, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 12582912
      Block Group: start = 12582912, len = 8388608, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 12582912, len = 8388608, chunk offset = 12582912
Bad Chunks:
  Chunk: start = 20971520, len = 8388608, type = 22, num_stripes = 2
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 20971520
      [ 1] Stripe: devid = 1, offset = 29360128
      Block Group: start = 20971520, len = 8388608, flag = 22
      No device extent.

... many more of these....

  Chunk: start = 29020389376, len = 803209216, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 30102519808
      Block Group: start = 29020389376, len = 803209216, flag = 1
      No device extent.

Total Chunks:	32
  Heathy:	3
  Bad:	29

Orphan Block Groups:

Orphan Device Extents:
