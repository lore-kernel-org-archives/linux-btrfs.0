From: Dan Merillat <dan.merillat@gmail.com>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Tue, 8 Nov 2011 12:55:40 -0500
Message-ID: <CAPL5yKcDKnB+BaTdARSp80pGVr_W36cy9gNz=M-S8E3NyNDTQg@mail.gmail.com>
References: <20111106183851.GA4339@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111106183851.GA4339@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 6, 2011 at 1:38 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> Hi everyone,
>
> This pull request is pretty beefy, it ended up merging a number of lo=
ng
> running projects and cleanup queues. =A0I've got btrfs patches in the=
 new
> kernel.org btrfs repo. =A0There are two different branches with the s=
ame
> changes. =A0for-linus is against 3.1 and has also been tested against
> Linus' tree as of yesterday.

[91795.123286] device label ROOT devid 1 transid 3331 /dev/sdi2
[91795.123538] btrfs: open_ctree failed

=46S created on 3.1 (x64), mounted once on 3.2-rc1 (i386), got that
whenI tried to mount on 3.1 (x64) again.  Format change in 3.2 or
32/64 bit compatibility issues?
