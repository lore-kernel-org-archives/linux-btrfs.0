From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] another reader/writer lock for btrfs metadata
Date: Wed, 27 Jul 2011 10:13:44 +0200
Message-ID: <4E2FC8B8.3040307@gmx.net>
References: <1311618006-sup-1777@shiny> <1311643645-sup-5605@shiny> <1311717520-sup-188@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311717520-sup-188@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 27.07.2011 00:00, Chris Mason wrote:
> Excerpts from Chris Mason's message of 2011-07-25 21:28:30 -0400:
>> Excerpts from Chris Mason's message of 2011-07-25 14:34:49 -0400:
>>> Hi everyone,
>>>
>>> I've updated the integration-test branch to use this code instead.  It
>>> is a shiny new reader/writer lock built around rw spinlocks.  I've
>>> removed all the adaptive spinning and started trusting the hints btrfs
>>> already has about when blocks should block or spin.
>>
>> I tested with lockdep and looks like I've got a bug in btrfs_next_leaf's
>> lockdep handling.  So, please don't run this code with
>> CONFIG_DEBUG_LOCK_ALLOC turned on.  The bug is only in lockdep mode, so
>> we're fine with it off.
>>
>> I'll fix it up in the morning.
>
> Ok, I've rebased the btrfs integration-test branch to include fixes for
> the lockdep problems.  I've also adapted Tejun's lockdep class patch to
> the new code.  With this setup I'm not getting lockdep warnings, but I'm
> always looking for more bug reports.
>

My fs_mark test look strange. As I can't make sense of it and don't have
much time today to investigate, I just paste them here:

fs_mark with b249e55006c87f (pre-r/w-lock):
FSUse%        Count         Size    Files/sec     App Overhead
     16        65536        51200       9603.3          2064173
     27       131072        51200       7995.1          1710337
     37       196608        51200       8662.7          2046263
     47       262144        51200       8024.2          1876913
     58       327680        51200       7564.5          1593306

# btrfs fi df /mnt/fsm
Data: total=4.21GB, used=3.70GB
System: total=4.00MB, used=4.00KB
Metadata: total=520.00MB, used=65.24MB

fs_mark with integration-test:
FSUse%        Count         Size    Files/sec     App Overhead
     18        65536        51200       7617.4           882409
     34       131072        51200       6447.1           935868
     51       196608        51200       5697.7           938026
     63       262144        51200       7462.9           933696
     76       327680        51200       6807.7           921403

# btrfs fi df /mnt/fsm
Data: total=5.61GB, used=4.98GB
System: total=4.00MB, used=4.00KB
Metadata: total=520.00MB, used=77.04MB

Please note the different fs usage after a single fs_mark run with
the same parameters (fs_mark  -d  /mnt/fsm  -D  512  -t  16  -n  4096
-s  51200  -L5  -S0).
Maybe fs_mark just have some problems with accounting when running
in multiple threads.

-Arne
