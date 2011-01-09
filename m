From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Sun, 9 Jan 2011 16:16:25 +0100
Message-ID: <AANLkTi=yMdPS8EKPQJubo3vO3wJWd09EY0HVO7aW_cjA@mail.gmail.com>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>
	<1294412141-sup-1734@think>
	<AANLkTi=Z1RCwMKSMRzg4fwN55ZQs4F91nNjdEfv6veyb@mail.gmail.com>
	<1294412553-sup-9058@think>
	<AANLkTimB-gpHFJMXY3TRcfxGJjwo94ffEVZSPw6746bC@mail.gmail.com>
	<1294412980-sup-1924@think>
	<AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com>
	<4D274022.5070507@mmmm.it>
	<AANLkTin=1LqF_qCu0SXM3sP0670HDSnCuw55A48hDJBd@mail.gmail.com>
	<4D2769A7.8000803@nsc.liu.se>
	<AANLkTin4BTH-1CfNtEt8CTspGJ9vJ_9mokP4hBM7c0Dw@mail.gmail.com>
	<4D28DA67.6060404@nsc.liu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Massimo Maggi <massimo@mmmm.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Thomas Bellman <bellman@nsc.liu.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D28DA67.6060404@nsc.liu.se>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 8, 2011 at 10:43 PM, Thomas Bellman <bellman@nsc.liu.se> wr=
ote:
> So, basically database transactions with an isolation level of
> "committed read", for file operations. =C2=A0That's something I have
> wanted for a long time, especially if I also get a rollback()
> operation, but have never heard of any Unix that implemented it.

True, that's why this feature request is here.
Note that it's (ATM) only about  single file data replace.

> A separate commit() operation would be better than conflating it
> with close(). =C2=A0And as I said, we want a rollback() as well. =C2=A0=
And
> a process that terminates without committing the transaction that
> it is performing, should have the transaction automatically rolled
> back.

What could you do between commit and close?

> I only have a very shallow knowledge about the internals of the
> Linux kernel in regards to filesystems, but I suspect that this
> could be implemented almost entirely within the VFS, and not need
> to touch the actual filesystems, as long as you are satisfied
> with a limited amount of transaction space (what fits in RAM +
> swap).
>
> I'm looking forward to your implementation. :-) =C2=A0Even though I
> suspect that it would be a rather large undertaking to implement...

I have no plans to work on an implementation.

--=20
Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
