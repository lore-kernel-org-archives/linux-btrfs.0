From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [PATCH] Add the "btrfs filesystem label" command
Date: Wed, 15 Sep 2010 17:31:44 -0700
Message-ID: <AANLkTik85y4fbyhqw0DqV9x7TsVwo5uZZhLBHiy-oPsC@mail.gmail.com>
References: <201009132124.14402.kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	Felix Blanke <felixblanke@gmail.com>
To: kreijack@inwind.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201009132124.14402.kreijack@inwind.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 13, 2010 at 12:24 PM, Goffredo Baroncelli
<kreijack@gmail.com> wrote:
> +int get_label(char *btrfs_dev)
> +{
> +
> + =C2=A0 =C2=A0 =C2=A0 int ret;
> + =C2=A0 =C2=A0 =C2=A0 ret =3D check_mounted(btrfs_dev);
> + =C2=A0 =C2=A0 =C2=A0 if (ret < 0)
> + =C2=A0 =C2=A0 =C2=A0 {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr, "FA=
TAL: error checking %s mount status\n",
> btrfs_dev);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -1;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if(ret !=3D 0)
> + =C2=A0 =C2=A0 =C2=A0 {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr, "FA=
TAL: the filesystem has to be
> unmounted\n");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -2;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 get_label_unmounted(btrfs_dev);
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +

Why can't the label be read while the fs is mounted?  It shouldn't
hurt anything.  I can read the superblock on my ext3 fs while it's
mounted...  This is what people have come to expect.

> --- a/utils.c
> +++ b/utils.c
> @@ -638,6 +638,39 @@ int check_mounted(char *file)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> =C2=A0}
>
> +/* Gets the mount point of btrfs filesystem that is using the specif=
ied
> device.
> + * Returns 0 is everything is good, <0 if we have an error.
> + * TODO: Fix this fucntion and check_mounted to work with multiple d=
rive
> BTRFS
> + * setups.
> + */

Typo: s/fucntion/function/g


> +int get_mountpt(char *dev, char *mntpt, size_t size)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct mntent *mnt;
> + =C2=A0 =C2=A0 =C2=A0 FILE *f;
> + =C2=A0 =C2=A0 =C2=A0 int ret =3D 0;
> +
> + =C2=A0 =C2=A0 =C2=A0 f =3D setmntent("/proc/mounts", "r");
> + =C2=A0 =C2=A0 =C2=A0 if (f =3D=3D NULL)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -errno;
> +
> + =C2=A0 =C2=A0 =C2=A0 while ((mnt =3D getmntent(f)) !=3D NULL )
> + =C2=A0 =C2=A0 =C2=A0 {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (strcmp(dev, mn=
t->mnt_fsname) =3D=3D 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 strncpy(mntpt, mnt->mnt_dir, size);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (mnt =3D=3D NULL)
> + =C2=A0 =C2=A0 =C2=A0 {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* We didn't find =
an entry so lets report an error */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -1;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 return ret;
> +}
> +
> =C2=A0struct pending_dir {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head list;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0char name[256];
> @@ -820,3 +853,27 @@ char *pretty_sizes(u64 size)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return pretty;
> =C2=A0}
>
> +/*
> + * Checks to make sure that the label matches our requirements.
> + * Returns:
> + =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0if everything is safe and usabl=
e
> + =C2=A0 =C2=A0 =C2=A0-1 =C2=A0 =C2=A0if the label is too long
> + =C2=A0 =C2=A0 =C2=A0-2 =C2=A0 =C2=A0if the label contains an invali=
d character
> + */
> +int check_label(char *input)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int i;
> + =C2=A0 =C2=A0 =C2=A0 int len =3D strlen(input);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (len > BTRFS_LABEL_SIZE) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < len; i++) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (input[i] =3D=3D=
 '/' || input[i] =3D=3D '\\') {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return -2;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}

How can one char equal two chars?

input[i] =3D=3D '\\'

This should never be able to happen.  Right?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
