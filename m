From: Thomas Bellman <bellman@nsc.liu.se>
Subject: Re: Atomic file data replace API
Date: Sat, 08 Jan 2011 22:43:03 +0100
Message-ID: <4D28DA67.6060404@nsc.liu.se>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>	<1294412141-sup-1734@think>	<AANLkTi=Z1RCwMKSMRzg4fwN55ZQs4F91nNjdEfv6veyb@mail.gmail.com>	<1294412553-sup-9058@think>	<AANLkTimB-gpHFJMXY3TRcfxGJjwo94ffEVZSPw6746bC@mail.gmail.com>	<1294412980-sup-1924@think>	<AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com>	<4D274022.5070507@mmmm.it>	<AANLkTin=1LqF_qCu0SXM3sP0670HDSnCuw55A48hDJBd@mail.gmail.com>	<4D2769A7.8000803@nsc.liu.se> <AANLkTin4BTH-1CfNtEt8CTspGJ9vJ_9mokP4hBM7c0Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Massimo Maggi <massimo@mmmm.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin4BTH-1CfNtEt8CTspGJ9vJ_9mokP4hBM7c0Dw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Olaf van der Spek wrote:

> On Fri, Jan 7, 2011 at 8:29 PM, Thomas Bellman <bellman@nsc.liu.se> wrote:
>> What is the visibility of the changes for other processes supposed
>> to be in the meantime?  I.e., if things happen in this order:
> 
> Should be atomic too, at close time.
> 
>> 1. Process A does fda = open("foo.txt", O_TRUNC|O_ATOMIC)
>> 2. Process B does fdb = open("foo.txt", O_RDONLY)
>> 3. B does read(fdb, buf, 4096)
>> 4. A does write(fda, "NEW DATA\n", 9)
>> 5. Process C comes in and does fdc = open("foo.txt", O_RDONLY)
>> 6. C does read(fdc, buf, 4096)
>> 7. A calls close(fda)
>>
>> Does B see an empty file, or does it see the old contents of
>> the file?
> 
> Old file, otherwise A wouldn't be atomic.
> 
>> Does C see "NEW DATA\n", or does it see the old
>> contents of the file, or perhaps an empty file?
> 
> Old file again, as the 'transaction' isn't finished until close.

So, basically database transactions with an isolation level of
"committed read", for file operations.  That's something I have
wanted for a long time, especially if I also get a rollback()
operation, but have never heard of any Unix that implemented it.

A separate commit() operation would be better than conflating it
with close().  And as I said, we want a rollback() as well.  And
a process that terminates without committing the transaction that
it is performing, should have the transaction automatically rolled
back.

I only have a very shallow knowledge about the internals of the
Linux kernel in regards to filesystems, but I suspect that this
could be implemented almost entirely within the VFS, and not need
to touch the actual filesystems, as long as you are satisfied
with a limited amount of transaction space (what fits in RAM +
swap).

I'm looking forward to your implementation. :-)  Even though I
suspect that it would be a rather large undertaking to implement...


	/Bellman
