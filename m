Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:52662 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751952AbdJaOvH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 10:51:07 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id EE19DFA0247
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 14:51:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 14:51:03 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 31 Oct 2017 23:51:03 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: how to run balance successfully (No space left on device)?
In-Reply-To: <c6c0eb84c550f44ffe443d625c198a39@wpkg.org>
References: <5ff267d206ae631e9d259eacacdf7924@wpkg.org>
 <19a1770cf67e63a84c3baeeb44af9e9a@wpkg.org>
 <c6c0eb84c550f44ffe443d625c198a39@wpkg.org>
Message-ID: <5b4f54bec31103dfe50049e6fa358238@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-31 23:18, Tomasz Chmielewski wrote:

> On a different server, however, it failed badly:
> 
> # time btrfs balance start /srv
> WARNING:
> 
>         Full balance without filters requested. This operation is very
>         intense and takes potentially very long. It is recommended to
>         use the balance filters to narrow down the scope of balance.
>         Use 'btrfs balance start --full-balance' option to skip this
>         warning. The operation will start in 10 seconds.
>         Use Ctrl-C to stop it.
> 10 9 8 7 6 5 4 3 2 1
> Starting balance without any filters.
> ERROR: error during balancing '/srv': Read-only file system
> There may be more info in syslog - try dmesg | tail
> 
> [312304.050731] BTRFS info (device sda4): found 15073 extents
> [313555.971253] BTRFS info (device sda4): relocating block group
> 1208022466560 flags data|raid1
> [314963.506580] BTRFS: Transaction aborted (error -28)
> [314963.506608] ------------[ cut here ]------------
> [314963.506639] WARNING: CPU: 2 PID: 27854 at
> /home/kernel/COD/linux/fs/btrfs/extent-tree.c:3089
> btrfs_run_delayed_refs+0x244/0x250 [btrfs]

(...)

> [314963.506955] BTRFS: error (device sda4) in
> btrfs_run_delayed_refs:3089: errno=-28 No space left
> [314963.507032] BTRFS info (device sda4): forced readonly
> [314963.510570] BTRFS warning (device sda4): Skipping commit of
> aborted transaction.
> [314963.510577] BTRFS: error (device sda4) in
> cleanup_transaction:1873: errno=-28 No space left
> [314970.954768] mail[32290]: segfault at c0 ip 00007f6b507ae33b sp
> 00007ffec4849ac0 error 4 in libmailutils.so.4.0.0[7f6b50724000+b0000]
> [314983.475988] BTRFS error (device sda4): pending csums is 167936


And btrfs balance can be a real database killer :(


root@backupslave01:/var/log/mysql# tail -f mysql-error.log
InnoDB: Doing recovery: scanned up to log sequence number 2206178343424
InnoDB: Doing recovery: scanned up to log sequence number 2206183586304
InnoDB: Doing recovery: scanned up to log sequence number 2206188829184
InnoDB: Doing recovery: scanned up to log sequence number 2206194072064
InnoDB: Doing recovery: scanned up to log sequence number 2206199314944
InnoDB: Doing recovery: scanned up to log sequence number 2206204557824
InnoDB: Doing recovery: scanned up to log sequence number 2206209800704
InnoDB: Doing recovery: scanned up to log sequence number 2206215043584
InnoDB: Doing recovery: scanned up to log sequence number 2206220286464
InnoDB: Doing recovery: scanned up to log sequence number 2206220752384

InnoDB: 1 transaction(s) which must be rolled back or cleaned up
InnoDB: in total 1 row operations to undo
InnoDB: Trx id counter is 21145843968
2017-10-31 14:46:59 4359 [Note] InnoDB: Starting an apply batch of log 
records to the database...
InnoDB: Progress in percent: 14:46:59 UTC - mysqld got signal 11 ;
This could be because you hit a bug. It is also possible that this 
binary
or one of the libraries it was linked against is corrupt, improperly 
built,
or misconfigured. This error can also be caused by malfunctioning 
hardware.
We will try our best to scrape up some info that will hopefully help
diagnose the problem, but since we have already crashed,
something is definitely wrong and this may fail.
Please help us make Percona Server better by reporting any
bugs at http://bugs.percona.com/

key_buffer_size=33554432
read_buffer_size=131072
max_used_connections=0
max_threads=502
thread_count=0
connection_count=0
It is possible that mysqld could use up to
key_buffer_size + (read_buffer_size + sort_buffer_size)*max_threads = 
232495 K  bytes of memory
Hope that's ok; if not, decrease some variables in the equation.

Thread pointer: 0x0
Attempting backtrace. You can use the following information to find out
where mysqld died. If you see no messages after this, something went
terribly wrong...
stack_bottom = 0 thread_stack 0x40000
/usr/sbin/mysqld(my_print_stacktrace+0x3b)[0x8d444b]
/usr/sbin/mysqld(handle_fatal_signal+0x49a)[0x649b0a]
/lib/x86_64-linux-gnu/libpthread.so.0(+0x11390)[0x7f74b90bf390]
/usr/sbin/mysqld[0x99fcae]
/usr/sbin/mysqld[0x9a17ed]
/usr/sbin/mysqld[0x9881ea]
/usr/sbin/mysqld[0x989fc7]
/usr/sbin/mysqld[0xa6dd87]
/usr/sbin/mysqld[0xab8cd8]
/usr/sbin/mysqld[0xa08300]
/lib/x86_64-linux-gnu/libpthread.so.0(+0x76ba)[0x7f74b90b56ba]
/lib/x86_64-linux-gnu/libc.so.6(clone+0x6d)[0x7f74b854a3dd]



Tomasz Chmielewski
https://lxadm.com
