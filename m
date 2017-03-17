Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:35225 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751306AbdCQS1B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 14:27:01 -0400
Received: by mail-it0-f44.google.com with SMTP id m27so31591701iti.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Mar 2017 11:26:51 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id 65sm4727352iop.21.2017.03.17.11.25.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Mar 2017 11:25:53 -0700 (PDT)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Thoughts on 'btrfs device stats' and security.
Message-ID: <f0bd54bf-930b-c489-8bd3-e3b5a4cc965e@gmail.com>
Date: Fri, 17 Mar 2017 14:25:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm currently working on a plugin for colllectd [1] to track per-device 
per-filesystem error rates for BTRFS volumes.  Overall, this is actually 
going quite well (I've got most of the secondary logic like matching 
filesystems to watch and parsing the data done already), but I've come 
across a rather nasty caveat on the actual data collection part.

As of right now, there are only two ways I can see to get this data:
1. Parse the output of `btrfs device stats` for the filesystem.
2. Make the same ioctl() call that `btrfs device stats` does and compose 
the data yourself.

In both cases, one of the following has to be the case:
1. You're running as root.
2. You're running SUID root.
3. You're running with CAP_SYS_ADMIN (I'm not 100% certain that this is 
the correct capability, but it appears to be the case from my testing).

In other words, you have to reduce the overall security of your system 
to be able to get this data which is itself not security sensitive for 
most intents and purposes.

Looking at this from the perspective of actual data collection, there 
are a handful of things that come to mind:
* You already know either device names or device-id's, because the ioctl 
is called per-device and uses one of those to identify the device to 
return data for (I'm not sure from reading the code which), so this 
aspect is by definition not sensitive data.
* While there are theoretically attacks that this data could be useful 
for, the only ones I can think of are largely pointless because they 
require write access to the underlying storage and provide information 
which would by definition already be available by other (more efficient 
and less obtrusive) means if you had such access.
* This is somewhat useful data for an admin who may not have root access 
to retrieve.
* The use of an ioctl makes it non-trivial to access this data.
* We already expose allocation data through /sys/fs/btrfs (in the 
per-filesystem `allocation` directory).

On this note, I'd like to propose that the error counters be exposed in 
some way through sysfs so you don't have to parse the output of `btrfs 
device stats` (and incur the fork()+exec() overhead) or fight with 
ioctls.  I would offer to work on this myself, but I have exactly zero 
experience with the kernel side of sysfs, very limited experience with 
kernel coding in general, and I'm not likely to have much (if any) time 
to work on this for quite a while.

[1] https://collectd.org/
