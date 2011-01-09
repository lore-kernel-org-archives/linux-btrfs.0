From: Thomas Bellman <bellman@nsc.liu.se>
Subject: Re: Atomic file data replace API
Date: Sun, 09 Jan 2011 19:56:20 +0100
Message-ID: <4D2A04D4.8020503@nsc.liu.se>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>	<1294412141-sup-1734@think>	<AANLkTi=Z1RCwMKSMRzg4fwN55ZQs4F91nNjdEfv6veyb@mail.gmail.com>	<1294412553-sup-9058@think>	<AANLkTimB-gpHFJMXY3TRcfxGJjwo94ffEVZSPw6746bC@mail.gmail.com>	<1294412980-sup-1924@think>	<AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com>	<4D274022.5070507@mmmm.it>	<AANLkTin=1LqF_qCu0SXM3sP0670HDSnCuw55A48hDJBd@mail.gmail.com>	<4D2769A7.8000803@nsc.liu.se>	<AANLkTin4BTH-1CfNtEt8CTspGJ9vJ_9mokP4hBM7c0Dw@mail.gmail.com>	<4D28DA67.6060404@nsc.liu.se> <AANLkTi=yMdPS8EKPQJubo3vO3wJWd09EY0HVO7aW_cjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Massimo Maggi <massimo@mmmm.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=yMdPS8EKPQJubo3vO3wJWd09EY0HVO7aW_cjA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Olaf van der Spek wrote:

> On Sat, Jan 8, 2011 at 10:43 PM, Thomas Bellman <bellman@nsc.liu.se> wrote:
>> So, basically database transactions with an isolation level of
>> "committed read", for file operations.  That's something I have
>> wanted for a long time, especially if I also get a rollback()
>> operation, but have never heard of any Unix that implemented it.
> 
> True, that's why this feature request is here.
> Note that it's (ATM) only about  single file data replace.

That particular problem was solved with the introduction of the
rename(2) system call in 4.2BSD a bit more than a quarter of a
century ago.  There is no need to introduce another, less flexible,
API for doing the same thing.

>> A separate commit() operation would be better than conflating it
>> with close().  And as I said, we want a rollback() as well.  And
>> a process that terminates without committing the transaction that
>> it is performing, should have the transaction automatically rolled
>> back.
> 
> What could you do between commit and close?

More write() operations, of course.  Just like you can continue
with more transactions after a COMMIT WORK call without having
to close and re-open the database in SQL.


	/Bellman
