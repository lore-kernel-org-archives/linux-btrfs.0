Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:53724 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbdIORJC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 13:09:02 -0400
Received: by mail-it0-f47.google.com with SMTP id 85so4207032ith.2
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 10:09:01 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id r16sm697109ioa.83.2017.09.15.10.08.59
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Sep 2017 10:08:59 -0700 (PDT)
Subject: Re: A user cannot remove his readonly snapshots?!
To: linux-btrfs@vger.kernel.org
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <38b35e41-313a-1eed-667a-ee3138c8170d@gmail.com>
Date: Fri, 15 Sep 2017 13:08:55 -0400
MIME-Version: 1.0
In-Reply-To: <20170915163736.GD32347@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-15 12:37, Ulli Horlacher wrote:
> I have my btrfs filesystem mounted with option user_subvol_rm_allowed
> 
> tux@xerus: btrfs --version
> btrfs-progs v4.4
> 
> tux@xerus: uname -a
> Linux xerus 4.4.0-93-generic #116-Ubuntu SMP Fri Aug 11 21:17:51 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
> 
> tux@xerus: id
> uid=1000(tux) gid=100(users) groups=100(users)
> 
> tux@xerus: btrfs subvolume snapshot -r /test/tux/zz /test/tux/zz/.snapshot/2017-09-15_1824.test
> tux@xerus: btrfs subvolume delete /test/tux/zz/.snapshot/2017-09-15_1824.test
> Delete subvolume (no-commit): '/test/tux/zz/.snapshot/2017-09-15_1824.test'
> ERROR: cannot delete '/test/tux/zz/.snapshot/2017-09-15_1824.test': Read-only file system
> 
> root can delete this snapshot, but not the user. Why?
> 
Add 'user_subvol_rm' to the mount options and try again.

It's because of a poor decision made regarding permissions surrounding 
subvolume operations.  The original argument was to prevent accidental 
data loss (stupid argument, rm -rf is just as bad and nearly as fast on 
most modern systems), and that behavior has never been changed.  In 
fact, I'd advocate using that option on everything, because otherwise 
you have trivial resource exhaustion issues (users can create a resource 
they then can't remove).  Ideally, normal users wouldn't be able to 
create or delete subvolumes unless explicitly allowed (possibly through 
delegation by ownership or something).
