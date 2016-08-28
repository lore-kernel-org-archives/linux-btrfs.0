Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34962 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753932AbcH1DiG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Aug 2016 23:38:06 -0400
Received: by mail-wm0-f44.google.com with SMTP id f65so37571766wmi.0
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Aug 2016 20:38:06 -0700 (PDT)
Received: from ?IPv6:2a01:5c0:1c:b661:e56d:b3b3:8ef7:7c7d? ([2a01:5c0:1c:b661:e56d:b3b3:8ef7:7c7d])
        by smtp.googlemail.com with ESMTPSA id ce6sm9546489wjc.27.2016.08.27.20.38.03
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Aug 2016 20:38:04 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Subject: btrfs send extremely slow (almost stuck)
Message-ID: <03b9d0b0-7001-7dd9-75cd-69d58b94d553@googlemail.com>
Date: Sun, 28 Aug 2016 05:38:00 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear btrfs experts, 

I just tried to make use of btrfs send / receive for incremental backups (using btrbk to simplify the process). 
It seems that on my two machines, btrfs send gets stuck after transferring some GiB - it's not fully halted, but instead of making full use of the available I/O, I get something < 500 kiB on average,
which are just some "full speed spikes" with many seconds / minutes of no I/O in between. 

During this "halting", btrfs send eats one full CPU core. 
A "perf top" shows this is spent in "find_parent_nodes" and "__merge_refs" inside the kernel. 
I am using btrfs-progs 4.7 and kernel 4.7.0. 

I googled a bit and found related patchwork (https://patchwork.kernel.org/patch/9238987/) which seems to workaround high load in this area and mentions a real solution is proposed but not yet there. 

Since this affects two machines of mine and backupping my root volume would take about 80 hours in case I can extrapolate the average rate, this means btrfs send is unusable to me. 

Can I assume this is a common issue which will be fixed in a later kernel release (4.8, 4.9) or can I do something to my FS's to workaround this issue? 

One FS is only two weeks old, the other one now about 1 year. I did some balancing at some points of time to have more unallocated space for trimming,
and used duperemove regularly to free space. One FS has skinny extents, the other has not. 

Mount options are "rw,noatime,compress=zlib,ssd,space_cache,commit=120". 

Apart from that: No RAID or any other special configuration involved. 

Cheers and any help appreciated, 
	Oliver
