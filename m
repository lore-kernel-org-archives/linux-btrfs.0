Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-dm3nam03on0050.outbound.protection.outlook.com ([104.47.41.50]:55728
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751040AbeBIQpb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Feb 2018 11:45:31 -0500
To: linux-btrfs@vger.kernel.org
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Subject: btrfs-cleaner / snapshot performance analysis
Message-ID: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
Date: Fri, 9 Feb 2018 11:45:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I am trying to better understand how the cleaner kthread (btrfs-cleaner) 
impacts foreground performance, specifically during snapshot deletion. 
My experience so far has been that it can be dramatically disruptive to 
foreground I/O.

Looking through the wiki at kernel.org I have not yet stumbled onto any 
analysis that would shed light on this specific problem.  I have found 
numerous complaints about btrfs-cleaner online, especially relating to 
quotas being enabled.  This has proven thus far less than helpful, as 
the response tends to be "use less snapshots," or "disable quotas," both 
of which strike me as intellectually unsatisfying answers, especially 
the former in a filesystem where snapshots are supposed to be 
"first-class citizens."

The 2007 and 2013 Rodeh papers don't do the thorough practical snapshot 
performance analysis I would expect to see given the assertions in the 
latter that "BTRFS...supports efficient snapshots..."  The former is 
sufficiently pre-BTRFS that while it does performance analysis of btree 
clones, it's unclear (to me at least) if the results can be 
forward-propagated in some way to real-world performance expectations 
for BTRFS snapshot creation/deletion/modification.

Has this analysis been performed somewhere else and I'm just missing it? 
  Also, I'll be glad to comment on my specific setup, kernel version, 
etc, and discuss pragmatic work-arounds, but I'd like to better 
understand the high-level performance implications first.

Thanks in advance to anyone who can comment on this.  I am very inclined 
to read anything thrown at me, so if there is documentation I failed to 
read, please just send the link.

Best,

ellis
