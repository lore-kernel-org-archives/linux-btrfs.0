Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from phd-imap.ethz.ch ([129.132.80.51]:36538 "EHLO phd-imap.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169AbcCPORR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 10:17:17 -0400
Received: from localhost (phd-mailscan.ethz.ch [192.168.127.2])
	by phd-imap.ethz.ch (Postfix) with ESMTP id 3qQCxL71YgzjfK
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Mar 2016 15:07:50 +0100 (CET)
Received: from phd-mxin.ethz.ch ([IPv6:::ffff:192.168.127.53])
	by localhost (phd-mailscan.ethz.ch [::ffff:192.168.127.2]) (amavisd-new, port 10024)
	with LMTP id rgR8eEs0JDCK for <linux-btrfs@vger.kernel.org>;
	Wed, 16 Mar 2016 15:07:50 +0100 (CET)
Received: from [192.33.96.28] (auror.ethz.ch [192.33.96.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: schmid@phd-mxin.ethz.ch)
	by phd-mxin.ethz.ch (Postfix) with ESMTPSA id 3qQCxL63xPzQ4X
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Mar 2016 15:07:50 +0100 (CET)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Patrick Schmid <schmid@phys.ethz.ch>
Subject: btrfs replace status over 100%
Message-ID: <56E968B6.7030108@phys.ethz.ch>
Date: Wed, 16 Mar 2016 15:07:50 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all

I had to replace an 10TiB disk. The replacing works well, but the status 
shows me values over 100%!

   btrfs replace status -1 /export/backup/group/dphys
   209.5% done, 0 write errs, 0 uncorr. read errs

I use btrfs-progs version 4.0.1 (master) from
git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

and im running a 4.5.0-rc4 kernel from
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git

I had done some calculations and the deviation of the status value is 
around factor 4.

This mean 209.5% from the replace status is in real live only around 52.4%.

After source code digging, i stuck on the following kernel code lines:

fs/btrfs/dev-replace.c:674

case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
   srcdev = dev_replace->srcdev;
   args->status.progress_1000 = div_u64(dev_replace->cursor_left,
	div_u64(btrfs_device_get_total_bytes(srcdev), 1000));

is there a possibility that "dev_replace->cursor_left" and 
"btrfs_device_get_total_bytes(srcdev)" dont have the same unit?

or I'm totally wrong?

Thanks Patrick
-- 
Patrick Schmid  <schmid@phys.ethz.ch>     support: +41 44 633 2668
IT Services Group, HPT H 8                voice:   +41 44 633 3997
Departement Physik, ETH Zurich
CH-8093 Zurich, Switzerland
