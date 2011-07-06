From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] scrub updates for 3.1
Date: Wed, 06 Jul 2011 09:06:02 +0800
Message-ID: <4E13B4FA.8050008@cn.fujitsu.com>
References: <4E130AD7.2010300@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E130AD7.2010300@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

21:00, Arne Jansen worte:
> Hi Chris,
> 
> since rc-6 seems to be the last rc for 3.0 and in case you're already
> preparing your pull request for 3.1, can you please pull the following
> updates for scrub, based on your for-linus tree (2f7e33d432)?
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/arne/btrfs-unstable-arne.git
> for-chris
> 
> It just contains the readahead patch, which gives a significant
> performance improvement for scrub. Currently scrub is the only
> consumer.
> 
> Thanks,
> Arne
> 
> Arne Jansen (7):
>       btrfs: add an extra wait mode to read_extent_buffer_pages
>       btrfs: add READAHEAD extent buffer flag
>       btrfs: state information for readahead
>       btrfs: initial readahead code and prototypes
>       btrfs: hooks for readahead
>       btrfs: test ioctl for readahead

Do we really want this ioctl that is merely for testing some kernel
APIs in our upstream kernel?

>       btrfs: use readahead API for scrub
> 
>  fs/btrfs/Makefile    |    3 +-
>  fs/btrfs/ctree.h     |   21 ++
>  fs/btrfs/disk-io.c   |   85 +++++-
>  fs/btrfs/disk-io.h   |    2 +
>  fs/btrfs/extent_io.c |    9 +-
>  fs/btrfs/extent_io.h |    4 +
>  fs/btrfs/ioctl.c     |   93 +++++-
>  fs/btrfs/ioctl.h     |   16 +
>  fs/btrfs/reada.c     |  949
> ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/scrub.c     |  116 +++----
>  fs/btrfs/volumes.c   |    8 +
>  fs/btrfs/volumes.h   |    8 +
>  12 files changed, 1239 insertions(+), 75 deletions(-)
>  create mode 100644 fs/btrfs/reada.c
