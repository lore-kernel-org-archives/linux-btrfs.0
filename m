From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Atomic file data replace API
Date: Sun, 09 Jan 2011 15:13:46 -0500
Message-ID: <4D2A16FA.3040009@cfl.rr.com>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>	<1294412141-sup-1734@think>	<AANLkTi=Z1RCwMKSMRzg4fwN55ZQs4F91nNjdEfv6veyb@mail.gmail.com>	<1294412553-sup-9058@think>	<AANLkTimB-gpHFJMXY3TRcfxGJjwo94ffEVZSPw6746bC@mail.gmail.com>	<1294412980-sup-1924@think>	<AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com>	<4D274022.5070507@mmmm.it>	<AANLkTin=1LqF_qCu0SXM3sP0670HDSnCuw55A48hDJBd@mail.gmail.com>	<4D2769A7.8000803@nsc.liu.se>	<AANLkTin4BTH-1CfNtEt8CTspGJ9vJ_9mokP4hBM7c0Dw@mail.gmail.com>	<4D28DA67.6060404@nsc.liu.se> <AANLkTi=yMdPS8EKPQJubo3vO3wJWd09EY0HVO7aW_cjA@mail.gmail.com> <4D2A04D4.8020503@nsc.liu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Olaf van der Spek <olafvdspek@gmail.com>,
	Massimo Maggi <massimo@mmmm.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Thomas Bellman <bellman@nsc.liu.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D2A04D4.8020503@nsc.liu.se>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/09/2011 01:56 PM, Thomas Bellman wrote:
> That particular problem was solved with the introduction of the
> rename(2) system call in 4.2BSD a bit more than a quarter of a
> century ago. There is no need to introduce another, less flexible,
> API for doing the same thing.

I'm curious if there are any BSD specifications that state that rename() 
has this behavior.  Ted Tso has been claiming that POSIX does not 
require this behavior in the face of a crash and that as a result, an 
application that relies on such behavior is broken, and needs to fsync() 
before rename().  This of course, makes replacing numerous files much 
slower, glacially so on btrfs.  There has been a great deal of 
discussion ok the dpkg mailing lists about it since plenty of people are 
upset that dpkg runs much slower these days than it used to, because it 
now calls fsync() before rename() in order to avoid breakage on ext4.

You can read more, including the rationale of why POSIX does not require 
this behavior at http://lwn.net/Articles/323607/.

I still say that preserving the order of the writes and rename is the 
only sane thing to do, whether POSIX requires it or not.
