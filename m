Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7954 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753455AbaA1B1I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 20:27:08 -0500
Message-ID: <52E70763.6020209@fb.com>
Date: Mon, 27 Jan 2014 20:26:59 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs send 4-5 times slower than rsync on local
References: <52E62358.8030406@gmail.com>
In-Reply-To: <52E62358.8030406@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/27/2014 04:14 AM, Konstantinos Skarlatos wrote:
> Hello, i am using btrfs send to copy a snapshot to another btrfs 
> filesystem on the same machine, and it has a maximum speed of 
> 30-35MByte/sec.
> Incredibly rsync is much faster, at 120-140MB/sec. Source btrfs is a 
> 5x2TB raid 0 and target is 1x4TB.
>
> mount options: rw,noatime,compress-force=zlib,space_cache
> kernel is linux-3.13.0-rc6-git and btrfs tools is built from git at 
> about the same time linux-3.13.0-rc6 was released

I just sent a patch titled

[PATCH] Btrfs: only process as many file extents as there are refs

that should make this better.  Also you are giving throughput but not 
actual times.  How much time does it take to do a send vs an rsync.  We 
may be sending less info across and therefore be done faster but at 
lower rates than rsync.  Before this patch rsync won in my test case but 
only barely, and with this patch I'm 3 times faster than rsync even 
though I bet it's getting better throughput. Thanks,

Josef
