Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:46237 "EHLO
        smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752068AbdBHP5F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 10:57:05 -0500
Received: from smtp5.relay.ord1c.emailsrvr.com (localhost [127.0.0.1])
        by smtp5.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 19FA040319
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Feb 2017 10:46:22 -0500 (EST)
Received: by smtp5.relay.ord1c.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id BCA02402F9
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Feb 2017 10:46:21 -0500 (EST)
To: linux-btrfs@vger.kernel.org
From: Marat Khalili <mkh@rqc.ru>
Subject: partial quota rescan
Message-ID: <f2600743-a0ac-3afe-0597-9081d3cb976e@rqc.ru>
Date: Wed, 8 Feb 2017 18:46:19 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm using  trying to use qgroups to keep track of storage occupied by 
snapshots. I noticed that:
a) no two rescans can run in parallel, and there's no way to schedule 
another rescan while one is running;
b) seems like it's a whole-disk operation regardless of path specified 
in CLI.

I only just started to fill my new 24Tb btrfs volume using qgroups, but 
rescans already take a long time, and due to (a) above I each time have 
to wait for previous rescan to finish in my scripts. Can anything be 
done about it, like trashing and recomputing only statistics for 
specific qgroup?

Linux host 4.4.0-62-generic #83-Ubuntu SMP Wed Jan 18 14:10:15 UTC 2017 
x86_64 x86_64 x86_64 GNU/Linux
btrfs-progs v4.4

-- 
--

With Best Regards,
Marat Khalili
