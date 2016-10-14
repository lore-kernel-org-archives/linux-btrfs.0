Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:35219 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752013AbcJNMtH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 08:49:07 -0400
Received: by mail-io0-f170.google.com with SMTP id i202so119063680ioi.2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Oct 2016 05:48:35 -0700 (PDT)
Subject: Re: btrfs and numa - needing drop_caches to keep speed up
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <818cbe6c-fe7a-7542-3bc8-76b205c9b80b@profihost.ag>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56016a39-5ebf-5f3f-f07d-b4557a131568@gmail.com>
Date: Fri, 14 Oct 2016 08:48:30 -0400
MIME-Version: 1.0
In-Reply-To: <818cbe6c-fe7a-7542-3bc8-76b205c9b80b@profihost.ag>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-10-14 02:28, Stefan Priebe - Profihost AG wrote:
> Hello list,
>
> while running the same workload on two machines (single xeon and a dual
> xeon) both with 64GB RAM.
>
> I need to run echo 3 >/proc/sys/vm/drop_caches every 15-30 minutes to
> keep the speed as good as on the non numa system. I'm not sure whether
> this is related to numa.
>
> Is there any sysctl parameter to tune?
>
> Tested with vanilla v4.8.1
This may sound odd, but does echoing 1 or 2 to /proc/sys/vm/drop_caches 
help at all, or is it just 3?   The value itself is actually a bit-field 
with just two bits defined.  1 just drops the page-cache, while 2 just 
drops freeable SLAB objects, and 3 drops both.  The thing is, both have 
an impact when dealing with filesystems (page-cache contains cached file 
contents, while freeable SLAB objects includes cached dentries and 
inodes), so knowing whether one or the other or only both is what's 
helping things can help diagnose this further.

Regardless of that, you might try adjusting vm.vfs_cache_pressure. 
Increasing that will make the page-cache reclaim more aggressive, while 
decreasing it will make it less aggressive.  It defaults to 100, and I 
wouldn't suggest setting it below 50 or above about 150.  Keep in mind 
that increasing that will mean you're likely to put more load on the 
storage devices.

