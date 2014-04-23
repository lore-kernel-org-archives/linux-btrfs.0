Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:56393
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbaDWUoX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 16:44:23 -0400
Message-ID: <53582625.3030800@pobox.com>
Date: Wed, 23 Apr 2014 13:44:21 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: hung task timer + btrfs_convert or btrfs balance = OOPS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The first mount of a non-trivial file system after a btrfs_convert, or 
an ongoing btrfs balance operation containing large files may lead to an 
oops (and a pathologically damaged file system) if the hang check timer 
(CONFIG_DETECT_HUNG_TASK=y) is compiled into the linux kernel and not 
disabled.

I've had two systems destroyed after a btrfs_convert. After the 
conversion the first mount took several minutes. The hung task timer 
expired against some internal btrfs_daemon. I think it was 
'[btrfs-transacti]'. Said task then goes oops and the file system was 
chock full of errors. So many that I no longer trusted the conversion so 
mkfs.btrfs and restored from backup.

On another system the same thing happened after a successful convert and 
mount (I'd remembered to disable the timer during the first mount) when 
a btrfs balance was running.

Whatever is blocking in that task really ought not to do that for 2+ 
minutes and sleep on some data structure instead.

As it is, the two options are not happy together. Be sure to

echo 0 > /proc/sys/kernel/hung_task_timeout_secs

to disable the timer before doing a mount or balance after a 
btrfs_convert (and possibly a btrfs balance if it decides to move a very 
large file like a VM disk image).

