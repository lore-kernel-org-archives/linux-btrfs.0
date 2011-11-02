From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH] Btrfs-progs: mention libattr dependency in INSTALL file
Date: Wed, 2 Nov 2011 22:42:43 +0200
Message-ID: <20111102204243.GA23532@zambezi.lan>
References: <1320246873-25457-1-git-send-email-idryomov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1320246873-25457-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 02, 2011 at 05:14:33PM +0200, Ilya Dryomov wrote:
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  INSTALL |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/INSTALL b/INSTALL
> index 6afbd90..11c388b 100644
> --- a/INSTALL
> +++ b/INSTALL
> @@ -19,7 +19,8 @@ insmod btrfs.ko
>  
>  The Btrfs utility programs require libuuid to build.  This can be found
>  in the e2fsprogs sources, and is usually available as libuuid or
> -e2fsprogs-devel from various distros.
> +e2fsprogs-devel from various distros.  The other dependency is libattr
> +(libattr1-dev in Debian-based distros).
>  
>  Building the utilities is just make ; make install.  The programs go
>  into /usr/local/bin.  The mains commands available are:
> -- 
> 1.7.6.3

Scratch that, it seems it's indeed not needed.  The thing is that every
time a set up a new test machine I have to install libattr1-dev, but I
never looked into it in detail.

So libattr1-dev is needed because mkfs includes attr/xattr.h to be able
to create FS from image with extended attributes.  I think it's safe to
change attr/xattr.h include to sys/xattr.h and thus get rid of this
build dependency.  (attr/xattr.h seems to be there for compatibility
with SGI IRIX)

I built mkfs with sys/xattr.h and created FS from directory containing
files with xattrs, it worked.

Thanks,

		Ilya
