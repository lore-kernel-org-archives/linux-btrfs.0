From: Andrew Lutomirski <luto@mit.edu>
Subject: Re: [2.6.33 regression] btrfs mount causes memory corruption
Date: Thu, 25 Feb 2010 15:48:21 -0500
Message-ID: <cb0375e11002251248h17f46468x9a5c3bab0e8bf60d@mail.gmail.com>
References: <cb0375e11002251201v7969b891n687f928e2402f7c9@mail.gmail.com>
	<20100225202358.GC10960@localhost.localdomain> <cb0375e11002251229q2a6989c5n64d739dec4f8de44@mail.gmail.com>
	<20100225203834.GD10960@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100225203834.GD10960@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 25, 2010 at 3:38 PM, Josef Bacik <josef@redhat.com> wrote:
>
> Ok it looks like we have a problem kfree'ing the wrong stuff. =A0we k=
strdup the
> options string, but then strsep screws with the pointer, so when we k=
free() it,
> we're not giving it the right pointer. =A0Please try this patch, and =
mount with -o
> acl and other such garbage to make sure it actually worked (acl isn't=
 a valid
> mount option btw). =A0Let me know if it works. =A0Thanks,
>
> Josef
>
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 8a1ea6e..f8b4521 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -128,7 +128,7 @@ int btrfs_parse_options(struct btrfs_root *root, =
char *options)
> =A0{
> =A0 =A0 =A0 =A0struct btrfs_fs_info *info =3D root->fs_info;
> =A0 =A0 =A0 =A0substring_t args[MAX_OPT_ARGS];
> - =A0 =A0 =A0 char *p, *num;
> + =A0 =A0 =A0 char *p, *num, *orig;
> =A0 =A0 =A0 =A0int intarg;
> =A0 =A0 =A0 =A0int ret =3D 0;
>
> @@ -143,6 +143,7 @@ int btrfs_parse_options(struct btrfs_root *root, =
char *options)
> =A0 =A0 =A0 =A0if (!options)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
>
> + =A0 =A0 =A0 orig =3D options;
>
> =A0 =A0 =A0 =A0while ((p =3D strsep(&options, ",")) !=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int token;
> @@ -280,7 +281,7 @@ int btrfs_parse_options(struct btrfs_root *root, =
char *options)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> =A0out:
> - =A0 =A0 =A0 kfree(options);
> + =A0 =A0 =A0 kfree(orig);
> =A0 =A0 =A0 =A0return ret;
> =A0}
>
>


Thanks for the instant patch.  I hammered on it a bit and it hasn't
crashed yet.  I'll let you know if it crashes later.  (The earlier
trial with xattr crashed after a couple minutes.)

In the mean time,

Tested-by: Andy Lutomirski <luto@mit.edu>

--Andy
