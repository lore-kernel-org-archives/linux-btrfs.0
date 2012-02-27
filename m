From: David Sterba <dave@jikos.cz>
Subject: Re: [BUG] Kernel Bug at fs/btrfs/volumes.c:3638
Date: Mon, 27 Feb 2012 15:52:17 +0100
Message-ID: <20120227145217.GP1046@twin.jikos.cz>
References: <4F476959.2010400@linux.vnet.ibm.com> <20120226234258.522ee56e@Bidule>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org,
	Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, chris.mason@oracle.com,
	kamalesh@linux.vnet.ibm.com, Liu Bo <liubo2009@cn.fujitsu.com>
To: =?iso-8859-1?B?Suly9G1l?= Carretero <cJ-ko@zougloub.eu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120226234258.522ee56e@Bidule>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 26, 2012 at 11:42:58PM -0500, J=E9r=F4me Carretero wrote:
> At some point, I would appreciate some kind of thorough evaluation us=
ing a fuzzer on small disk images.
> The btrfs developers could for instance:
> - provide a script to create a filesystem image with a known layout (=
known corpus)
> - provide .config and reference to kernel sources to build the kernel
> - provide a minimal root filesystem to be run under qemu, it would ru=
n a procedure on the other disk image at boot
>   crashes wouldn't affect the host, which is good.
> - provide a way to retrieve the test parameters and results for every=
 test case
>   in case of bug, the test can be reproduced by the developers since =
the configuration is known
> - expect volunteers to run the scenarios (I know I would)
> The tricky part is of course the potentially super-costly procedure..=
=2E
> Simplest case: flipping every bit / writing blocks with pseudo-random=
 data, even on meta-data only, as the outcome on data is supposed to be=
 known.
> Smarter: flipping bits on every btrfs meta-data structure type at eve=
ry possible logical location.

There is a dangerdonteveruse(tm) utility btrfs-corrupt-block able to
target at specific metadata structure and corrupt it, with the fsck
counterpart for the rescue. I believe we'll see more updates in that
area.

The block checksums are supposed to catch bitflips after they were
written down to device (provided the data were correct up to the
checksum point).

If you're talking about random bitflips in metadata structures during
processing, that's very likely to crash in many ways of course. I think
some logic needs to be added to those corruptions and accompanied by th=
e
fsck part.

> The kind of stuff that would help all this could be something like Py=
thon bindings for a *btrfs library*.
> Helpful even for prototyping fsck stuff, making illustrations, etc.

We could see btrfsprogs turn into a library + tool, someday. Added to
project page.

> As of today, how are btrfs developers testing the filesystem implemen=
tation (except with xfstests) ?

If there is a patch fixing particular bug, I try to set up environment
stressing exactly that bug (and sometimes finding another one ...). The
xfstests suite is a must before any testing. There are common loads
raising the chances to hit a bug like repeated snapshots (and deletions=
),
exhausting data/metadata space, 'fi defrag', 'fi sync', 'fi balance'.

Sometimes it's enough to run a specific xfstest in a loop. I have set o=
f
hackish scripts doing just these tasks or wrappers around xfstests to
create filesystem with desired raid levels (where applicable) and let
the suite run on top of it.

Another dimension of testing are mount options, there are some
combinations likely to execrise specific parts of code, or create files
in a way that may confuse different mount options (like nodatasum).

We've seen btrfs-specific tests added to xfstests, so it's mostly
changing the outer environment for the testsuite.


david
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
