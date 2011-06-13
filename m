From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [GIT PULL] Btrfs updates
Date: Sun, 12 Jun 2011 18:02:54 -0700
Message-ID: <m262oar1a9.fsf@firstfloor.org>
References: <1307879298-sup-3080@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1307879298-sup-3080@shiny> (Chris Mason's message of "Sun, 12
	Jun 2011 07:57:34 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason@oracle.com> writes:

> Hi everyone,
>
> The for-linus branch of the btrfs unstable tree:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.gi=
t for-linus

>
> Has our current queue of fixes.  Josef's is the biggest pile, mostly =
in
> the allocator.  Josef and I both managed to merge his patch to avoid
> mapping the extent buffer if skip_locking was set, git merge is just =
a
> little too easy sometimes (I double checked the resulting code).

The new in 3.0 btrfs warnings on every build are still there:

fs/btrfs/sysfs.c:76: warning: =E2=80=98btrfs_root_attrs=E2=80=99 define=
d but not used
fs/btrfs/sysfs.c:97: warning: =E2=80=98btrfs_super_attrs=E2=80=99 defin=
ed but not used
fs/btrfs/sysfs.c:153: warning: =E2=80=98btrfs_super_release=E2=80=99 de=
fined but not used  =20
fs/btrfs/sysfs.c:160: warning: =E2=80=98btrfs_root_release=E2=80=99 def=
ined but not used

These are not even used inside any ifdef. It's unclear to me: were
these supposed to be used or removed?

Probably better to remove since they seem to be untested, unless
it was a merge error?

-Andi

--=20
ak@linux.intel.com -- Speaking for myself only
