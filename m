Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:45478 "EHLO
        smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751089AbdILICS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 04:02:18 -0400
Received: from smtp15.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp15.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 7D195539D
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 04:02:17 -0400 (EDT)
Received: by smtp15.relay.iad3a.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id 3018B5308
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 04:02:16 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id C8F8210578
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 08:02:12 +0000 (UTC)
From: Marat Khalili <mkh@rqc.ru>
Subject: qemu-kvm VM died during partial raid1 problems of btrfs
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
Date: Tue, 12 Sep 2017 11:02:13 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks to the help from the list I've successfully replaced part of 
btrfs raid1 filesystem. However, while I waited for best opinions on the 
course of actions, the root filesystem of one the qemu-kvm VMs went 
read-only, and this root was of course based in a qcow2 file on the 
problematic btrfs (the root filesystem of the VM itself is ext4, not 
btrfs). It is very well possible that it is a coincidence or something 
inducted by heavier than usual IO load, but it is hard for me to ignore 
the possibility that somehow the hardware error was propagated to VM. Is 
it possible?

No other processes on the machine developed any problems, but:
(1) it is very well possible that problematic sector belonged to this 
qcow2 file;
(2) it is a Kernel VM after all, and it might bypass normal IO paths of 
userspace processes;
(3) it is possible that it uses O_DIRECT or something, and btrfs raid1 
does not fully protect this kind of access.
Does this make any sense?

I could not login to the VM normally to see logs, and made big mistake 
of rebooting it. Now all I see in its logs is big hole, since, well, it 
went read-only :( I'll try to find out if (1) above is true after I 
finish migrating data from HDD and remove the it. I wonder where else 
can I look?

--

With Best Regards,
Marat Khalili
