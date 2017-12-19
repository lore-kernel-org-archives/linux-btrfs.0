Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:36963 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbdLSPnR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 10:43:17 -0500
Received: by mail-it0-f43.google.com with SMTP id d137so3261898itc.2
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 07:43:17 -0800 (PST)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id e36sm1340569itd.27.2017.12.19.07.43.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Dec 2017 07:43:14 -0800 (PST)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Netdata support for monitoring of BTRFS volumes.
Message-ID: <b5e53db3-f7ca-0958-25d4-4bea3e197f91@gmail.com>
Date: Tue, 19 Dec 2017 10:43:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For those who are interested in better monitoring, netdata [1] [2] has 
just merged support for low-level usage monitoring of BTRFS volumes.  It 
provides graphs for both physical on-disk usage by chunk type (both 
allocated and used) and per-chunk type graphs of usage as reported by 
`btrfs filesystem df`.  It also comes with a predefined alarm that fires 
when things are getting close to full.

While it's not in a release yet (it should be in the next release, but 
that may be a while since 1.9 just got released), the devs do a great 
job of keeping things stable enough that you can run the master branch 
off of Github in production.

For those who care about the low-level stuff, this is pulling allocation 
data out of /sys/fs/btrfs/<UUID>/allocation/.


[1] https://my-netdata.io/
[2] https://github.com/firehol/netdata
