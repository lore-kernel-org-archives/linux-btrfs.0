Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:35554 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932273AbdBGUkT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 15:40:19 -0500
Received: by mail-ua0-f178.google.com with SMTP id y9so94323781uae.2
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 12:40:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fb3187d8-16f5-9a84-d0ce-d048f1ac5cc7@gmail.com>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <579c53e4-f993-dd85-b5a4-76a0b201b899@suse.com> <CA+RUij2QOP=bJos8p6NswZqSdbhwZ7frTdaLtZaiGBc4vKajCg@mail.gmail.com>
 <fb3187d8-16f5-9a84-d0ce-d048f1ac5cc7@gmail.com>
From: Peter Zaitsev <pz@percona.com>
Date: Tue, 7 Feb 2017 15:40:12 -0500
Message-ID: <CA+RUij1ewf7gt1s=MgDV0m6yqkLqJUTj+T6N40v+z7FRpS2TsA@mail.gmail.com>
Subject: Re: BTRFS for OLTP Databases
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin,

I recognize there are other components too.  In this case I'm actually
comparing BTRFS to XFS and EXT4 so I'm 100% sure it is file system
related.   Also I'm using O_DIRECT   asynchronous IO with MySQL which
means there are no significant dirty block size on the file system
level.

I'll see if it helps though

Also I assumed this is something well known as it is documented in Gotchas here:

https://btrfs.wiki.kernel.org/index.php/Gotchas

(Fragmentation section)




>
> It's worth keeping in mind that there is more to the storage stack than just
> the filesystem, and BTRFS tends to be more sensitive to the behavior of
> other components in the stack than most other filesystems are.  The stalls
> you're describing sound more like a symptom of the brain-dead writeback
> buffering defaults used by the VFS layer than they do an issue with BTRFS
> (although BTRFS tends to be a  bit more heavily impacted by this than most
> other filesystems).  Try fiddling with the /proc/sys/vm/dirty_* sysctls
> (there is some pretty good documentation in Documentation/sysctl/vm.txt in
> the kernel source) and see if that helps.  The default values it uses are at
> most 20% of RAM, which is an insane amount of data to buffer before starting
> writeback when you're talking about systems with 16GB of RAM.
>


-- 
Peter Zaitsev, CEO, Percona
Tel: +1 888 401 3401 ext 7360   Skype:  peter_zaitsev
