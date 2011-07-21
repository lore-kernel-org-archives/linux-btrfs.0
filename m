From: Arne Jansen <sensille@gmx.net>
Subject: Re: new metadata reader/writer locks in integration-test
Date: Thu, 21 Jul 2011 07:44:01 +0200
Message-ID: <4E27BCA1.6030508@gmx.net>
References: <1311096438-sup-1263@shiny> <1311182478-sup-9986@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311182478-sup-9986@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 20.07.2011 19:21, Chris Mason wrote:
> Excerpts from Chris Mason's message of 2011-07-19 13:30:22 -0400:
>> Hi everyone,
>>
>> I've pushed out a new integration-test branch, and it includes a new
>> reader/writer locking scheme for the btree locks.
>>
>> We've seen a number of benchmarks dominated by contention on the root
>> node lock.  This changes our locks into a simple reader/writer lock.
>> They are based on mutexes so that we still take advantage of the mutex
>> adaptive spins for write locks (rwsemaphores were much slower).
>>
>> I'm also sending the individual commits, please do take a look.
> 
> Hi everyone,
> 
> I just rebased Josef's enospc fixes into integration-test, it should fix
> the warnings in extent-tree.c
> 

With the current integration-test branch I get very early enospc on
a 7G volume create with -m single -d single and

fs_mark-3.3/fs_mark -d /mnt/fsm -D 512 -t 16 -n 4096 -s 51200 -L5 -S0 -R1

It enospces at about 20%, but I can continue to fill it up to 94%.

-Arne
