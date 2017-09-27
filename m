Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:39905 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752367AbdI0VrQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 17:47:16 -0400
Received: from localhost (unknown [192.168.1.197])
        by mail.linuxsystems.it (Postfix) with ESMTPSA id A9886B3D77
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 23:47:14 +0200 (CEST)
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: <linux-btrfs@vger.kernel.org>
Subject: Cannot fix btrfs errors after system crash
Date: Wed, 27 Sep 2017 23:47:04 +0200
MIME-Version: 1.0
Message-ID: <67acfe4b-e08b-44a2-8f1f-52676b1654b7@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I was trying to use AMDGPU-PRO's OpenCL stack (with the mainline 4.12.13 
kernel) while it suddently crashed the whole system, not even magic sysrq 
keys did work anymore.
With no surprise, at the next reboot I found several btrfs warnings (see 
https://paste.pound-python.org/show/S5zBG2tXZUTLG699saE5/).
Since btrfs scrub didn't find any error I decided to reboot into a live usb 
and start a btrfs check (I'm using btrfs-progs 4.13).
It did found lots of errors indeed (see 
https://paste.pound-python.org/show/IPxh9sly0EEb0MKPi2dw/).
So I made a full backup with dd and I started a btrfs check --repair (see 
https://paste.pound-python.org/show/c9AlT8ehKKJy6l5xhzXk/).
I also wiped the space cache with --clear-space-cache v1.
A subsequent btrfs check revealed it indeed fixed lots of errors (see 
https://paste.pound-python.org/show/1m2Wodd1q3n0eRlxLpZB/), but 
unfortunately i still have the following errors:

unresolved ref dir 7450239 index 2 namelen 6 name 431886 filetype 1 errors 
80, filetype mismatch
unresolved ref dir 7450595 index 2 namelen 6 name 431886 filetype 1 errors 
80, filetype mismatch
unresolved ref dir 7457122 index 2 namelen 6 name 431886 filetype 1 errors 
80, filetype mismatch

I'm already quite satisfied to be honest: two years ago repair used to eat 
my data, making things worse.
Anyway, why didn't btrfs-check repair them? Is there anything I can do to 
fix them?

Thanks,
Niccolò
