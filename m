From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Sat, 8 Jan 2011 15:36:50 +0100
Message-ID: <AANLkTin4BTH-1CfNtEt8CTspGJ9vJ_9mokP4hBM7c0Dw@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Massimo Maggi <massimo@mmmm.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Thomas Bellman <bellman@nsc.liu.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D2769A7.8000803@nsc.liu.se>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 8:29 PM, Thomas Bellman <bellman@nsc.liu.se> wro=
te:
> What is the visibility of the changes for other processes supposed
> to be in the meantime? =C2=A0I.e., if things happen in this order:

Should be atomic too, at close time.

> 1. Process A does fda =3D open("foo.txt", O_TRUNC|O_ATOMIC)
> 2. Process B does fdb =3D open("foo.txt", O_RDONLY)
> 3. B does read(fdb, buf, 4096)
> 4. A does write(fda, "NEW DATA\n", 9)
> 5. Process C comes in and does fdc =3D open("foo.txt", O_RDONLY)
> 6. C does read(fdc, buf, 4096)
> 7. A calls close(fda)
>
> Does B see an empty file, or does it see the old contents of
> the file?

Old file, otherwise A wouldn't be atomic.

> Does C see "NEW DATA\n", or does it see the old
> contents of the file, or perhaps an empty file?

Old file again, as the 'transaction' isn't finished until close.

--=20
Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
