From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [patch 1/5] btrfs-progs: convert to autotools
Date: Sat, 14 Jun 2008 01:22:22 -0400
Message-ID: <4853558E.7070204@suse.com>
References: <20080613200906.180149089@suse.com>	 <20080613201007.641785953@suse.com> <f058a9c30806131909m177bf1d4id296afd7340af363@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Miguel Sousa Filipe <miguel.filipe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30806131909m177bf1d4id296afd7340af363@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Miguel Sousa Filipe wrote:
> Hi all!
> 
> On Fri, Jun 13, 2008 at 9:09 PM, Jeff Mahoney <jeffm@jeffreymahoney.com> wrote:
>>  This patch converts the btrfs-progs build system from a single Makefile
>>  to the autotools suite.
>>
>>  The advantages are:
>>  Easier construction of Makefiles
>>  Easier to breakout the source into separate directories for easier management
>>  Easier to build shared libraries automatically
>>  Automatic checking for optional libraries, like libext2fs for btrfs-convert
>>  Automatic infrastructure for installing and testing
>>
>>  The caveats are:
>>  Opinions on autotools are... mixed.
>>  make C=1 no longer works, but is replaced by make check.
> 
> Please make this optional..
> I would really prefer the simple makefile that it has now..
> If the proposed advantages are a wanted feature, I would gladly try to
> supply patches for the makefile to support them..
> Just to keep it away from autotool hell.

Yeah, the one-time 10 seconds of ./configure can be annoying while it
sanity checks your system, but how is a 70-line Makefile better than a
5-line Makefile.am? While it does essentially the same thing?
Infrastructure exists for a reason.

I'm not a huge fan of autotools either. It's heavy and annoying at
times. It can be inflexible as I rediscovered while trying to make C=1
work. On the other hand, I'm not so much of a purist that I want to
commit anyone who touches the code to understanding a maze of
Makefile(s) either.

This is the next generation file system for Linux. The reality is that
there is competition from other OSes. How is it a bad thing to make
things easier for potential developers to access the code? Initially
there may be a number of shy folks who just want a library they can work
with. Yes, the library will change as things progress. Making things
like extending it and installing it easier can only be a good thing.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkhTVY4ACgkQLPWxlyuTD7Iz/wCfRxoHAxGZbSk6aPgrO5IRjtpZ
TxoAnih5zTXfgq6QLUrNtQwJkG4I4e1G
=flaT
-----END PGP SIGNATURE-----
