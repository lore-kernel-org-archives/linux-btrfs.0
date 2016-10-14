Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:35242 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754498AbcJNM1C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 08:27:02 -0400
Received: by mail-lf0-f44.google.com with SMTP id l131so151495860lfl.2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Oct 2016 05:27:02 -0700 (PDT)
Subject: Re: btrfs and numa - needing drop_caches to keep speed up
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <818cbe6c-fe7a-7542-3bc8-76b205c9b80b@profihost.ag>
From: Julian Taylor <jtaylor.debian@googlemail.com>
Message-ID: <a358938d-aef4-f2c7-942b-6cee3d1d774e@googlemail.com>
Date: Fri, 14 Oct 2016 14:26:55 +0200
MIME-Version: 1.0
In-Reply-To: <818cbe6c-fe7a-7542-3bc8-76b205c9b80b@profihost.ag>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/14/2016 08:28 AM, Stefan Priebe - Profihost AG wrote:
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
>
> Greets,
> Stefan

hi,
why do you think this is related to btrfs?

The only known issue that has this type of workaround that I know of are 
transparent huge pages.
This is easy to diagnose but recording some kernel stacks during the 
problem with perf.
If there is very high system cpu usage in a spinlock called by 
compaction functions during page faults it is the synchronous memory 
defragmentation needed for thp.
Should that be the case the better workaround is disabling it in 
/sys/kernel/mm/transparent_hugepage/defrag

cheers,
Julian
