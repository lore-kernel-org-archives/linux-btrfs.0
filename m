Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51283 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751990AbaF1APE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 20:15:04 -0400
Message-ID: <53AE08FA.8000404@fb.com>
Date: Fri, 27 Jun 2014 17:14:50 -0700
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Also seeing full deadlocks with 3.15.1
References: <20140627185009.GA21428@merlins.org> <53ADF1D8.9060309@fb.com> <20140627235933.GG28692@merlins.org>
In-Reply-To: <20140627235933.GG28692@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/27/2014 04:59 PM, Marc MERLIN wrote:
> On Fri, Jun 27, 2014 at 03:36:08PM -0700, Josef Bacik wrote:
>> On 06/27/2014 11:50 AM, Marc MERLIN wrote:
>>> My laptop deadlocked some more times (everything works until it needs to
>>> touch the filesystem, and then it's deadlocked).
>>> Unfortunately, I can trigger sysrq, but it doesn't get committed to disk and
>>> netconsole eats half of it because it goes too fast for UDP apparently
>>>
>>> Now, I just captured that on my server with serial console.
>>>
>>> 11005  1-16:11:10 wait_current_trans.isra.15     /usr/bin/zma -m 3
>>> 14441  1-16:07:44 wait_current_trans.isra.15     /usr/bin/zma -m 1
>>> 17045  1-23:53:33 wait_current_trans.isra.15     /usr/bin/zma -m 9
>>> 22261  2-00:40:36 wait_current_trans.isra.15     /usr/bin/zma -m 6
>>> 22292  2-00:40:36 wait_current_trans.isra.15     /usr/bin/zma -m 8
>>>
>>> 19911    09:29:35 wait_current_trans.isra.15     rm -f -- /mnt/dshelf2/backup/0Notmachines/mysql//mysql.daily.sql.gz.13 /mnt/dshelf2/backup/0Notmachines/mysql//mysql.daily.sql.gz.13.gz
>>> 22848  1-05:18:35 wait_current_trans.isra.15     rm -f -- mnt/dshelf2/backup/0Notmachines/jen//backup.tar.bz.11 mnt/dshelf2/backup/0Notmachines/jen//backup.tar.bz.11.gz
>>>
>>> Those are 2 different filesystems (one single device mapper disk, the other one is btrfs raid1), so I'm not sure which one of the 2 caused the problem, but I'm perplexed as to why one would than hang the other, unless they both hit the same bug?
>>>
>>> The sysrq-w output is here:
>>> https://urldefense.proofpoint.com/v1/url?u=http://marc.merlins.org/tmp/btrfs-hang.txt&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=CZ0ka0XcM6ZpRAF31LYBziutfoecu9ODO78jo5Kb2JQ%3D%0A&s=6213c6dc2c99166a71f262a1804bc7135ca17bffd8b9de175f655ed2a6a54f10
>>>
>>> but here is one hung process:
>>>   zma		D 0000000000000003     0 22292	    1 0x20020084
>>>    ffff880074733bb0 0000000000000082 ffff8800c933f270 ffff880074733fd8
>>>    ffff8801853b4610 00000000000141c0 ffff8801aac60f00 ffff880036caa9e8
>>>    0000000000000000 ffff880036caa800 ffff8801db59f0c0 ffff880074733bc0
>>>   Call Trace:
>>>    [<ffffffff8161d3c6>] schedule+0x73/0x75
>>>    [<ffffffff8122a87b>] wait_current_trans.isra.15+0x98/0xf4
>>>    [<ffffffff810847ed>] ? finish_wait+0x65/0x65
>>>    [<ffffffff8122bd95>] start_transaction+0x498/0x4fc
>>>    [<ffffffff8122be14>] btrfs_start_transaction+0x1b/0x1d
>>>    [<ffffffff8123602a>] btrfs_create+0x3c/0x1ce
>>>    [<ffffffff81298985>] ? security_inode_permission+0x1c/0x23
>>>    [<ffffffff8115e93e>] ? __inode_permission+0x79/0xa4
>>>    [<ffffffff8115fbfc>] vfs_create+0x66/0x8c
>>>    [<ffffffff8116095e>] do_last+0x5af/0xa23
>>>    [<ffffffff81161009>] path_openat+0x237/0x4de
>>>    [<ffffffff81162408>] do_filp_open+0x3a/0x7f
>>>    [<ffffffff8161faeb>] ? _raw_spin_unlock+0x17/0x2a
>>>    [<ffffffff8116c3eb>] ? __alloc_fd+0xea/0xf9
>>>    [<ffffffff8115499d>] do_sys_open+0x70/0xff
>>>    [<ffffffff81194e20>] compat_SyS_open+0x1b/0x1d
>>>    [<ffffffff8162842c>] sysenter_dispatch+0x7/0x21
>>>
>>> As per the other thread, I'm happy to test a patch against 3.15, but not hot about switching to a likely even less stable 3.16 since it's a real server with real data.
>>>
>>
>> A few other people have complained about this, I've not been able to reproduce
>> it but I have a patch you can try.  It will make it so the box doesn't deadlock
>> anymore but I still need the output, look for "timed out", thats when you need
>> to dump the logs and send it to me.  The patch is here
>
> Mmmh, I applied the patch, but now I'm getting tens of thousands of the lines below.
> The machine is so unresponsive (due to serial port speed limitation and
> amount of console spamming) that I cannot even ssh into it.
> Example output below. I have to back that kernel out, it's unusable and
> I'm not sure what output I can get you out of it.

Oh yeah I should have mentioned that, it's going to spit out a metric shittone
of stuff.  No worries, you had a lot more info in your sysrq+w, I'm hoping I can
get this to reproduce next week.  Thanks,

Josef
