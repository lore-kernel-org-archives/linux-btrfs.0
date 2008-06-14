From: Joe Peterson <lavajoe@gentoo.org>
Subject: Re: [patch 1/5] btrfs-progs: convert to autotools
Date: Sat, 14 Jun 2008 00:38:39 -0600
Message-ID: <4853676F.6050700@gentoo.org>
References: <20080613200906.180149089@suse.com>	 <20080613201007.641785953@suse.com>	 <f058a9c30806131909m177bf1d4id296afd7340af363@mail.gmail.com>	 <4853558E.7070204@suse.com> <7fe698080806132310v4573dac5neb0b64fa871f3c4b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Mahoney <jeffm@suse.com>,
	Miguel Sousa Filipe <miguel.filipe@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Dongjun Shin <djshin90@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7fe698080806132310v4573dac5neb0b64fa871f3c4b@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Dongjun Shin wrote:
> I expect Jeff's work will make it easier for distro (or anyone) to include
> btrfs and btrfs-progs as experimental packages. More people can test
> btrfs without worring about the build process and dependency.
> 
> However, I'm not sure if btrfs is ready for testing by non-developers.

:)

I've already put btrfs & btrgs-progs into Gentoo Linux, and I'm
naturally curious how many Gentoo users have tried it out as a result.
The packages are masked as "testing" (not stable), and they display the
"Btrfs is under heavy development..." warning, of course.

And Gentoo is used to handling autotools, so I can adjust the ebuild to
deal with this if needed.

Since Gentoo has its own way of specifying which kernel to build modules
against, as long as I can control this (I currently pass in a custom
"KERNELDIR"), things should work fine.

					-Joe
