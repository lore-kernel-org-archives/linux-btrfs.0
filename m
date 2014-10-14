Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:47328 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753373AbaJNRDC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 13:03:02 -0400
Message-ID: <543D555B.50708@pobox.com>
Date: Tue, 14 Oct 2014 09:54:51 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Random file system corruption in 3.17 (not BTRFS related...?)
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Howdy,

So I run several gentoo systems and I upgraded two of them to kernel 3.17.0

One using BTRFS for root.
One using ext3 for root (via the ext4 driver)

_Both_ systems exhibited strange behavior (long pauses and then hangs 
requiring hard-power) within several hours. Both then had random 
filesystem damage.

On the BTRFS system much of my browser settings for firefox were 
trashed, particularly the cookies and saved conifigurations for add-ons 
(like which sites had scripts enabled/disabled in no-script) etc.

On the ext3/4 system there were several corruptions including a 
pipe/special file with a large non-zero size that required I do a "fsck 
-fyD /dev/sda3" to repair. (one comment from fsck was that the 
pipe/special file "looked like a directory" or some such)

So I can say that corruption is taking place, but I suspect it is _not_ 
happening in the BTRFS specific code.

(ASIDE: both systems are older amd64 using built-in radeon display 
hardware.)

