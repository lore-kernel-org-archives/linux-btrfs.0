From: Chris Samuel <chris@csamuel.org>
Subject: Re: btrfs and load (sys)
Date: Thu, 24 Nov 2011 12:00:10 +1100
Message-ID: <4ECD971A.2050808@csamuel.org>
References: <CAJ1PRSnhqo3yU4b0sbcYLfByb_pTDuAOL2xo4fryiEoacr8iYg@mail.gmail.com>	<20111123205616.73b4d0a7@natsu> <CAJ1PRSk4cker8WbSL5t9sKYde=f4XRAkQGQVYVC=8wnJKT8EwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRSk4cker8WbSL5t9sKYde=f4XRAkQGQVYVC=8wnJKT8EwQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 24/11/11 02:08, krzf83@gmail.com wrote:

> Linux sv15.vipserv.org 3.0.4-xxxx-std-ipv6-64 #1 SMP Mon Oct 10
> 01:07:40 CEST 2011 x86_64 x86_64 x86_64 GNU/Linux

You're running quite an old kernel btrfs wise - it would be
very interesting to see if you have the same issue with Linus's
current git version (which has the latest btrfs code) or
wait for 3.2-rc3.

Another possibility I *think* is that you could try 3.1 with
Chris Mason's for-linus git branch pulled into it.  Hopefully
someone who knows the procedure better than I can correct me
on this! :-)

There's a lot of work gone on both in fixing up corruption
issues on power loss and also reducing a lot of unnecessary
I/O that was happening due to bugs since that release.

cheers!
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
