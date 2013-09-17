Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from efeu.mur.at ([89.106.208.66]:48155 "EHLO efeu.mur.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab3IQKvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 06:51:18 -0400
Received: from localhost (localhost [127.0.0.1])
	by efeu.mur.at (Postfix) with ESMTP id E98BD220BE
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 12:51:16 +0200 (CEST)
Received: from efeu.mur.at ([127.0.0.1])
	by localhost (efeu.mur.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id pL0LSt8A12gm for <linux-btrfs@vger.kernel.org>;
	Tue, 17 Sep 2013 12:51:16 +0200 (CEST)
Received: from [IPv6:2a02:3e0:1:0:eea8:6bff:fef9:7180] (unknown [IPv6:2a02:3e0:1:0:eea8:6bff:fef9:7180])
	by efeu.mur.at (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 12:51:16 +0200 (CEST)
Message-ID: <5238343F.3020802@mur.at>
Date: Tue, 17 Sep 2013 12:51:43 +0200
From: =?UTF-8?B?Sm9naSBIb2Ztw7xsbGVy?= <jogi@mur.at>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: rootfs crash
References: <5236E1FF.4080900@mur.at>
In-Reply-To: <5236E1FF.4080900@mur.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear all,

After trying all the suggested options from

   http://permalink.gmane.org/gmane.comp.file-systems.btrfs/27999

I still get no mountable file system :(

Trying to mount I get

mount -oro,recovery,compress=lzo /dev/sda3 /rootfs

[  906.835314] btrfs: enabling auto recovery
[  906.836977] btrfs: use lzo compression
[  906.838611] btrfs: disk space caching is enabled
[  906.843788] btrfs: mismatching generation and generation_v2 found in 
root item. This root was probably mounted with an older kernel. 
Resetting all new fields.
[  906.898440] Btrfs detected SSD devices, enabling SSD mode
[  906.900352] parent transid verify failed on 71744598016 wanted 103531 
found 103528
[  906.902288] parent transid verify failed on 71744598016 wanted 103531 
found 103528
[  906.986653] btrfs: open_ctree failed
mount: mounting /dev/sda3 on /rootfs failed: Invalid argument

I am limited to working with the tools the Debian initramfs provides.  
This means kernel 3.10.2 (Debian 3.10.7-1) and btrfs-tools  
0.19+20130705-1.  The latter seems to be up to date with git although 
`btrfs version` says v0.20 rc1. All this is happening on an Asus Zen 
book  UX32V with two 128GB SSDs.

If anyone is interested in images produced by btrfs-image, they are 
available at

   http://plagi.at/images/

I am fresh out of ideas at the moment, so if anyone has a suggestion I 
am willing to try.

Regards!
-- 
j.hofmüller


