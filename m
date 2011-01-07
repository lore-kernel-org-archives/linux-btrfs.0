From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Fri, 7 Jan 2011 17:34:52 +0100
Message-ID: <AANLkTin=1LqF_qCu0SXM3sP0670HDSnCuw55A48hDJBd@mail.gmail.com>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>
	<1294412141-sup-1734@think>
	<AANLkTi=Z1RCwMKSMRzg4fwN55ZQs4F91nNjdEfv6veyb@mail.gmail.com>
	<1294412553-sup-9058@think>
	<AANLkTimB-gpHFJMXY3TRcfxGJjwo94ffEVZSPw6746bC@mail.gmail.com>
	<1294412980-sup-1924@think>
	<AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com>
	<4D274022.5070507@mmmm.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Massimo Maggi <massimo@mmmm.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D274022.5070507@mmmm.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 5:32 PM, Massimo Maggi <massimo@mmmm.it> wrote:
> Are you suggesting to do:
> 1)fopen with O_TRUNC, O_ATOMIC: returns fd to a temporary file
> 2)application writes to that fd, with one or more system calls, in a
> short time or in long time, at his will.
> 3)at fclose (or even at fsync ) atomically swap "data pointer" of "re=
al
> file" with "temp file", then delete temp.In a transparent mode to
> userland. =C2=A0(something similar to e4defrag).
> Is this sum up correct?

Almost. Swap should probably not be done at fsync time.
Other open references (for example running executables) should be swapp=
ed too.

The new-file case has to be handled too.

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
