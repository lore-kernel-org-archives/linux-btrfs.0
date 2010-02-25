From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [2.6.33 regression] btrfs mount causes memory corruption
Date: Thu, 25 Feb 2010 21:38:38 +0000
Message-ID: <6278d2221002251338x6d235485t832ea6238272b9a7@mail.gmail.com>
References: <cb0375e11002251201v7969b891n687f928e2402f7c9@mail.gmail.com>
	 <20100225202358.GC10960@localhost.localdomain>
	 <cb0375e11002251229q2a6989c5n64d739dec4f8de44@mail.gmail.com>
	 <20100225203834.GD10960@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andrew Lutomirski <luto@mit.edu>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100225203834.GD10960@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 25, 2010 at 8:38 PM, Josef Bacik <josef@redhat.com> wrote:
> On Thu, Feb 25, 2010 at 03:29:34PM -0500, Andrew Lutomirski wrote:
>> On Thu, Feb 25, 2010 at 3:23 PM, Josef Bacik <josef@redhat.com> wrot=
e:
>> > On Thu, Feb 25, 2010 at 03:01:08PM -0500, Andrew Lutomirski wrote:
>> >> Mounting btrfs corrupts memory and causes nasty crashes within a =
few
>> >> seconds. =A0This seems to happen even if the mount fails (note th=
e
>> >> unrecognized mount option). =A0This is a regression from 2.6.32, =
and
>> >> I've attached an example.
>> >>
>> >
>> > And it only happens when you mount a btrfs fs? =A0Can you show me =
a trace of when
>> > you mount a btrfs fs with valid mount options? =A0I'd like to see =
if we're not
>> > cleaning up something properly or what. =A0Thanks,
>>
>> Seems OK. =A0Or maybe I just got lucky, but it's crashed every time =
I
>> tried to mount with 'acl' before.
>>
>> I even went through a couple iterations of trying to mount with
>> 'xattr' and 'user_xattr', both of which failed.
>>
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

The patch is good, and the same as I was testing to fix this issue I
found a day before with -rc8.

Thanks,
  Daniel
--=20
Daniel J Blueman
