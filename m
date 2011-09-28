From: Arne Jansen <sensille@gmx.net>
Subject: Re: [GIT PULL] scrub updates for 3.2
Date: Wed, 28 Sep 2011 15:19:13 +0200
Message-ID: <4E831ED1.6040907@gmx.net>
References: <4E831E7B.9090300@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E831E7B.9090300@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 28.09.2011 15:17, Arne Jansen wrote:
> Hi Chris,
> 
> I rebased my readahead-patches for scrub to your current
> integration-test branch (83f4e90fd11) and pushed it to:
> 
> git@github.com:sensille/linux.git for-chris

git://github.com/sensille/linux.git for-chris

of course...

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
>  fs/btrfs/reada.c     |  949 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/scrub.c     |  116 +++----
>  fs/btrfs/volumes.c   |    8 +
>  fs/btrfs/volumes.h   |    8 +
>  12 files changed, 1239 insertions(+), 75 deletions(-)
>  create mode 100644 fs/btrfs/reada.c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

