Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32563 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755774AbbKSGOa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 01:14:30 -0500
Subject: Re: BTRFS Error - Rockstor
To: Scotty Edmonds <scotty@scottyedmonds.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Donald Pearson <donaldwhpearson@gmail.com>
References: <SN2PR07MB013A0D1DE3EC69CFAD9885ACF120@SN2PR07MB013.namprd07.prod.outlook.com>
 <SN2PR07MB013F045DB3B42E4AD8AA3D6CF120@SN2PR07MB013.namprd07.prod.outlook.com>
 <CAC=t97Cv01-8z-oA_pGea9RHQ6d53w=FLbuvpadB=m_LtTPiXw@mail.gmail.com>
 <SN2PR07MB01362A586F4293204E66FCFCF120@SN2PR07MB013.namprd07.prod.outlook.com>
 <CAC=t97AUVQ_Jk1aSmhHodF-Db7NjaUvD1pfbFokx+q_bg3QtxA@mail.gmail.com>
 <20151112225701.GD24333@carfax.org.uk>
 <SN2PR07MB01305858FEC051F986D3546CF110@SN2PR07MB013.namprd07.prod.outlook.com>
 <5645492B.9080808@cn.fujitsu.com>
 <SN2PR07MB013024CC746A3302C8FB614CF110@SN2PR07MB013.namprd07.prod.outlook.com>
 <56492C32.5000107@cn.fujitsu.com>
 <SN2PR07MB0138346652867F9CF76D90BCF1D0@SN2PR07MB013.namprd07.prod.outlook.com>
 <564AD8C5.2040609@cn.fujitsu.com>
 <SN2PR07MB0138CA2787C4F7D11B7CECDCF1D0@SN2PR07MB013.namprd07.prod.outlook.com>
 <564B1FD5.4060101@gmail.com>
 <SN2PR07MB013DC7E3D1F0FB1D5ED906ECF1C0@SN2PR07MB013.namprd07.prod.outlook.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <564D68C0.8010300@cn.fujitsu.com>
Date: Thu, 19 Nov 2015 14:14:24 +0800
MIME-Version: 1.0
In-Reply-To: <SN2PR07MB013DC7E3D1F0FB1D5ED906ECF1C0@SN2PR07MB013.namprd07.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Scotty Edmonds wrote on 2015/11/18 12:50 +0000:
> (gdb) run rescue chunk-recover -y /dev/sdg
> Starting program: /usr/sbin/btrfs rescue chunk-recover -y /dev/sdg
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib64/libthread_db.so.1".
> [New Thread 0x7ffff6f85700 (LWP 4140)]
> [New Thread 0x7ffff6784700 (LWP 4141)]
> [New Thread 0x7ffff5f83700 (LWP 4142)]
> [New Thread 0x7ffff5782700 (LWP 4143)]
> [New Thread 0x7ffff4f81700 (LWP 4144)]
> Scanning: 2441862246400 in dev0, 2068329484288 in dev1, 3000574365696 in dev2, 2233151475712 in dev3, 2449691725824 in dev4[Thread 0x7ffff5f83700 (LWP 4142) exited]
> Scanning: 2999962390528 in dev0, 2566459445248 in dev1, DONE in dev2, 2748207828992 in dev3, 3000592969728 in dev4[Thread 0x7ffff4f81700 (LWP 4144) exited]
> Scanning: 3000580788224 in dev0, 2567040225280 in dev1, DONE in dev2, 2748795932672 in dev3, DONE in dev4[Thread 0x7ffff6f85700 (LWP 4140) exited]
> Scanning: DONE in dev0, 2806774272000 in dev1, DONE in dev2, 3000592969728 in dev3, DONE in dev4[Thread 0x7ffff5782700 (LWP 4143) exited]
> Scanning: DONE in dev0, 3000592969728 in dev1, DONE in dev2, DONE in dev3, DONE in dev4[Thread 0x7ffff6784700 (LWP 4141) exited]
> Scanning: DONE in dev0, DONE in dev1, DONE in dev2, DONE in dev3, DONE in dev4
>
> Program received signal SIGFPE, Arithmetic exception.
> 0x00000000004273d8 in calc_stripe_length ()
> (gdb)

Good enough to fix the float point error.
The patch will come soon.

Thanks for the info and help from Austin.
Qu
>
> (gdb) bt
> #0  0x00000000004273d8 in calc_stripe_length ()
> #1  0x000000000043191e in btrfs_recover_chunk_tree ()
> #2  0x000000000042f473 in cmd_rescue_chunk_recover ()
> #3  0x000000000040ea72 in main ()
> (gdb)
>
> Thanks,
>
> Scotty Edmonds
> Scotty@ScottyEdmonds.com
>
> ________________________________________
> From: Austin S Hemmelgarn <ahferroin7@gmail.com>
> Sent: November-17-15 8:38 AM
> To: Scotty Edmonds; Qu Wenruo; Hugo Mills; Donald Pearson
> Cc: Btrfs BTRFS
> Subject: Re: BTRFS Error - Rockstor
>
> On 2015-11-17 03:08, Scotty Edmonds wrote:
>> Sorry, I'm not at all familiar with backtrace.
>>
> General procedure to get a backtrace on a system without core files:
> 1. Make sure you have debugging symbols installed for the program you
> want the backtrace for, and ideally any libraries it uses.  (These
> usually are in packages with names ending in -dbg or -debug.  In the
> case of btrfs, you'll probably need symbols for glibc, lzo, and zlib).
> 2. Start the program under gdb ('gdb /sbin/btrfs')
> 3. When gdb is done loading, type in 'start' followed by the arguments
> for the program (in this case, 'rescue chunk-recover -y /dev/sdg')
> 4. If gdb then says something about stopping at a breakpoint, enter the
> command 'continue'.
> 5. When the program being debugged crashes, you should get a backtrace
> from gdb, if not, you can enter the command 'bt' to tell it to dump a
> backtrace.
> 6. After copying the backtrace somewhere you can put it in an e-mail,
> you can exit gdb with the 'exit' command, it may complain about
> something still running, it's safe to tell it to kill this process.
>
> If instead you have your system configured for core dumps:
> 1. Make sure you have debugging symbols installed for the program you
> want the backtrace for, and ideally any libraries it uses.
> 2. Run gdb with the program and core file ('gdb /sbin/btrfs
> /path/to/core/file').
> 3. Enter the command 'bt to get a backtrace.
>
