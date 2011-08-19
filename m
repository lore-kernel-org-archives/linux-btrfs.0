From: Josh Boyer <jwboyer@gmail.com>
Subject: Re: [build breakage] Re: [GIT PULL] Btrfs pull round two
Date: Fri, 19 Aug 2011 09:24:57 -0400
Message-ID: <CA+5PVA5QMZ3i7Pr1jsis+r4CeZZCWEt59oZXNhtf4Ea-yeAgGA@mail.gmail.com>
References: <1312315404-sup-6084@shiny>
	<20110819130615.GA6307@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110819130615.GA6307@kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 19, 2011 at 9:06 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Chris Mason <chris.mason@oracle.com> wrote:
>
>> Hi everyone,
>>
>> This has the rest of the btrfs cleanups for 3.1. =A0The bulk of this=
 is
>> error handing fixes from SUSE and cleanups from Fujitsu.
>
> I havent seen a lkml mail of this pull request:
>
> =A05c80c71b9a0e: Merge branch 'for-linus' of git://git.kernel.org/pub=
/scm/linux/kernel/git/mason/btrfs-unstable
>
> so i'm following up on this earlier pull request.
>
> the aptly named btrfs-unstable branch indeed does not even build on
> x86 defconfig (32-bit):
>
> =A0 LD =A0 =A0 =A0.tmp_vmlinux1
> =A0fs/built-in.o: In function `btrfs_can_relocate':
> =A0(.text+0x1d6605): undefined reference to `__udivdi3'
> =A0make: *** [.tmp_vmlinux1] Error 1
>
> and given that most of the commits:
>
> 81d86e1b7096: Merge branch 'btrfs-3.0' into for-linus
> f1e490a7ebe4: Btrfs: set i_size properly when fallocating and we alre=
ady
> 9a4327ca1f45: btrfs: unlock on error in btrfs_file_llseek()
> cb6db4e57632: btrfs: btrfs_permission's RO check shouldn't apply to d=
evice nodes
> f81c9cdc567c: Btrfs: truncate pages from clone ioctl target range
> 0e588859618b: Btrfs: fix uninitialized sync_pending
> bb3ac5a4dfc8: Btrfs: fix wrong free space information
> f4ac904c411b: btrfs: memory leak in btrfs_add_inode_defrag()
> c97c2916e25c: Btrfs: use plain page_address() in header fields setget=
 functions
> cb1b69f4508a: Btrfs: forced readonly when btrfs_drop_snapshot() fails
> cdcb725c05fe: Btrfs: check if there is enough space for balancing sma=
rter
> 38c01b960592: Btrfs: fix a bug of balance on full multi-disk partitio=
ns
> 34f3e4f23ca3: Btrfs: fix an oops of log replay
> d5e2003c2bcd: Btrfs: detect wether a device supports discard
> 93ee7a9340d6: Linux 3.1-rc2
>
> were committed after -rc2 and were at most a couple of hours old
> before you sent them off to Linus, did you really expect any other
> outcome than breaking upstream in trivial ways? :-)

=46YI, this was noticed and a patch was posted to linux-btrfs:

http://thread.gmane.org/gmane.comp.file-systems.btrfs/12673

Josef bugged them to send it upstream.

josh
