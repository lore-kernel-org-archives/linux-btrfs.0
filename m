Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s33.hotmail.com ([65.55.116.44]:52515 "EHLO
	BLU004-OMC1S33.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240AbaKYQqo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 11:46:44 -0500
Message-ID: <BLU436-SMTP14172AF9A2DA601C46C2DA0AB730@phx.gbl>
Date: Tue, 25 Nov 2014 16:46:38 +0000
From: Boris Chernov <aqs1024@hotmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Changing label few times killed filesystem?
References: <BLU436-SMTP7537F1DDEF63F43667E45CAB770@phx.gbl>	<20141121093543.6685cbe5@natsu>	<BLU437-SMTP10930A5E18E8322A8C259AAB750@phx.gbl> <pan$f37fb$4727340$23550eda$69bcec61@cox.net>
In-Reply-To: <pan$f37fb$4727340$23550eda$69bcec61@cox.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


     In attempt to get more information, I have commented out 
BUG_ON(rec->is_root) in cmds-check.c to let btrfsck check my file system 
without failing on this assertion. Below you can see the output. I would 
appreciate any help or ideas...

# btrfsck /dev/sdb1  # Full log can be downloaded here: 
http://pastebin.com/D68vr69J
Checking filesystem on /dev/sdb1
UUID: 787e3bc1-7583-4bd8-a52e-e57fd7fc9243
checking extents
...
ref mismatch on [20987904 16384] extent item 0, found 1
Backref 20987904 parent 3 root 3 not found in extent tree
backpointer mismatch on [20987904 16384]
owner ref check failed [20987904 16384]
...messages like these repeat many times, download full log to see them 
all...
ref mismatch on [29540352 16384] extent item 0, found 1
Backref 29540352 parent 18446744073709551607 root 18446744073709551607 
not found in extent tree
backpointer mismatch on [29540352 16384]
owner ref check failed [29540352 16384]
...
Errors found in extent allocation tree or chunk allocation
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 5 root dir 256 not found
found 409600 bytes used err is 1
total csum bytes: 0
total tree bytes: 49152
total fs tree bytes: 0
total extent tree bytes: 16384
btree space waste bytes: 48246
file data blocks allocated: 0
  referenced 0
Btrfs v3.17
