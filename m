From: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: Btrfs progs git repo on kernel.org
Date: Fri, 28 Oct 2011 10:23:19 +0800
Message-ID: <4EAA1217.50904@oracle.com>
References: <20111027152707.GA11028@shiny.Mikenopa.local> <20111027155854.GK29548@carfax.org.uk> <20111027213258.GA25582@shiny.Mikenopa.local> <20111027214811.GL29548@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Hugo Mills <hugo@carfax.org.uk>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111027214811.GL29548@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


>>>     I've also got the basis of a set of regression tests for -progs,
>>> which I'll send out patches for in the next couple of days. At the
>>> moment, it only tests building and snapshots, but should be relatively
>>> easily extensible to the other bits of ./btrfs (although I'm not sure
>>> how we can easily and repeatably test the recovery tools).
>>
>> Please talk with Anand Jain on the test programs, he has been making
>> scripts for xfs-tests.
>
>     Will do, although I think we're aiming at different things. I'm
> very definitely *not* attempting to test the filesystem itself with my
> test harness. I just want to exercise all the bits of the userspace
> tools that I can. (This was primarily triggered by the mess
> surrounding the parsing of "btrfs sub snap" parameters).

  Testing the (btrfs) CLI wasn't aimed in the xfs-tests instead the
  FS itself.
  Appears that btrfs CLI syntax-change is upcoming what we might also
  need is a CLI to check the version of both btrfs and btrfs-progs
  to ensure tools surrounding them will report -incompatible instead
  of syntax error.

thanks. -Anand
