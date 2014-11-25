Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s32.hotmail.com ([65.55.116.43]:57685 "EHLO
	BLU004-OMC1S32.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbaKYLEW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 06:04:22 -0500
Message-ID: <BLU436-SMTP1997275109CCFECC0054843AB730@phx.gbl>
Date: Tue, 25 Nov 2014 11:04:16 +0000
From: Boris Chernov <aqs1024@hotmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Changing label few times killed filesystem?
References: <BLU436-SMTP7537F1DDEF63F43667E45CAB770@phx.gbl>	<20141121093543.6685cbe5@natsu>	<BLU437-SMTP10930A5E18E8322A8C259AAB750@phx.gbl> <pan$f37fb$4727340$23550eda$69bcec61@cox.net>
In-Reply-To: <pan$f37fb$4727340$23550eda$69bcec61@cox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-11-24 02:46, Duncan wrote
 > if you were using gmane's web service, that explains things as 
weaverd, the process
 > that does the threading on the web side, was down for some days
     Yes, I have used gmane blog. Good to know it is not down anymore.

     Back on topic. Even after updating to the latest version, btrfsck 
or any of its options including --repair still do not work. Does anyone 
know what "Assertion `rec->is_root` failed" means? Is it worth trying to 
compile my own version of btrfsck without this assertion?
     With or without --repair option, it looks like this assertion stops 
btrfsck very early, preventing btrfsck from checking the filesystem or 
attempting to repair it.

# btrfsck /dev/sdb1
Checking filesystem on /dev/sdb1
UUID: 787e3bc1-7583-4bd8-a52e-e57fd7fc9243
checking extents
cmds-check.c:2645: check_owner_ref: Assertion `rec->is_root` failed.
btrfs check[0x41a081]
btrfs check[0x41a0a5]
btrfs check[0x409783]
btrfs check[0x40a45e]
btrfs check[0x41bfa9]
btrfs check[0x40b46a]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7fb275f24b45]
btrfs check[0x40b497]

# btrfsck --repair /dev/sdb1
enabling repair mode
Fixed 0 roots.
Checking filesystem on /dev/sdb1
UUID: 787e3bc1-7583-4bd8-a52e-e57fd7fc9243
checking extents
cmds-check.c:2645: check_owner_ref: Assertion `rec->is_root` failed.
btrfs check[0x41a081]
btrfs check[0x41a0a5]
btrfs check[0x409783]
btrfs check[0x40a45e]
btrfs check[0x41bfa9]
btrfs check[0x40b46a]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7fbc5b8dab45]
btrfs check[0x40b497]
