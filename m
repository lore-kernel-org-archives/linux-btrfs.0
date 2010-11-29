From: C Anthony Risinger <anthony@extof.me>
Subject: Re: [GIT PULL][PATCH v2 0/6] btrfs: Add lzo compression support
Date: Mon, 29 Nov 2010 11:54:14 -0600
Message-ID: <AANLkTin4VPOXBOU9fM5CVqSSnwMMrUCoDqoYu5mKWXLL@mail.gmail.com>
References: <4CE48ABB.5070302@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CE48ABB.5070302@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 17, 2010 at 8:08 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Hi Chris,
>
> Here's the updated patchset. As I still haven't got a kernel.org
> account, I have set up a git tree in another public git repository,
> and I'll use it for now.
>
> You can pull from:
>
> =A0 =A0 =A0 =A0git://repo.or.cz/linux-btrfs-devel.git lzo-support
>
>
> Lzo is a much faster compression algorithm than gzib, so would allow
> more users to enable transparent compression, and some users can
> choose from compression ratio and compression speed.
>
> Usage:
>
> # mount -t btrfs -o compress[=3D<zlib,lzo>] dev /mnt
> or
> # mount -t btrfs -o compress-force[=3D<zlib,lzo>] dev /mnt
>
> "-o compress" without argument is still allowed for compatability.
>
> Compatibility:
>
> If we mount a filesystem with lzo compression, it will not be able be
> mounted in old kernels. One reason is, otherwise btrfs will directly
> dump compressed data, which sits in inline extent, to user.
>
> Performance:
>
> The test copied a linux source tarball (~400M) from an ext4 partition
> to the btrfs partition, and then extracted the tarball.
>
> (time in second)
> =A0 =A0 =A0 =A0 =A0 lzo =A0 =A0 =A0 =A0zlib =A0 =A0 =A0 =A0nocompress
> copy: =A0 =A0 =A010.6 =A0 =A0 =A0 21.7 =A0 =A0 =A0 =A014.9
> extract: =A0 70.1 =A0 =A0 =A0 94.4 =A0 =A0 =A0 =A066.6
>
> (data size in MB)
> =A0 =A0 =A0 =A0 =A0 lzo =A0 =A0 =A0 =A0zlib =A0 =A0 =A0 =A0nocompress
> copy: =A0 =A0 =A0185.87 =A0 =A0 108.69 =A0 =A0 =A0394.49
> extract: =A0 193.80 =A0 =A0 132.36 =A0 =A0 =A0381.21
>
> Test:
>
> Mitch has tested the patchset, and provided some positive feedback.
> According to him, the patchset works as expected and nothing bad
> has he experienced.
>
> Other:
>
> The defrag ioctl is also updated, so one can choose lzo or zlib when
> turning on compression in defrag operation.
>
> Main change from v1:
>
> - Add incompat flag.
> - Fix build issue by selecting kernel lzo module.
> - Check compression type in defrag ioctl.
>
> ---------------->
> Li Zefan (6):
> =A0 =A0 =A0btrfs: Fix bugs in zlib workspace
> =A0 =A0 =A0btrfs: Fix error handling in zlib
> =A0 =A0 =A0btrfs: Allow to add new compression algorithm
> =A0 =A0 =A0btrfs: Add lzo compression support
> =A0 =A0 =A0btrfs: Allow to specify compress method when defrag
> =A0 =A0 =A0btrfs: Extract duplicate decompress code
>
> =A0fs/btrfs/Makefile =A0 =A0 =A0 | =A0 =A02 +-
> =A0fs/btrfs/btrfs_inode.h =A0| =A0 =A02 +-
> =A0fs/btrfs/compression.c =A0| =A0329 +++++++++++++++++++++++++++++++=
++++++-
> =A0fs/btrfs/compression.h =A0| =A0 72 ++++++--
> =A0fs/btrfs/ctree.h =A0 =A0 =A0 =A0| =A0 11 +-
> =A0fs/btrfs/extent_io.c =A0 =A0| =A0 =A05 +-
> =A0fs/btrfs/extent_io.h =A0 =A0| =A0 17 ++-
> =A0fs/btrfs/extent_map.c =A0 | =A0 =A02 +
> =A0fs/btrfs/extent_map.h =A0 | =A0 =A03 +-
> =A0fs/btrfs/file.c =A0 =A0 =A0 =A0 | =A0 =A02 +
> =A0fs/btrfs/inode.c =A0 =A0 =A0 =A0| =A0 82 ++++++----
> =A0fs/btrfs/ioctl.c =A0 =A0 =A0 =A0| =A0 10 +-
> =A0fs/btrfs/ioctl.h =A0 =A0 =A0 =A0| =A0 =A09 +-
> =A0fs/btrfs/lzo.c =A0 =A0 =A0 =A0 =A0| =A0409 +++++++++++++++++++++++=
++++++++++++++++++++++++
> =A0fs/btrfs/ordered-data.c | =A0 18 ++-
> =A0fs/btrfs/ordered-data.h | =A0 =A08 +-
> =A0fs/btrfs/super.c =A0 =A0 =A0 =A0| =A0 47 +++++-
> =A0fs/btrfs/zlib.c =A0 =A0 =A0 =A0 | =A0361 +++++++------------------=
----------------
> =A018 files changed, 1013 insertions(+), 376 deletions(-)

is this in a branch somewhere?  or for inclusion in .37/.38?  this is
a very attractive feature.

what's the proper place (repo/branch) to see what is pending?

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
