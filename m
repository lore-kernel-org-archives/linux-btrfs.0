From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Sun, 9 Jan 2011 20:06:06 +0100
Message-ID: <AANLkTimt8nuSoh5aqOH-ArOqt=es0GC6mi+gXndiGkEe@mail.gmail.com>
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
	<AANLkTi=yMdPS8EKPQJubo3vO3wJWd09EY0HVO7aW_cjA@mail.gmail.com>
	<4D2A04D4.8020503@nsc.liu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Massimo Maggi <massimo@mmmm.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Thomas Bellman <bellman@nsc.liu.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D2A04D4.8020503@nsc.liu.se>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 9, 2011 at 7:56 PM, Thomas Bellman <bellman@nsc.liu.se> wro=
te:
>> True, that's why this feature request is here.
>> Note that it's (ATM) only about =C2=A0single file data replace.
>
> That particular problem was solved with the introduction of the
> rename(2) system call in 4.2BSD a bit more than a quarter of a
> century ago. =C2=A0There is no need to introduce another, less flexib=
le,
> API for doing the same thing.

You might want to read about the problems with that workaround.

>> What could you do between commit and close?
>
> More write() operations, of course. =C2=A0Just like you can continue
> with more transactions after a COMMIT WORK call without having
> to close and re-open the database in SQL.

The transaction is defined as beginning with open and ending with close=
=2E
--=20
Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
