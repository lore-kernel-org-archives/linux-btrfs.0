Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64668 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751550AbdDAPZK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 1 Apr 2017 11:25:10 -0400
Received: from [10.0.0.4] ([95.171.32.30]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MK17F-1csxSD2X2L-001Ozx for
 <linux-btrfs@vger.kernel.org>; Sat, 01 Apr 2017 17:25:08 +0200
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
From: Lukas Tribus <lukyt@gmx.net>
Subject: is send/receive
Message-ID: <f0776e88-95b6-de16-bc65-b016302b4e30@gmx.net>
Date: Sat, 1 Apr 2017 17:25:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello experts,


quick question about btrfs send/receive:

Is btrfs send/receive is prone to cause destination filesystem 
corruption/failure, when the source file system is bogus (due to bugs, 
or due to other factors like memory bit-flips happening, both *within* 
the source file system)?

Or asked differently: does send/receive transfer metadata/tree (which 
may be corrupt) from source to destination?


I would like to know if send/receive is a *completely* appropriate to 
backup data to a destination btrfs filesystem, or if there is a - even a 
one in a million - chance it may corrupt the destination FS. Would it be 
preferable to use a non-btrfs destination FS for backup purposes? What 
do you guys think?


Also, if I understand correctly, checksum are not transferred through 
send/receive, therefor a corruption while transferring is possible (just 
like with rsync), right?



Thanks,

Lukas



