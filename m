Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:38949 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbaLIMQu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 07:16:50 -0500
Received: by mail-wg0-f43.google.com with SMTP id l18so654903wgh.16
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Dec 2014 04:16:49 -0800 (PST)
Received: from [192.168.0.29] (ppp-94-67-38-174.home.otenet.gr. [94.67.38.174])
        by mx.google.com with ESMTPSA id fq1sm13596572wib.12.2014.12.09.04.16.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Dec 2014 04:16:48 -0800 (PST)
Message-ID: <5486E82A.6080301@gmail.com>
Date: Tue, 09 Dec 2014 14:16:42 +0200
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs scrub status misreports as "interrupted"
References: <20141122131318.05609d5f@marcec.fritz.box>
In-Reply-To: <20141122131318.05609d5f@marcec.fritz.box>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got the exact same problem, with a 4 drive RAID1. kernel 3.18-git 
and btrfs tools-git, all built yesterday.

On 22/11/2014 2:13 μμ, Marc Joliet wrote:
> Hi all,
>
> While I haven't gotten any "scrub already running" type errors any more, I do
> get one strange case of state misreport.  When running scrub on /home (btrfs
> RAID10), after 3 of 4 drives have completed, the 4th drive (sdb) will report as
> interrupted, despite still running:
>
> # btrfs scrub status -d /home
> scrub status for 472c9290-3ff2-4096-9c47-0612d3a52cef
> scrub device /dev/sda (id 1) history
> 	scrub started at Sat Nov 22 11:57:34 2014 and finished after 3380 seconds
> 	total bytes scrubbed: 252.86GiB with 0 errors
> scrub device /dev/sdb (id 2) status
> 	scrub started at Sat Nov 22 11:57:34 2014, interrupted after 3698 seconds, not running
> 	total bytes scrubbed: 217.50GiB with 0 errors
> scrub device /dev/sdc (id 3) history
> 	scrub started at Sat Nov 22 11:57:34 2014 and finished after 3013 seconds
> 	total bytes scrubbed: 252.85GiB with 0 errors
> scrub device /dev/sdd (id 4) history
> 	scrub started at Sat Nov 22 11:57:34 2014 and finished after 2994 seconds
> 	total bytes scrubbed: 252.85GiB with 0 errors
>
> The funny thing is, the time will still update as the scrub keeps going:
>
> # btrfs scrub status -d /home
> scrub status for 472c9290-3ff2-4096-9c47-0612d3a52cef
> scrub device /dev/sda (id 1) history
> 	scrub started at Sat Nov 22 11:57:34 2014 and finished after 3380 seconds
> 	total bytes scrubbed: 252.86GiB with 0 errors
> scrub device /dev/sdb (id 2) status
> 	scrub started at Sat Nov 22 11:57:34 2014, interrupted after 4136 seconds, not running
> 								     ^^^^^^^^^^^^
> 	total bytes scrubbed: 239.44GiB with 0 errors
> scrub device /dev/sdc (id 3) history
> 	scrub started at Sat Nov 22 11:57:34 2014 and finished after 3013 seconds
> 	total bytes scrubbed: 252.85GiB with 0 errors
> scrub device /dev/sdd (id 4) history
> 	scrub started at Sat Nov 22 11:57:34 2014 and finished after 2994 seconds
> 	total bytes scrubbed: 252.85GiB with 0 errors
>
> This has happened a few times, and when sdb finally finishes, the status is then
> reported correctly as "finished":
>
> # btrfs scrub status -d /home
> scrub status for 472c9290-3ff2-4096-9c47-0612d3a52cef
> scrub device /dev/sda (id 1) history
> 	scrub started at Sat Nov 22 11:57:34 2014 and finished after 3380 seconds
> 	total bytes scrubbed: 252.86GiB with 0 errors
> scrub device /dev/sdb (id 2) history
> 	scrub started at Sat Nov 22 11:57:34 2014 and finished after 4426 seconds
> 	total bytes scrubbed: 252.88GiB with 0 errors
> scrub device /dev/sdc (id 3) history
> 	scrub started at Sat Nov 22 11:57:34 2014 and finished after 3013 seconds
> 	total bytes scrubbed: 252.85GiB with 0 errors
> scrub device /dev/sdd (id 4) history
> 	scrub started at Sat Nov 22 11:57:34 2014 and finished after 2994 seconds
> 	total bytes scrubbed: 252.85GiB with 0 errors
>
> Kernel and btrfs-progs version:
>
> # uname -a
> Linux marcec 3.16.7-gentoo #1 SMP PREEMPT Fri Oct 31 22:45:54 CET 2014 x86_64 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD GNU/Linux
>
> # btrfs --version
> Btrfs v3.17.1
>
> Should I open a report on bugzilla?
>

