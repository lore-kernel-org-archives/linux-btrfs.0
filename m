From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Subvolume listing feature for ioctl.
Date: Fri, 11 Dec 2009 15:57:18 -0500
Message-ID: <20091211205718.GP2191@localhost.localdomain>
References: <4B00ADE8.4090205@jp.fujitsu.com> <3d0408630911160015t79044d72u3489a42d57c6f844@mail.gmail.com> <4B011435.2080005@jp.fujitsu.com> <4B038897.3000605@jp.fujitsu.com> <4B038936.5020506@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: yanzheng@21cn.com, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B038936.5020506@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 18, 2009 at 02:42:14PM +0900, TARUISI Hiroaki wrote:
> New feature to list up subvolume/snapshots under
> specified tree of file is introduced to ioctl.
> 
> Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c |  283 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/ioctl.h |   29 +++++
>  2 files changed, 312 insertions(+)
> 

I've been using this patch to work with my subvolume mounting patches, and it
seems to have a problem where it will panic the box.  At first I thought it was
something that I did, but on a freshly mkfs'ed fs I can reproduce the panic
without doing any of the subvolume mounting weirdness.  If I do btrfsctl -l a
couple of times it will panic.  This most recent time I did a btrfsctl -l on an
empty fs, created a subvolume, did a list again, created another subvolume, and
tried to list again and the box paniced.  I don't have time to look into this
now, but I will look into it next week if you haven't had a chance to get to it
before then.  Thanks,

Josef
