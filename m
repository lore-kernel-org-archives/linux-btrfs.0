From: Thomas Bellman <bellman@nsc.liu.se>
Subject: Re: Atomic file data replace API
Date: Fri, 07 Jan 2011 20:29:43 +0100
Message-ID: <4D2769A7.8000803@nsc.liu.se>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>	<1294412141-sup-1734@think>	<AANLkTi=Z1RCwMKSMRzg4fwN55ZQs4F91nNjdEfv6veyb@mail.gmail.com>	<1294412553-sup-9058@think>	<AANLkTimB-gpHFJMXY3TRcfxGJjwo94ffEVZSPw6746bC@mail.gmail.com>	<1294412980-sup-1924@think>	<AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com>	<4D274022.5070507@mmmm.it> <AANLkTin=1LqF_qCu0SXM3sP0670HDSnCuw55A48hDJBd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Massimo Maggi <massimo@mmmm.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin=1LqF_qCu0SXM3sP0670HDSnCuw55A48hDJBd@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Olaf van der Spek wrote:

> On Fri, Jan 7, 2011 at 5:32 PM, Massimo Maggi <massimo@mmmm.it> wrote:
>> Are you suggesting to do:
>> 1)fopen with O_TRUNC, O_ATOMIC: returns fd to a temporary file
>> 2)application writes to that fd, with one or more system calls, in a
>> short time or in long time, at his will.
>> 3)at fclose (or even at fsync ) atomically swap "data pointer" of "real
>> file" with "temp file", then delete temp.In a transparent mode to
>> userland.  (something similar to e4defrag).
>> Is this sum up correct?
> 
> Almost. Swap should probably not be done at fsync time.
> Other open references (for example running executables) should be swapped too.

What is the visibility of the changes for other processes supposed
to be in the meantime?  I.e., if things happen in this order:

1. Process A does fda = open("foo.txt", O_TRUNC|O_ATOMIC)
2. Process B does fdb = open("foo.txt", O_RDONLY)
3. B does read(fdb, buf, 4096)
4. A does write(fda, "NEW DATA\n", 9)
5. Process C comes in and does fdc = open("foo.txt", O_RDONLY)
6. C does read(fdc, buf, 4096)
7. A calls close(fda)

Does B see an empty file, or does it see the old contents of
the file?  Does C see "NEW DATA\n", or does it see the old
contents of the file, or perhaps an empty file?


	/Bellman
