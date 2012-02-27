From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Subject: Re: [BUG] Kernel Bug at fs/btrfs/volumes.c:3638
Date: Sun, 26 Feb 2012 23:42:58 -0500
Message-ID: <20120226234258.522ee56e@Bidule>
References: <4F476959.2010400@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, chris.mason@oracle.com,
	kamalesh@linux.vnet.ibm.com, Liu Bo <liubo2009@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F476959.2010400@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 24 Feb 2012 16:11:29 +0530
Nageswara R Sastry <rnsastry@linux.vnet.ibm.com> wrote:

> Hello,
> 
> While working with 'fsfuzz - file system fuzzing tool' on 'btrfs' 
> encountered the following kernel bug.

I inquired about robustness a while ago and it seems it's at some point on the horizon, but not now.
My concern was about hot-unplugged disk drives, but btrfs also doesn't appreciate meta-data corruption.
btrfs-raid users could be concerned, because contrarily to on a real RAID, the btrfs meta-data is a potential weak link.

At some point, I would appreciate some kind of thorough evaluation using a fuzzer on small disk images.
The btrfs developers could for instance:
- provide a script to create a filesystem image with a known layout (known corpus)
- provide .config and reference to kernel sources to build the kernel
- provide a minimal root filesystem to be run under qemu, it would run a procedure on the other disk image at boot
  crashes wouldn't affect the host, which is good.
- provide a way to retrieve the test parameters and results for every test case
  in case of bug, the test can be reproduced by the developers since the configuration is known
- expect volunteers to run the scenarios (I know I would)
The tricky part is of course the potentially super-costly procedure...
Simplest case: flipping every bit / writing blocks with pseudo-random data, even on meta-data only, as the outcome on data is supposed to be known.
Smarter: flipping bits on every btrfs meta-data structure type at every possible logical location.

The kind of stuff that would help all this could be something like Python bindings for a *btrfs library*.
Helpful even for prototyping fsck stuff, making illustrations, etc.

As of today, how are btrfs developers testing the filesystem implementation (except with xfstests) ?

Best regards,

-- 
cJ

PS: don't be mistaken, I'm not asking for all that, just suggesting.
My time goes to something else, but I do have sleepy computers at home, and they could help.
